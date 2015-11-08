//
//  CachedSearchPagesService.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 11/7/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

protocol CachedSearchResultsServiceInterface {

}

class CachedSearchResultsService: CachedSearchResultsServiceInterface {
    var cachedResults: [String: [SearchResults]] = [:]
    func resultsForTerm(term: String) -> [SearchResults]? {
        return cachedResults[term]
    }

    func cacheResults(results: SearchResults, forTerm term: String) {
        var allResults = cachedResults[term] ?? []
        allResults.append(results)
    }
}
