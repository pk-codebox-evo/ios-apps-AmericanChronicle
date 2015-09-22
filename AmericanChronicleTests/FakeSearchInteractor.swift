//
//  FakeSearchInteractor.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/12/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import AmericanChronicle

class FakeSearchInteractor: SearchInteractorProtocol {
    var didCall_performSearch = false
    var didCall_performSearch_withTerm: String?
    var didCall_performSearch_withCallback: ((SearchResults?, ErrorType?) -> ())?
    var fake_isDoingWork = false
    var isDoingWork: Bool {
        return fake_isDoingWork
    }

    func performSearch(term: String?, andThen callback: ((SearchResults?, ErrorType?) -> ())) {
        didCall_performSearch = true
        didCall_performSearch_withTerm = term
        didCall_performSearch_withCallback = callback
    }

    func cancelLastSearch() {

    }
}
