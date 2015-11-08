//
//  FakeDelayedSearch.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 11/8/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import AmericanChronicle

class FakeDelayedSearch: DelayedSearchInterface {

    // MARK: Properties

    var term: String
    private let completionHandler: ((SearchResults?, ErrorType?) -> ())

    // MARK: DelayedSearchInterface methods

    required init(term: String, page: Int, dataManager: SearchDataManagerInterface, runLoop: RunLoopInterface, completionHandler: ((SearchResults?, ErrorType?) -> ())) {
        self.term = term
        self.completionHandler = completionHandler
    }

    var cancel_wasCalled = false
    func cancel() {
        cancel_wasCalled = true
    }

    var isSearchInProgress_wasCalled = false
    var isSearchInProgress_returnValue = false
    func isSearchInProgress() -> Bool {
        isSearchInProgress_wasCalled = true
        return isSearchInProgress_returnValue
    }

    func finishRequestWithSearchResults(results: SearchResults?, error: ErrorType?) {
        completionHandler(results, error)
    }
}
