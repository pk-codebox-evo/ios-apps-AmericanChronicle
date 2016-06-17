protocol USStatePickerDataManagerInterface {
    func loadStateNames(completionHandler: (([String]?, ErrorType?) -> Void))
}

final class USStatePickerDataManager: USStatePickerDataManagerInterface {
    private let service: USStatesServiceInterface

    init(service: USStatesServiceInterface = USStatesService()) {
        self.service = service
    }

    func loadStateNames(completionHandler: (([String]?, ErrorType?) -> Void)) {
        service.loadStateNames(completionHandler)
    }
}
