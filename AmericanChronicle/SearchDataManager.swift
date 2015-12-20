//
//  SearchDataManager.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 10/12/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

// MARK: -
// MARK: SearchDataManagerProtocol

protocol SearchDataManagerInterface {
    var service: SearchPagesServiceInterface? { get set }
    func startSearch(parameters: SearchParameters, page: Int, completionHandler: ((SearchResults?, NSError?) -> Void))
    func cancelSearch(parameters: SearchParameters, page: Int)
    func isSearchInProgress(parameters: SearchParameters, page: Int) -> Bool
}

// MARK: -
// MARK: SearchDataManager

class SearchDataManager: SearchDataManagerInterface {

    var service: SearchPagesServiceInterface?

    // MARK: Init methods

    init(service: SearchPagesServiceInterface = SearchPagesService()) {
        self.service = service
    }

    // MARK: Private Properties

    private var contextID: String { return "\(unsafeAddressOf(self))" }

    // MARK: SearchDataManagerProtocol conformance

    func startSearch(parameters: SearchParameters, page: Int, completionHandler: ((SearchResults?, NSError?) -> Void)) {
        service?.startSearch(parameters, page: page, contextID: contextID, completionHandler: { request, error in
            // TODO: Handle caching if not done via HTTP
            let err = error as? NSError
            completionHandler(request, err)
        })
    }

    func cancelSearch(parameters: SearchParameters, page: Int) {
        service?.cancelSearch(parameters, page: page, contextID: contextID)
    }

    func isSearchInProgress(parameters: SearchParameters, page: Int) -> Bool {
        return service?.isSearchInProgress(parameters, page: page, contextID: contextID) ?? false
    }
}