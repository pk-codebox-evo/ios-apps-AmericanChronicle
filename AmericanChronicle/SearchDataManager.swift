//
//  SearchDataManager.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 10/12/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

// MARK: -
// MARK: SearchDataManagerProtocol

public protocol SearchDataManagerInterface {
    var service: SearchPagesServiceInterface? { get set }
    func startSearch(term: String, page: Int, completionHandler: ((SearchResults?, NSError?) -> Void))
    func cancelSearch(term: String, page: Int)
    func isSearchInProgress(term: String, page: Int) -> Bool
}

// MARK: -
// MARK: SearchDataManager

public class SearchDataManager: SearchDataManagerInterface {

    public var service: SearchPagesServiceInterface?

    // MARK: Init methods

    public init(service: SearchPagesServiceInterface = SearchPagesService()) {
        self.service = service
    }

    // MARK: Private Properties

    private var contextID: String { return "\(unsafeAddressOf(self))" }

    // MARK: SearchDataManagerProtocol conformance

    public func startSearch(term: String, page: Int, completionHandler: ((SearchResults?, NSError?) -> Void)) {
        
        service?.startSearch(term, page: page, contextID: contextID, completionHandler: { request, error in
            // TODO: Handle caching if not done via HTTP
            let err = error as? NSError
            completionHandler(request, err)
        })
    }

    public func cancelSearch(term: String, page: Int) {
        service?.cancelSearch(term, page: page, contextID: contextID)
    }

    public func isSearchInProgress(term: String, page: Int) -> Bool {
        return service?.isSearchInProgress(term, page: page, contextID: contextID) ?? false
    }
}