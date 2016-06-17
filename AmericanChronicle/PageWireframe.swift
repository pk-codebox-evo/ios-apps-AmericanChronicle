// MARK: -
// MARK: PageWireframeDelegate protocol

protocol PageWireframeDelegate: class {
    func pageWireframeDidFinish(wireframe: PageWireframe)
}

// MARK: -
// MARK: PageWireframe class

class PageWireframe {

    // MARK: Properties

    private let presenter: PagePresenterInterface
    private var presentedViewController: UIViewController?
    private weak var delegate: PageWireframeDelegate?

    // MARK: Init methods

    init(delegate: PageWireframeDelegate, presenter: PagePresenterInterface = PagePresenter()) {
        self.delegate = delegate
        self.presenter = presenter
        presenter.wireframe = self
    }

    // MARK: Internal methods

    func presentFromViewController(presentingViewController: UIViewController?,
                                   withSearchTerm searchTerm: String?,
                                                  remoteURL: NSURL,
                                                  id: String) {
        let sb = UIStoryboard(name: "Page", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! PageViewController
        vc.delegate = presenter
        presenter.configureUserInterfaceForPresentation(vc,
                                                        withSearchTerm: searchTerm,
                                                        remoteDownloadURL: remoteURL,
                                                        id: id)
        presentingViewController?.presentViewController(vc, animated: true, completion: nil)

        presentedViewController = vc

    }

    func showShareScreenWithImage(image: UIImage?) {
        if let image = image {
            let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
            presentedViewController?.presentViewController(vc, animated: true, completion: nil)
        }
    }

    func dismissPageScreen() {
        presentedViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: {
            self.delegate?.pageWireframeDidFinish(self)
        })
    }
}
