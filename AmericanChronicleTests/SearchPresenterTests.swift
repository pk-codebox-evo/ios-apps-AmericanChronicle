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

class FakeSearchWireframe: SearchWireframe {
    var userDidTapCancel_wasCalled = false
    override func userDidTapCancel() {
        userDidTapCancel_wasCalled = true
    }
}

class SearchPresenterTests: XCTestCase {

    var subject: SearchPresenter!

    var wireframe: FakeSearchWireframe!
    var view: FakeSearchView!
    var interactor: FakeSearchInteractor!

    override func setUp() {
        super.setUp()
        wireframe = FakeSearchWireframe()
        view = FakeSearchView()
        interactor = FakeSearchInteractor()

        subject = SearchPresenter()
        subject.wireframe = wireframe
        subject.view = view
        subject.interactor = interactor
    }

    func testThat_whenTheUserTapsCancel_itLetsTheWireframeKnow() {
        subject.userDidTapCancel()
        XCTAssert(wireframe.userDidTapCancel_wasCalled)
    }

    func testThat_whenTheSearchTermChanges_andTheNewTermIsNotEmpty_itStartsASearch() {
        subject.userDidChangeSearchToTerm("Blah")
        XCTAssertEqual(interactor.startSearch_wasCalled_withTerm ?? "", "Blah")
    }

    func testThat_whenTheSearchTermChanges_andTheNewTermIsNotEmpty_itAsksTheViewToShowItsLoadingIndicator() {
        subject.userDidChangeSearchToTerm("Blah")
        XCTAssert(view.showLoadingIndicator_wasCalled)
    }

    func testThat_whenTheSearchTermChanges_andTheNewTermIsEmpty_itDoesNotStartASearch() {
        subject.userDidChangeSearchToTerm("")
        XCTAssertFalse(interactor.startSearch_wasCalled)
    }
//
    func testThat_whenTheSearchTermChanges_andTheNewTermIsEmpty_itDoesNotAskTheViewToShowItsLoadingIndicator() {
        subject.userDidChangeSearchToTerm("")
        XCTAssertFalse(view.showLoadingIndicator_wasCalled)
    }

    func testThat_whenTheSearchTermChanges_andTheNewTermIsEmpty_itCancelsTheActiveSearch() {
        subject.userDidChangeSearchToTerm("")
        XCTAssert(interactor.cancelLastSearch_wasCalled)
    }

    func testThat_whenTheSearchTermChanges_andTheNewTermIsEmpty_itAsksTheViewToShowAnEmptySetOfSearchResults() {
        subject.userDidChangeSearchToTerm("")
        XCTAssertEqual(view.showSearchResults_wasCalled_withRows!, [SearchResultsRow]())
    }

    func testThat_whenASearchFinishes_andTheInteractorHasNoWork_itAsksTheViewToHideItsLoadingIndicator() {
        interactor.fake_isSearchInProgress = false
        subject.searchForTerm("Blah", page: 0, didFinishWithResults: nil, error: nil)
        XCTAssert(view.hideLoadingIndicator_wasCalled)
    }

    func testThat_whenASearchFinishes_andTheInteractorIsStillDoingWork_itDoesNotAskTheViewToHideItsLoadingIndicator() {
        interactor.fake_isSearchInProgress = true
        subject.searchForTerm("Blah", page: 0, didFinishWithResults: nil, error: nil)
        XCTAssertFalse(view.hideLoadingIndicator_wasCalled)
    }

    func testThat_whenASearchSucceeds_andThereIsAtLeastOneResult_itAsksTheViewToShowTheResults() {
        let results = SearchResults()
        results.items = [SearchResult()]
        subject.searchForTerm("Blah", page: 0, didFinishWithResults: results, error: nil)
        XCTAssertEqual(view.showSearchResults_wasCalled_withRows?.count, 1)
    }

    func testThat_whenASearchSucceeds_andThereAreNoResults_itAsksTheViewToShowItsEmptyResultsMessage() {
        let results = SearchResults()
        results.items = []
        subject.searchForTerm("Blah", page: 0, didFinishWithResults: results, error: nil)
        XCTAssert(view.showEmptyResults_wasCalled)
    }

    func testThat_whenASearchFails_itAsksTheViewToShowAnErrorMessage() {
        let error = NSError(domain: "", code: 0, userInfo: nil)
        subject.searchForTerm("Blah", page: 0, didFinishWithResults: nil, error: error)
        XCTAssert(view.didCall_showErrorMessage)
    }

}
