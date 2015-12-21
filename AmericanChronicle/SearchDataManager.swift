//
//  SearchDataManager.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 10/12/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

// MARK: -
// MARK: SearchDataManagerInterface

protocol SearchDataManagerInterface {
    func fetchMoreResults(parameters: SearchParameters, completionHandler: ((SearchResults?, NSError?) -> Void))
    func cancelFetch(parameters: SearchParameters)
    func isFetchInProgress(parameters: SearchParameters) -> Bool
}

// MARK: -
// MARK: SearchDataManager

class SearchDataManager: SearchDataManagerInterface {

    let webService: SearchPagesServiceInterface
    let cacheService: CachedSearchResultsServiceInterface

    // MARK: Init methods

    internal init(
        webService: SearchPagesServiceInterface = SearchPagesService(),
        cacheService: CachedSearchResultsServiceInterface = CachedSearchResultsService())
    {
        self.webService = webService
        self.cacheService = cacheService
    }

    // MARK: Private Properties

    private var contextID: String { return "\(unsafeAddressOf(self))" }

    // MARK: SearchDataManagerInterface conformance

    func fetchMoreResults(parameters: SearchParameters, completionHandler: ((SearchResults?, NSError?) -> Void)) {
        let page: Int
        if let cachedResults = cacheService.resultsForParameters(parameters) {
            guard !cachedResults.allItemsLoaded else {
                completionHandler(nil, NSError(code: .AllItemsLoaded, message: nil))
                return
            }
            page = cachedResults.numLoadedPages + 1
        } else {
            page = 1
        }

        webService.startSearch(parameters, page: page, contextID: contextID, completionHandler: { results, error in
            let allResults: SearchResults?
            if let results = results {
                if let cachedResults = self.cacheService.resultsForParameters(parameters) {
                    cachedResults.items?.appendContentsOf(results.items ?? [])
                    allResults = cachedResults
                } else {
                    allResults = results
                }
                self.cacheService.cacheResults(allResults!, forParameters: parameters)
            } else {
                allResults = nil
            }
            completionHandler(allResults, error as? NSError)
        })
    }

    func cancelFetch(parameters: SearchParameters) {
        let page: Int
        if let cachedResults = cacheService.resultsForParameters(parameters) {
            page = cachedResults.numLoadedPages + 1
        } else {
            page = 1
        }
        webService.cancelSearch(parameters, page: page, contextID: contextID)
    }

    func isFetchInProgress(parameters: SearchParameters) -> Bool {
        let page: Int
        if let cachedResults = cacheService.resultsForParameters(parameters) {
            page = cachedResults.numLoadedPages + 1
        } else {
            page = 1
        }
        return webService.isSearchInProgress(parameters, page: page, contextID: contextID) ?? false
    }
}