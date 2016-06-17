protocol USStatePickerInteractorInterface {
    func loadStateNames(completionHandler: (([String]?, ErrorType?) -> Void))
}

final class USStatePickerInteractor: NSObject, USStatePickerInteractorInterface {
    private let dataManager: USStatePickerDataManagerInterface

    init(dataManager: USStatePickerDataManagerInterface = USStatePickerDataManager()) {
        self.dataManager = dataManager
    }

    func loadStateNames(completionHandler: (([String]?, ErrorType?) -> Void)) {
        dataManager.loadStateNames(completionHandler)
    }
}
