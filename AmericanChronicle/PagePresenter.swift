// MARK: -
// MARK: PagePresenterInterface protocol

protocol PagePresenterInterface: PageUserInterfaceDelegate, PageInteractorDelegate {
    var wireframe: PageWireframe? { get set }
    func configureUserInterfaceForPresentation(userInterface: PageUserInterface,
                                               withSearchTerm searchTerm: String?,
                                                              remoteDownloadURL: NSURL,
                                                              id: String)
}

// MARK: -
// MARK: PagePresenter class

final class PagePresenter: PagePresenterInterface {

    // MARK: Properties

    weak var wireframe: PageWireframe?

    private let interactor: PageInteractorInterface
    private var searchTerm: String?
    private var remoteDownloadURL: NSURL?
    private var userInterface: PageUserInterface?

    // MARK: Init methods

    init(interactor: PageInteractorInterface = PageInteractor()) {
        self.interactor = interactor
        interactor.delegate = self
    }

    // MARK: Private methods

    private func cancelDownloadAndFinish() {
        if let url = remoteDownloadURL {
            interactor.cancelDownloadWithRemoteURL(url)
        }
        wireframe?.dismissPageScreen()
    }

    // MARK: PagePresenterInterface methods

    func configureUserInterfaceForPresentation(userInterface: PageUserInterface,
                                               withSearchTerm searchTerm: String?,
                                                              remoteDownloadURL: NSURL,
                                                              id: String) {
        self.userInterface = userInterface
        self.userInterface?.showLoadingIndicator()

        self.searchTerm = searchTerm
        self.remoteDownloadURL = remoteDownloadURL

        interactor.startDownloadWithRemoteURL(remoteDownloadURL)
        interactor.startOCRCoordinatesRequestWithID(id)
    }

    // MARK: PageUserInterfaceDelegate methods

    func userDidTapDone() {
        cancelDownloadAndFinish()
    }

    func userDidTapCancel() {
        cancelDownloadAndFinish()
    }

    func userDidTapShare(image: UIImage) {
        wireframe?.showShareScreenWithImage(image)
    }

    // MARK: PageInteractorDelegate methods

    func download(remoteURL: NSURL, didFinishWithFileURL fileURL: NSURL?, error: NSError?) {
        if let error = error {
            userInterface?.showErrorWithTitle("Trouble Downloading PDF", message: error.localizedDescription)
        } else {
            userInterface?.pdfPage = CGPDFDocumentGetPage(CGPDFDocumentCreateWithURL(fileURL), 1)
        }
        userInterface?.hideLoadingIndicator()
    }

    func requestDidFinishWithOCRCoordinates(coordinates: OCRCoordinates?, error: NSError?) {
        guard let searchTerm = searchTerm else { return }
        var terms = [searchTerm]
        terms.appendContentsOf(searchTerm.componentsSeparatedByString(" "))

        var matchingCoordinates: [String: [CGRect]] = [:]
        if let wordsWithCoordinates = coordinates?.wordCoordinates?.keys {
            for word in wordsWithCoordinates {
                for term in terms {
                    if word.lowercaseString == term.lowercaseString {
                        matchingCoordinates[word] = coordinates?.wordCoordinates?[word]
                        continue
                    }
                }
            }
        }

        coordinates?.wordCoordinates = matchingCoordinates
        userInterface?.highlights = coordinates
    }
}
