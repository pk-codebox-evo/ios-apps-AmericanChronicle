//
//  SearchPresenterTests.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/7/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit
import XCTest
import AmericanChronicle

class SearchPresenterTests: XCTestCase {

    var subject: SearchPresenter!
    var fakeInteractor: FakeSearchInteractor!
    var fakeView: FakeSearchView!

    override func setUp() {
        super.setUp()
        fakeInteractor = FakeSearchInteractor()
        subject = SearchPresenter(interactor: fakeInteractor, searchDelay: 0)
        fakeView = FakeSearchView()
        subject.setUpView(fakeView)
    }

    func testThat_whenTheViewCancels_itCallsItsOwnCancelCallback() {
        var didCallCancelCallback = false
        subject.cancelCallback = {
            didCallCancelCallback = true
        }
        fakeView.cancelCallback?()
        XCTAssertTrue(didCallCancelCallback)
    }

    func testThat_whenTheSearchTermChanges_andTheNewTermIsNotEmpty_itPerformsASearch() {
        fakeView.searchTermDidChangeCallback?("Blah")
        XCTAssertEqual(fakeInteractor.didCall_performSearch_withTerm ?? "", "Blah")
    }

    func testThat_whenTheSearchTermChanges_andTheNewTermIsNotEmpty_itAsksTheViewToShowItsLoadingIndicator() {
        fakeView.searchTermDidChangeCallback?("Blah")
        XCTAssertTrue(fakeView.didCall_showLoadingIndicator)
    }

    func testThat_whenTheSearchTermChanges_andTheNewTermIsEmpty_itDoesNotPerformASearch() {
        fakeView.searchTermDidChangeCallback?("")
        XCTAssertFalse(fakeInteractor.didCall_performSearch)
    }

    func testThat_whenTheSearchTermChanges_andTheNewTermIsEmpty_itDoesNotAskTheViewToShowItsLoadingIndicator() {
        fakeView.searchTermDidChangeCallback?("")
        XCTAssertFalse(fakeView.didCall_showLoadingIndicator)
    }

    func testThat_whenASearchFinishes_andTheInteractorIsNoLongerDoingWork_itAsksTheViewToHideItsLoadingIndicator() {
        fakeView.searchTermDidChangeCallback?("Blah")
        fakeInteractor.fake_isDoingWork = false
        fakeInteractor.didCall_performSearch_withCallback!(nil, nil)
        XCTAssertTrue(fakeView.didCall_hideLoadingIndicator)
    }

    func testThat_whenASearchFinishes_andTheInteractorIsStillDoingWork_itDoesNotAskTheViewToHideItsLoadingIndicator() {
        fakeView.searchTermDidChangeCallback?("Blah")
        fakeInteractor.fake_isDoingWork = true
        fakeInteractor.didCall_performSearch_withCallback!(nil, nil)
        XCTAssertFalse(fakeView.didCall_hideLoadingIndicator)
    }

    func testThat_whenASearchSucceeds_andThereIsAtLeastOneResult_itAsksTheViewToShowTheResults() {
        fakeView.searchTermDidChangeCallback?("Blah")
        let results = SearchResults()
        results.items = [SearchResult()]
        fakeInteractor.didCall_performSearch_withCallback?(results, nil)
        XCTAssertTrue(fakeView.didCall_showSearchResults)
    }

    func testThat_whenASearchSucceeds_andThereAreNoResults_itAsksTheViewToShowItsEmptyResultsMessage() {
        fakeView.searchTermDidChangeCallback?("Blah")
        let results = SearchResults()
        results.items = []
        fakeInteractor.didCall_performSearch_withCallback?(results, nil)
        XCTAssertTrue(fakeView.didCall_showEmptyResults)
    }

    func testThat_whenASearchFails_itAsksTheViewToShowAnErrorMessage() {
        fakeView.searchTermDidChangeCallback?("Blah")
        let error = NSError(domain: "", code: 0, userInfo: nil)
        fakeInteractor.didCall_performSearch_withCallback?(nil, error)
        XCTAssertTrue(fakeView.didCall_showErrorMessage)
    }

}
