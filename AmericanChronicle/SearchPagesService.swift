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

public protocol SearchPagesServiceInterface {
    func startSearch(term: String, page: Int, contextID: String, completionHandler: ((SearchResults?, ErrorType?) -> Void))
    func isSearchInProgress(term: String, page: Int, contextID: String) -> Bool
    func cancelSearch(term: String, page: Int, contextID: String)
}

// MARK: -
// MARK: SearchPagesWebService

public class SearchPagesService: SearchPagesServiceInterface {

    // MARK: Properties

    private let manager: ManagerProtocol
    private var activeRequests: [String: RequestProtocol] = [:]
    private let queue = dispatch_queue_create("com.ryanipete.AmericanChronicle.SearchPagesService", DISPATCH_QUEUE_SERIAL)

    // MARK: Init methods

    public init(manager: ManagerProtocol = Manager()) {
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
    public func startSearch(term: String, page: Int, contextID: String, completionHandler: ((SearchResults?, ErrorType?) -> Void)) {

        if term.characters.count <= 0 {
            completionHandler(nil, NSError(code: .InvalidParameter, message: "Tried to search for an empty term."))
            return
        }

        if page < 1 {
            completionHandler(nil, NSError(code: .InvalidParameter, message: "Tried to search for an invalid page."))
            return
        }

        if isSearchInProgress(term, page: page, contextID: contextID) {
            completionHandler(nil, NSError(code: .DuplicateRequest, message: "Message tried to send a duplicate request."))
            return
        }

        let params: [String: AnyObject] = ["format": "json", "rows": 20, "proxtext": term, "page": page]
        let URLString = ChroniclingAmericaEndpoint.PagesSearch.fullURLString ?? ""
        let request = self.manager.request(.GET, URLString: URLString, parameters: params)?.responseObject { (obj: SearchResults?, error) in
            dispatch_sync(self.queue) {
                self.activeRequests[self.keyForTerm(term, page: page, contextID: contextID)] = nil
            }
            completionHandler(obj, error)
        }

        dispatch_sync(queue) {
            self.activeRequests[self.keyForTerm(term, page: page, contextID: contextID)] = request
        }
    }

    public func cancelSearch(term: String, page: Int, contextID: String) {
        var request: RequestProtocol? = nil
        dispatch_sync(queue) {
            request = self.activeRequests[self.keyForTerm(term, page: page, contextID: contextID)]
        }
        request?.cancel()
    }

    public func isSearchInProgress(term: String, page: Int, contextID: String) -> Bool {
        var isInProgress = false
        dispatch_sync(queue) {
            isInProgress = self.activeRequests[self.keyForTerm(term, page: page, contextID: contextID)] != nil
        }
        return isInProgress
    }

    // MARK: Private methods

    private func keyForTerm(term: String, page: Int, contextID: String) -> String {
        return "\(term)-\(page)-\(contextID)"
    }
}