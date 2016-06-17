import Alamofire

// MARK: -
// MARK: OCRCoordinatesServiceInterface

protocol OCRCoordinatesServiceInterface {
    func startRequest(id: String,
                      contextID: String,
                      completionHandler: ((OCRCoordinates?, ErrorType?) -> Void))
    func isRequestInProgress(id: String, contextID: String) -> Bool
    func cancelRequest(id: String, contextID: String)
}

// MARK: -
// MARK: OCRCoordinatesService class

final class OCRCoordinatesService: OCRCoordinatesServiceInterface {

    private let manager: ManagerProtocol
    private var activeRequests: [String: RequestProtocol] = [:]
    private let queue = dispatch_queue_create(
                            "com.ryanipete.AmericanChronicle.OCRCoordinatesService",
                            DISPATCH_QUEUE_SERIAL)

    init(manager: ManagerProtocol = Manager()) {
        self.manager = manager
    }

    func startRequest(id: String,
                      contextID: String,
                      completionHandler: ((OCRCoordinates?, ErrorType?) -> Void)) {
        if id.characters.isEmpty {
            let error = NSError(code: .InvalidParameter,
                                message: "Tried to fetch OCR info using an empty lccn.")
            completionHandler(nil, error)
            return
        }

        if isRequestInProgress(id, contextID: contextID) {
            let error = NSError(code: .DuplicateRequest,
                                message: "Message tried to send a duplicate request.")
            completionHandler(nil, error)
            return
        }

        let URLString = URLStringForID(id)

        let request = self.manager.request(.GET, URLString: URLString, parameters: nil)?
            .responseObject(queue: nil,
                            keyPath: nil,
                            mapToObject: nil) { (response: Response<OCRCoordinates, NSError>) in
            dispatch_sync(self.queue) {
                self.activeRequests[URLString] = nil
            }
            completionHandler(response.result.value, response.result.error)
        }

        dispatch_sync(queue) {
            self.activeRequests[URLString] = request
        }
    }

    private func URLStringForID(id: String) -> String {
        return "\(ChroniclingAmericaEndpoint.baseURLString)\(id)coordinates"
    }

    func isRequestInProgress(id: String, contextID: String) -> Bool {
        return activeRequests[URLStringForID(id)] != nil
    }

    func cancelRequest(id: String, contextID: String) {

    }
}
