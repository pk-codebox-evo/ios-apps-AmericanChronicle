//
//  SearchPagesService.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 10/12/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import Alamofire

// MARK: -
// MARK: SearchPagesWebServiceProtocol

protocol SearchPagesServiceInterface {
    func startSearch(parameters: SearchParameters, page: Int, contextID: String, completionHandler: ((SearchResults?, ErrorType?) -> Void))
    func isSearchInProgress(parameters: SearchParameters, page: Int, contextID: String) -> Bool
    func cancelSearch(parameters: SearchParameters, page: Int, contextID: String)
}

// MARK: -
// MARK: SearchPagesWebService

class SearchPagesService: SearchPagesServiceInterface {

    // MARK: Properties

    private let manager: ManagerProtocol
    private var activeRequests: [String: RequestProtocol] = [:]
    private let queue = dispatch_queue_create("com.ryanipete.AmericanChronicle.SearchPagesService", DISPATCH_QUEUE_SERIAL)

    // MARK: Init methods

    init(manager: ManagerProtocol = Manager()) {
        self.manager = manager
    }

    // MARK: SearchPagesServiceInterface methods

    /// contextID allows cancels without worrying about cancelling another object's outstanding
    /// request for the same info.
    ///
    /// If a request for the same term/page/contextID combo is already active, the completionHandler
    /// is called immediately with an InvalidParameter error and no additional request is made.
    ///
    /// `term` must have a non-zero character count
    /// `page` must be 1 or greater
    func startSearch(parameters: SearchParameters, page: Int, contextID: String, completionHandler: ((SearchResults?, ErrorType?) -> Void)) {
        guard parameters.term.characters.count > 0 else {
            let error = NSError(code: .InvalidParameter, message: "Tried to search for an empty term.")
            completionHandler(nil, error)
            return
        }

        guard page > 0 else {
            completionHandler(nil, NSError(code: .InvalidParameter, message: "Tried to search for an invalid page."))
            return
        }

        guard !isSearchInProgress(parameters, page: page, contextID: contextID) else {
            completionHandler(nil, NSError(code: .DuplicateRequest, message: "Message tried to send a duplicate request."))
            return
        }

        let earliestMonth = "\(parameters.earliestDayMonthYear.month)"
        let earliestDay = "\(parameters.earliestDayMonthYear.day)"
        let earliestYear = "\(parameters.earliestDayMonthYear.year)"
        let date1 = "\(earliestMonth)\\\(earliestDay)\\\(earliestYear)"

        let latestMonth = "\(parameters.latestDayMonthYear.month)"
        let latestDay = "\(parameters.latestDayMonthYear.day)"
        let latestYear = "\(parameters.latestDayMonthYear.year)"
        let date2 = "\(latestMonth)\\\(latestDay)\\\(latestYear)"

        let params: [String: AnyObject] = [
            "format": "json",
            "rows": 20,
            "page": page,
            "dateFilterType": "range",
            "date1": date1,
            "date2": date2
        ]

        var URLString = ChroniclingAmericaEndpoint.PagesSearch.fullURLString ?? ""
        URLString.appendContentsOf("?proxtext=\(parameters.term.stringByReplacingOccurrencesOfString(" ", withString: "+"))")
        if parameters.states.count > 0 {
            let statesString = parameters.states.map { state in
                let formattedState = state.stringByReplacingOccurrencesOfString(" ", withString: "+")
                return "state=\(formattedState)"
            }.joinWithSeparator("&")
            URLString.appendContentsOf("&\(statesString)")
        }

        let request = self.manager.request(.GET, URLString: URLString, parameters: params)?.responseObject(queue: nil, keyPath: nil, mapToObject: nil) { (response: Response<SearchResults, NSError>) in
            dispatch_sync(self.queue) {
                self.activeRequests[self.keyForParameters(parameters, page: page, contextID: contextID)] = nil
            }
            completionHandler(response.result.value, response.result.error)
        }

        dispatch_sync(queue) {
            self.activeRequests[self.keyForParameters(parameters, page: page, contextID: contextID)] = request
        }
    }

    func cancelSearch(parameters: SearchParameters, page: Int, contextID: String) {
        var request: RequestProtocol? = nil
        dispatch_sync(queue) {
            request = self.activeRequests[self.keyForParameters(parameters, page: page, contextID: contextID)]
        }
        request?.cancel()
    }

    func isSearchInProgress(parameters: SearchParameters, page: Int, contextID: String) -> Bool {
        var isInProgress = false
        dispatch_sync(queue) {
            isInProgress = self.activeRequests[self.keyForParameters(parameters, page: page, contextID: contextID)] != nil
        }
        return isInProgress
    }

    // MARK: Private methods

    private func keyForParameters(parameters: SearchParameters, page: Int, contextID: String) -> String {
        return "\(parameters.term)-\(parameters.states.joinWithSeparator("."))-\(page)-\(contextID)"
    }
}