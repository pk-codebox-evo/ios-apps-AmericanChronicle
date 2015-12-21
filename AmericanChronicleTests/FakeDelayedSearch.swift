//
//  FakeDelayedSearch.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 11/8/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

@testable import AmericanChronicle

class FakeDelayedSearch: DelayedSearchInterface {

    // MARK: Properties

    var parameters: SearchParameters
    private let completionHandler: ((SearchResults?, ErrorType?) -> ())

    // MARK: DelayedSearchInterface methods

    required init(parameters: SearchParameters, dataManager: SearchDataManagerInterface, runLoop: RunLoopInterface, completionHandler: ((SearchResults?, ErrorType?) -> ())) {
        self.parameters = parameters
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
