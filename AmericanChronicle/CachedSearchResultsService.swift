//
//  CachedSearchResultsService.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 11/7/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

protocol CachedSearchResultsServiceInterface {
    func resultsForParameters(parameters: SearchParameters) -> SearchResults?
    func cacheResults(results: SearchResults, forParameters parameters: SearchParameters)
}

class CachedSearchResultsService: CachedSearchResultsServiceInterface {
    private var cachedResults: [SearchParameters: SearchResults] = [:]
    func resultsForParameters(parameters: SearchParameters) -> SearchResults? {
        return cachedResults[parameters]
    }

    func cacheResults(results: SearchResults, forParameters parameters: SearchParameters) {
        cachedResults[parameters] = results
    }
}
