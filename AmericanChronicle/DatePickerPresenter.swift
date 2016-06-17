// MARK: -
// MARK: DatePickerPresenterInterface protocol

protocol DatePickerPresenterInterface: DatePickerUserInterfaceDelegate {
    var wireframe: DatePickerWireframeInterface? { get set }
    func configureUserInterfaceForPresentation(userInterface: DatePickerUserInterface,
                                               withDayMonthYear: DayMonthYear?,
                                               title: String?)
}

// MARK: -
// MARK: DatePickerPresenter class

final class DatePickerPresenter: DatePickerPresenterInterface {

    // MARK: Properties

    weak var wireframe: DatePickerWireframeInterface?

    private let interactor: DatePickerInteractorInterface
    private var userInterface: DatePickerUserInterface?

    // MARK: Init methods

    init(interactor: DatePickerInteractorInterface = DatePickerInteractor()) {
        self.interactor = interactor
    }

    // MARK: DatePickerPresenterInterface methods

    func configureUserInterfaceForPresentation(userInterface: DatePickerUserInterface,
                                               withDayMonthYear dayMonthYear: DayMonthYear?,
                                               title: String?) {
        self.userInterface = userInterface
        if let dayMonthYear = dayMonthYear {
            self.userInterface?.title = title
            self.userInterface?.selectedDayMonthYear = dayMonthYear
        }
    }

    // MARK: DatePickerUserInterfaceDelegate methods

    func userDidSave(dayMonthYear: DayMonthYear) {
        wireframe?.userDidTapSave(dayMonthYear)
    }

    func userDidCancel() {
        wireframe?.userDidTapCancel()
    }
}
