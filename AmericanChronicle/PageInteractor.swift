// MARK: -
// MARK: PageInteractorInterface protocol

protocol PageInteractorInterface: class {
    var delegate: PageInteractorDelegate? { get set }

    func startDownloadWithRemoteURL(remoteURL: NSURL)
    func cancelDownloadWithRemoteURL(remoteURL: NSURL)
    func isDownloadWithRemoteURLInProgress(remoteURL: NSURL) -> Bool
    func startOCRCoordinatesRequestWithID(id: String)
}

// MARK: -
// MARK: PageInteractorDelegate protocol

protocol PageInteractorDelegate: class {
    func download(remoteURL: NSURL, didFinishWithFileURL fileURL: NSURL?, error: NSError?)
    func requestDidFinishWithOCRCoordinates(coordinates: OCRCoordinates?, error: NSError?)
}

// MARK: -
// MARK: PageInteractor class

final class PageInteractor: PageInteractorInterface {

    // MARK: Properties

    weak var delegate: PageInteractorDelegate?
    private let dataManager: PageDataManagerInterface

    // MARK: Init methods

    init(dataManager: PageDataManagerInterface = PageDataManager()) {
        self.dataManager = dataManager
    }

    // MARK: PageInteractorInterface methods

    func startDownloadWithRemoteURL(remoteURL: NSURL) {
        dataManager.downloadPage(remoteURL, completionHandler: { remoteURL, fileURL, error in
            self.delegate?.download(remoteURL, didFinishWithFileURL: fileURL, error: error)
        })
    }

    func cancelDownloadWithRemoteURL(remoteURL: NSURL) {
        dataManager.cancelDownload(remoteURL)
    }

    func isDownloadWithRemoteURLInProgress(remoteURL: NSURL) -> Bool {
        return dataManager.isDownloadInProgress(remoteURL)
    }

    func startOCRCoordinatesRequestWithID(id: String) {
        dataManager.startOCRCoordinatesRequest(id) { coordinates, error in
            self.delegate?.requestDidFinishWithOCRCoordinates(coordinates, error: error)
        }
    }
}
