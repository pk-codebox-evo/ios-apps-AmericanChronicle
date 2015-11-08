//
//  FakeSearchDataManager.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 11/8/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import AmericanChronicle

class FakeSearchDataManager: SearchDataManagerInterface {

    var service: SearchPagesServiceInterface?

    var startSearch_wasCalled_withTerm: String?
    var startSearch_wasCalled_withPage: Int?
    func startSearch(term: String, page: Int, completionHandler: ((SearchResults?, NSError?) -> Void)) {
        startSearch_wasCalled_withTerm = term
        startSearch_wasCalled_withPage = page
    }

    var cancelSearch_wasCalled = false
    var cancelSearch_wasCalled_withTerm: String?
    var cancelSearch_wasCalled_withPage: Int?
    func cancelSearch(term: String, page: Int) {
        cancelSearch_wasCalled = true
        cancelSearch_wasCalled_withTerm = term
        cancelSearch_wasCalled_withPage = page
    }

    var isSearchInProgress_wasCalled = false
    var isSearchInProgress_wasCalled_withTerm: String?
    var isSearchInProgress_wasCalled_withPage: Int?
    var isSearchInProgress_stubbedReturnValue = false
    func isSearchInProgress(term: String, page: Int) -> Bool {
        isSearchInProgress_wasCalled = true
        isSearchInProgress_wasCalled_withTerm = term
        isSearchInProgress_wasCalled_withPage = page
        return isSearchInProgress_stubbedReturnValue
    }
}
