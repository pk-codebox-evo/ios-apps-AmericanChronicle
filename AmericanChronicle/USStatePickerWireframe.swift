// MARK: -
// MARK: USStatePickerWireframeInterface protocol

protocol USStatePickerWireframeInterface: class {
    func presentFromViewController(presentingViewController: UIViewController?,
                                   withSelectedStateNames: [String])
    func userDidTapSave(selectedItems: [String])
    func userDidTapCancel()
}

// MARK: -
// MARK: USStatePickerWireframeDelegate protocol

protocol USStatePickerWireframeDelegate: class {
    func usStatePickerWireframe(wireframe: USStatePickerWireframe,
                                didSaveFilteredUSStateNames: [String])
    func usStatePickerWireframeDidFinish(wireframe: USStatePickerWireframe)
}

// MARK: -
// MARK: USStatePickerWireframe class

final class USStatePickerWireframe: NSObject,
    USStatePickerWireframeInterface,
    UIViewControllerTransitioningDelegate {

    // MARK: Properties

    private let presenter: USStatePickerPresenterInterface
    private(set) var presentedViewController: UIViewController?
    private weak var delegate: USStatePickerWireframeDelegate?

    // MARK: Init methods

    init(delegate: USStatePickerWireframeDelegate,
         presenter: USStatePickerPresenterInterface = USStatePickerPresenter()) {
        self.delegate = delegate
        self.presenter = presenter

        super.init()

        self.presenter.wireframe = self
    }

    // MARK: USStatePickerWireframeInterface methods

    func presentFromViewController(presentingViewController: UIViewController?,
                                   withSelectedStateNames selectedStateNames: [String]) {
        let vc = USStatePickerViewController()
        vc.delegate = presenter
        presenter.configureUserInterfaceForPresentation(vc, withSelectedStateNames: selectedStateNames)

        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .Custom
        nvc.transitioningDelegate = self

        presentingViewController?.presentViewController(nvc, animated: true, completion: nil)

        presentedViewController = nvc

    }

    func userDidTapSave(selectedItems: [String]) {
        delegate?.usStatePickerWireframe(self, didSaveFilteredUSStateNames: selectedItems)
        presentedViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: {
            self.delegate?.usStatePickerWireframeDidFinish(self)
        })
    }

    func userDidTapCancel() {
        presentedViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: {
            self.delegate?.usStatePickerWireframeDidFinish(self)
        })
    }

    // MARK: UIViewControllerTransitioningDelegate methods

    func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
                             sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ShowUSStatePickerTransitionController()
    }

    func animationControllerForDismissedController(
        dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HideUSStatePickerTransitionController()
    }
}
