// MARK: -
// MARK: USStatePickerPresenterInterface protocol

protocol USStatePickerPresenterInterface: USStatePickerUserInterfaceDelegate {
    var wireframe: USStatePickerWireframeInterface? { get set }

    func configureUserInterfaceForPresentation(userInterface: USStatePickerUserInterface,
                                               withSelectedStateNames selectedStateNames: [String])
}

// MARK: -
// MARK: USStatePickerPresenter class

final class USStatePickerPresenter: USStatePickerPresenterInterface {

    // MARK: Properties

    weak var wireframe: USStatePickerWireframeInterface?
    private let interactor: USStatePickerInteractorInterface
    private var userInterface: USStatePickerUserInterface?

    // MARK: Init methods

    init(interactor: USStatePickerInteractorInterface = USStatePickerInteractor()) {
        self.interactor = interactor
    }

    // MARK: USStatePickerPresenterInterface methods

    func configureUserInterfaceForPresentation(userInterface: USStatePickerUserInterface,
                                               withSelectedStateNames selectedStateNames: [String]) {
        self.userInterface = userInterface
        interactor.loadStateNames { [weak self] names, error in
            if let names = names {
                self?.userInterface?.stateNames = names
                self?.userInterface?.setSelectedStateNames(selectedStateNames)
            }
        }
    }

    // MARK: USStatePickerUserInterfaceDelegate methods

    func userDidTapSave(selectedStateNames: [String]) {
        self.wireframe?.userDidTapSave(selectedStateNames)
    }

    func userDidTapCancel() {
        self.wireframe?.userDidTapCancel()
    }
}
