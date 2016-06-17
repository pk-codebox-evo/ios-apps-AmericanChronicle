// MARK: -
// MARK: DatePickerWireframeInterface class

protocol DatePickerWireframeInterface: class {
    func presentFromViewController(presentingViewController: UIViewController?,
                                   withDayMonthYear dayMonthYear: DayMonthYear?,
                                   title: String?)
    func userDidTapSave(dayMonthYear: DayMonthYear)
    func userDidTapCancel()
}

// MARK: -
// MARK: DatePickerWireframeDelegate protocol

protocol DatePickerWireframeDelegate: class {
    func datePickerWireframe(wireframe: DatePickerWireframe, didSaveWithDayMonthYear: DayMonthYear)
    func datePickerWireframeDidFinish(wireframe: DatePickerWireframe)
}

// MARK: -
// MARK: DatePickerWireframe class

final class DatePickerWireframe: NSObject, DatePickerWireframeInterface, UIViewControllerTransitioningDelegate {

    // MARK: Properties

    private let presenter: DatePickerPresenterInterface
    private var presentedViewController: UIViewController?
    private weak var delegate: DatePickerWireframeDelegate?

    // MARK: Init methods

    init(delegate: DatePickerWireframeDelegate,
         presenter: DatePickerPresenterInterface = DatePickerPresenter()) {
        self.delegate = delegate
        self.presenter = presenter
        super.init()
        self.presenter.wireframe = self
    }

    // MARK: DatePickerWireframeInterface methods

    func presentFromViewController(presentingViewController: UIViewController?,
                                   withDayMonthYear dayMonthYear: DayMonthYear?,
                                   title: String?) {
        let vc = DatePickerViewController()
        vc.delegate = presenter
        vc.modalPresentationStyle = .Custom
        vc.transitioningDelegate = self
        presenter.configureUserInterfaceForPresentation(vc, withDayMonthYear: dayMonthYear, title: title)
        presentingViewController?.presentViewController(vc, animated: true, completion: nil)
        presentedViewController = vc
    }

    func userDidTapSave(dayMonthYear: DayMonthYear) {
        delegate?.datePickerWireframe(self, didSaveWithDayMonthYear: dayMonthYear)
        presentedViewController?.dismissViewControllerAnimated(true, completion: {
            self.delegate?.datePickerWireframeDidFinish(self)
        })
    }

    func userDidTapCancel() {
        presentedViewController?.dismissViewControllerAnimated(true, completion: {
            self.delegate?.datePickerWireframeDidFinish(self)
        })
    }

    // MARK: UIViewControllerTransitioningDelegate methods

    func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
                             sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ShowDatePickerTransitionController()
    }

    func animationControllerForDismissedController(
        dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HideDatePickerTransitionController()
    }
}
