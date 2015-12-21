//
//  FakeSearchInteractor.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/12/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

@testable import AmericanChronicle

class FakeSearchInteractor: SearchInteractorInterface {

    var delegate: SearchInteractorDelegate?

    var fetchNextPageOfResults_wasCalled_withParameters: SearchParameters?
    func fetchNextPageOfResults(parameters: SearchParameters) {
        fetchNextPageOfResults_wasCalled_withParameters = parameters
    }

    var fake_isSearchInProgress = false
    func isSearchInProgress() -> Bool {
        return fake_isSearchInProgress
    }

    var cancelLastSearch_wasCalled = false
    func cancelLastSearch() {
        cancelLastSearch_wasCalled = true
    }
}
