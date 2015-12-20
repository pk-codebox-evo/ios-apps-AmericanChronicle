//
//  FakeDelayedSearchFactory.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 11/8/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

@testable import AmericanChronicle

class FakeDelayedSearchFactory: DelayedSearchFactoryInterface {

    var newSearch_wasCalled_withParameters: SearchParameters?
    var newSearch_wasCalled_withPage: Int?

    private(set) var newSearchForTerm_lastReturnedSearch: FakeDelayedSearch?

    func newSearch(parameters: SearchParameters, page: Int, callback: ((SearchResults?, ErrorType?) -> ())) -> DelayedSearchInterface? {
        newSearch_wasCalled_withParameters = parameters
        newSearch_wasCalled_withPage = page
        newSearchForTerm_lastReturnedSearch = FakeDelayedSearch(parameters: parameters, page: page, dataManager: FakeSearchDataManager(), runLoop: FakeRunLoop(), completionHandler: callback)
        return newSearchForTerm_lastReturnedSearch
    }

    init() {}
}
