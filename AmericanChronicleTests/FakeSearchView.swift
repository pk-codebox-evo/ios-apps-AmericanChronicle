//
//  FakeSearchView.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/21/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import AmericanChronicle

class FakeSearchView: SearchView {
    var searchResultSelectedCallback: ((SearchResultsRow) -> ())?
    var cancelCallback: ((Void) -> ())?
    var searchTermDidChangeCallback: ((String?) -> ())?

    var didCall_showLoadingIndicator = false
    func showLoadingIndicator() {
        didCall_showLoadingIndicator = true
    }

    var didCall_hideLoadingIndicator = false
    func hideLoadingIndicator() {
        didCall_hideLoadingIndicator = true
    }

    var didCall_showSearchResults = false
    func showSearchResults(rows: [SearchResultsRow], title: String) {
        didCall_showSearchResults = true
    }

    var didCall_showEmptyResults = false
    func showEmptyResults() {
        didCall_showEmptyResults = true
    }

    var didCall_showErrorMessage = false
    func showErrorMessage(title: String?, message: String?) {
        didCall_showErrorMessage = true
    }
}
