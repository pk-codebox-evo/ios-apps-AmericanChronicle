@testable import AmericanChronicle

class FakeUSStatePickerPresenter: USStatePickerPresenterInterface {
    var wireframe: USStatePickerWireframeInterface?

    var didCallConfigureWithUserInterface: USStatePickerUserInterface?
    var didCallConfigureWithSelectedStateNames: [String]?
    func configureUserInterfaceForPresentation(userInterface: USStatePickerUserInterface,
                                               withSelectedStateNames selectedStateNames: [String]) {
        didCallConfigureWithUserInterface = userInterface
        didCallConfigureWithSelectedStateNames = selectedStateNames
    }

    func userDidTapSave(selectedStateNames: [String]) {

    }

    func userDidTapCancel() {

    }
}
