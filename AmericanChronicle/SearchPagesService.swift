import Alamofire

// MARK: -
// MARK: SearchPagesWebServiceProtocol

protocol SearchPagesServiceInterface {
    func startSearch(parameters: SearchParameters,
                     page: Int,
                     contextID: String,
                     completionHandler: ((SearchResults?, ErrorType?) -> Void))
    func isSearchInProgress(parameters: SearchParameters, page: Int, contextID: String) -> Bool
    func cancelSearch(parameters: SearchParameters, page: Int, contextID: String)
}

// MARK: -
// MARK: SearchPagesWebService

final class SearchPagesService: SearchPagesServiceInterface {

    // MARK: Properties

    private let manager: ManagerProtocol
    private var activeRequests: [String: RequestProtocol] = [:]
    private let queue = dispatch_queue_create("com.ryanipete.AmericanChronicle.SearchPagesService",
                              DISPATCH_QUEUE_SERIAL)

    // MARK: Init methods

    init(manager: ManagerProtocol = Manager()) {
        self.manager = manager
    }

    // MARK: SearchPagesServiceInterface methods

    /**
        contextID allows cancels without worrying about cancelling another object's outstanding
        request for the same info.

        If a request for the same term/page/contextID combo is already active, the completionHandler
        is called immediately with an InvalidParameter error and no additional request is made.

        - Parameters:
            - term: must have a non-zero character count
            - page: must be 1 or greater
    */
    func startSearch(parameters: SearchParameters,
                     page: Int,
                     contextID: String,
                     completionHandler: ((SearchResults?, ErrorType?) -> Void)) {
        guard !parameters.term.characters.isEmpty else {
            let error = NSError(code: .InvalidParameter,
                                message: "Tried to search for an empty term.")
            completionHandler(nil, error)
            return
        }

        guard page > 0 else {
            let error = NSError(code: .InvalidParameter,
                                message: "Tried to search for an invalid page.")
            completionHandler(nil, error)
            return
        }

        guard !isSearchInProgress(parameters, page: page, contextID: contextID) else {
            let error = NSError(code: .DuplicateRequest,
                                message: "Message tried to send a duplicate request.")
            completionHandler(nil, error)
            return
        }

        let earliestMonth = "\(parameters.earliestDayMonthYear.month)"
        let earliestDay = "\(parameters.earliestDayMonthYear.day)"
        let earliestYear = "\(parameters.earliestDayMonthYear.year)"
        let date1 = "\(earliestMonth)/\(earliestDay)/\(earliestYear)"

        let latestMonth = "\(parameters.latestDayMonthYear.month)"
        let latestDay = "\(parameters.latestDayMonthYear.day)"
        let latestYear = "\(parameters.latestDayMonthYear.year)"
        let date2 = "\(latestMonth)/\(latestDay)/\(latestYear)"

        let params: [String: AnyObject] = [
            "format": "json",
            "rows": 20,
            "page": page,
            "dateFilterType": "range",
            "date1": date1,
            "date2": date2
        ]

        var URLString = ChroniclingAmericaEndpoint.PagesSearch.fullURLString ?? ""
        let term = parameters.term.stringByReplacingOccurrencesOfString(" ", withString: "+")
        URLString.appendContentsOf("?proxtext=\(term)")
        if !parameters.states.isEmpty {
            let statesString = parameters.states.map { state in
                let formatted = state.stringByReplacingOccurrencesOfString(" ", withString: "+")
                return "state=\(formatted)"
            }.joinWithSeparator("&")
            URLString.appendContentsOf("&\(statesString)")
        }

        let request = self.manager.request(.GET, URLString: URLString, parameters: params)?
            .responseObject(queue: nil, keyPath: nil, mapToObject: nil) {
                (response: Response<SearchResults, NSError>) in
                dispatch_sync(self.queue) {
                    let key = self.keyForParameters(parameters, page: page, contextID: contextID)
                    self.activeRequests[key] = nil
                }
            completionHandler(response.result.value, response.result.error)
        }

        dispatch_sync(queue) {
            let key = self.keyForParameters(parameters, page: page, contextID: contextID)
            self.activeRequests[key] = request
        }
    }

    func cancelSearch(parameters: SearchParameters, page: Int, contextID: String) {
        var request: RequestProtocol? = nil
        dispatch_sync(queue) {
            let key = self.keyForParameters(parameters, page: page, contextID: contextID)
            request = self.activeRequests[key]
        }
        request?.cancel()
    }

    func isSearchInProgress(parameters: SearchParameters, page: Int, contextID: String) -> Bool {
        var isInProgress = false
        dispatch_sync(queue) {
            let key = self.keyForParameters(parameters, page: page, contextID: contextID)
            isInProgress = self.activeRequests[key] != nil
        }
        return isInProgress
    }

    // MARK: Private methods

    private func keyForParameters(parameters: SearchParameters,
                                  page: Int,
                                  contextID: String) -> String {
        var key = parameters.term
        key += "-"
        key += parameters.states.joinWithSeparator(".")
        key += "-"
        key += "\(page)"
        key += "-"
        key += contextID
        return key
    }
}
