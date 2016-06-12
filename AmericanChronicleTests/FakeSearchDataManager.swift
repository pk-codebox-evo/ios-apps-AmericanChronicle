//
//  FakeSearchDataManager.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 11/8/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

@testable import AmericanChronicle

class FakeSearchDataManager: SearchDataManagerInterface {

    var fetchMoreResults_wasCalled_withParameters: SearchParameters?

    func fetchMoreResults(parameters: SearchParameters, completionHandler: ((SearchResults?, NSError?) -> Void)) {
        fetchMoreResults_wasCalled_withParameters = parameters
    }

    var cancelSearch_wasCalled = false
    var cancelSearch_wasCalled_withParameters: SearchParameters?
    var cancelSearch_wasCalled_withPage: Int?
    func cancelFetch(parameters: SearchParameters) {
        cancelSearch_wasCalled = true
        cancelSearch_wasCalled_withParameters = parameters
    }

    var isSearchInProgress_wasCalled = false
    var isSearchInProgress_wasCalled_withParameters: SearchParameters?
    var isSearchInProgress_wasCalled_withPage: Int?
    var isSearchInProgress_stubbedReturnValue = false
    func isFetchInProgress(parameters: SearchParameters) -> Bool {
        isSearchInProgress_wasCalled = true
        cancelSearch_wasCalled_withParameters = parameters
        return isSearchInProgress_stubbedReturnValue
    }
}
