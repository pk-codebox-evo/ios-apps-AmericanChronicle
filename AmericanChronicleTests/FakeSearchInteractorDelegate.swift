//
//  FakeSearchInteractorDelegate.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 11/8/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import AmericanChronicle

class FakeSearchInteractorDelegate: SearchInteractorDelegate {
    var searchForTerm_didFinish_wasCalled = false
    var searchForTerm_didFinish_wasCalled_withResults: SearchResults?
    var searchForTerm_didFinish_wasCalled_withError: NSError?
    func searchForTerm(term: String, existingRows: [SearchResultsRow], didFinishWithResults results: SearchResults?, error: NSError?) {
        searchForTerm_didFinish_wasCalled = true
        searchForTerm_didFinish_wasCalled_withResults = results
        searchForTerm_didFinish_wasCalled_withError = error
    }
}
