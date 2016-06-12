//
//  SearchPresenterTests.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/7/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit
import XCTest
@testable import AmericanChronicle

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

    func testThat_whenTheSearchTermChanges_andTheNewTermIsNotEmpty_itAsksTheViewToShowItsLoadingIndicator() {
        subject.userDidChangeSearchToTerm("Blah")
        XCTAssertEqual(view.setViewState_wasCalled_withState, ViewState.LoadingNewParamaters)
    }

    func testThat_whenTheSearchTermChanges_andTheNewTermIsNotEmpty_itStartsANewSearch_withTheCorrectTerm() {
        subject.userDidChangeSearchToTerm("Blah")
        XCTAssertEqual(interactor.fetchNextPageOfResults_wasCalled_withParameters?.term, "Blah")
    }

    func testThat_whenTheSearchTermChanges_andTheNewTermIsEmpty_itDoesNotStartASearch() {
        subject.userDidChangeSearchToTerm("")
        XCTAssertNil(interactor.fetchNextPageOfResults_wasCalled_withParameters)
    }

    func testThat_whenTheSearchTermChanges_andTheNewTermIsEmpty_itAsksTheViewToShowEmptySearchField() {
        subject.userDidChangeSearchToTerm("")
        XCTAssertEqual(view.setViewState_wasCalled_withState, ViewState.EmptySearchField)
    }

    func testThat_whenTheSearchTermChanges_andTheNewTermIsEmpty_itCancelsTheActiveSearch() {
        subject.userDidChangeSearchToTerm("")
        XCTAssert(interactor.cancelLastSearch_wasCalled)
    }

    func testThat_whenASearchFinishes_andTheInteractorHasNoWork_itAsksTheViewToShowResults() {
        interactor.fake_isSearchInProgress = false
        subject.search(SearchParameters(term: "", states: [], earliestDayMonthYear: SearchConstants.earliestPossibleDayMonthYear, latestDayMonthYear: SearchConstants.latestPossibleDayMonthYear), didFinishWithResults: nil, error: nil)
        XCTAssertEqual(view.setViewState_wasCalled_withState, ViewState.EmptyResults)
    }

    func testThat_whenASearchSucceeds_andThereIsAtLeastOneResult_itAsksTheViewToShowTheResults() {
        let results = SearchResults()
        results.items = [SearchResult()]

        subject.search(SearchParameters(term: "Blah", states: [], earliestDayMonthYear: SearchConstants.earliestPossibleDayMonthYear, latestDayMonthYear: SearchConstants.latestPossibleDayMonthYear), didFinishWithResults: results, error: nil)

        let row = SearchResultsRow(id: "", date: nil, cityState: "", publicationTitle: "", thumbnailURL: nil, pdfURL: nil, lccn: "", edition: 1, sequence: 18)

        XCTAssertEqual(view.setViewState_wasCalled_withState, ViewState.Ideal(title: "0 matches", rows: [row]))
    }

    func testThat_whenASearchSucceeds_andThereAreNoResults_itAsksTheViewToShowItsEmptyResultsMessage() {
        let results = SearchResults()
        results.items = []
        subject.search(SearchParameters(term: "", states: [], earliestDayMonthYear: SearchConstants.earliestPossibleDayMonthYear, latestDayMonthYear: SearchConstants.latestPossibleDayMonthYear), didFinishWithResults: results, error: nil)
        XCTAssertEqual(view.setViewState_wasCalled_withState, ViewState.EmptyResults)
    }

    func testThat_whenASearchFails_itAsksTheViewToShowAnErrorMessage() {
        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: ""])
        subject.search(SearchParameters(term: "", states: [], earliestDayMonthYear: SearchConstants.earliestPossibleDayMonthYear, latestDayMonthYear: SearchConstants.latestPossibleDayMonthYear), didFinishWithResults: nil, error: error)
        XCTAssertEqual(view.setViewState_wasCalled_withState, ViewState.Error(title: "", message: nil))
    }

}
