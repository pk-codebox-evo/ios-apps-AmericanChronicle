//
//  FakeSearchDataManager.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 11/8/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

@testable import AmericanChronicle

class FakeSearchDataManager: SearchDataManagerInterface {

    var service: SearchPagesServiceInterface?

    var startSearch_wasCalled_withParameters: SearchParameters?
    var startSearch_wasCalled_withPage: Int?

    func startSearch(parameters: SearchParameters, page: Int, completionHandler: ((SearchResults?, NSError?) -> Void)) {
        startSearch_wasCalled_withParameters = parameters
        startSearch_wasCalled_withPage = page
    }

    var cancelSearch_wasCalled = false
    var cancelSearch_wasCalled_withParameters: SearchParameters?
    var cancelSearch_wasCalled_withPage: Int?
    func cancelSearch(parameters: SearchParameters, page: Int) {
        cancelSearch_wasCalled = true
        cancelSearch_wasCalled_withParameters = parameters
        cancelSearch_wasCalled_withPage = page
    }

    var isSearchInProgress_wasCalled = false
    var isSearchInProgress_wasCalled_withParameters: SearchParameters?
    var isSearchInProgress_wasCalled_withPage: Int?
    var isSearchInProgress_stubbedReturnValue = false
    func isSearchInProgress(parameters: SearchParameters, page: Int) -> Bool {
        isSearchInProgress_wasCalled = true
        cancelSearch_wasCalled_withParameters = parameters
        isSearchInProgress_wasCalled_withPage = page
        return isSearchInProgress_stubbedReturnValue
    }
}
