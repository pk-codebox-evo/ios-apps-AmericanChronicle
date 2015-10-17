//
//  FakeSearchView.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/21/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import AmericanChronicle

class FakeSearchView: SearchViewInterface {

    weak var presenter: SearchPresenterInterface?

    var searchResultSelectedCallback: ((SearchResultsRow) -> ())?
    var cancelCallback: ((Void) -> ())?
    var searchTermDidChangeCallback: ((String?) -> ())?

    var showLoadingIndicator_wasCalled = false
    func showLoadingIndicator() {
        showLoadingIndicator_wasCalled = true
    }

    var hideLoadingIndicator_wasCalled = false
    func hideLoadingIndicator() {
        hideLoadingIndicator_wasCalled = true
    }

    var showSearchResults_wasCalled_withRows: [SearchResultsRow]?
    func showSearchResults(rows: [SearchResultsRow], title: String) {
        showSearchResults_wasCalled_withRows = rows
    }


    var showEmptyResults_wasCalled = false
    func showEmptyResults() {
        showEmptyResults_wasCalled = true
    }

    var didCall_showErrorMessage = false
    func showErrorMessage(title: String?, message: String?) {
        didCall_showErrorMessage = true
    }
}
