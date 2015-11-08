//
//  FakeDelayedSearchFactory.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 11/8/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import AmericanChronicle

class FakeDelayedSearchFactory: DelayedSearchFactoryInterface {

    var newSearchForTerm_wasCalled_withTerm: String?
    var newSearchForTerm_wasCalled_withPage: Int?

    private(set) var newSearchForTerm_lastReturnedSearch: FakeDelayedSearch?

    func newSearchForTerm(term: String, page: Int, callback: ((SearchResults?, ErrorType?) -> ())) -> DelayedSearchInterface? {
        newSearchForTerm_wasCalled_withTerm = term
        newSearchForTerm_wasCalled_withPage = page
        newSearchForTerm_lastReturnedSearch = FakeDelayedSearch(term: term, page: page, dataManager: FakeSearchDataManager(), runLoop: FakeRunLoop(), completionHandler: callback)
        return newSearchForTerm_lastReturnedSearch
    }

    init() {}
}
