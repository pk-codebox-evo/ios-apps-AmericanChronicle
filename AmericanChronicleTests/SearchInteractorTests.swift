//
//  SearchInteractorTests.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/6/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit
import XCTest
import AmericanChronicle

class SearchInteractorTests: XCTestCase {

    var subject: SearchInteractor!
    var searchFactory: FakeDelayedSearchFactory!
    var delegate: FakeSearchInteractorDelegate!

    override func setUp() {
        super.setUp()
        searchFactory = FakeDelayedSearchFactory()
        delegate = FakeSearchInteractorDelegate()
        subject = SearchInteractor(searchFactory: searchFactory)
        subject.delegate = delegate
    }

    // --- startSearchForTerm(_, existingRows:) --- //

    // * New term
    //   * No existing rows

    func testThat_whenStartSearchIsCalled_withANewTerm_andNoExistingRows_itAsksTheDataManagerToStartASearchWithTheSameTerm() {
        subject.startSearchForTerm("Jibberish", existingRows: [])
        XCTAssertEqual(searchFactory.newSearchForTerm_wasCalled_withTerm, "Jibberish")
    }

    func testThat_whenStartSearchIsCalled_withANewTerm_andNoExistingRows_itAsksTheDataManagerToStartASearchWithTheCorrectPage() {
        subject.startSearchForTerm("Jibberish", existingRows: [])
        XCTAssertEqual(searchFactory.newSearchForTerm_wasCalled_withPage, 1)
    }

    // * New term
    //   * existingRows % 20 == 0

    func testThat_whenStartSearchIsCalled_withANewTerm_andNumberOfExistingRowsEvenlyDivisibleByPageSize_itAsksTheDataManagerToStartASearchWithTheCorrectPage() {
        let rows = (0..<40).map { _ in
            SearchResultsRow(
                id: "",
                date: nil,
                cityState: "",
                publicationTitle: "",
                thumbnailURL: nil,
                pdfURL: nil,
                lccn: "",
                edition: 0,
                sequence: 0)
        }
        subject.startSearchForTerm("Jibberish", existingRows: rows)
        XCTAssertEqual(searchFactory.newSearchForTerm_wasCalled_withPage, 3)
    }

    func testThat_whenStartSearchIsCalled_withANewTerm_andNumberOfExistingRowsEvenlyDivisibleByPageSize_itCancelsTheLastSearch() {
        subject.startSearchForTerm("First Search", existingRows: [])
        let firstSearch = searchFactory.newSearchForTerm_lastReturnedSearch
        subject.startSearchForTerm("Second Search", existingRows: [])
        XCTAssert(firstSearch?.cancel_wasCalled ?? false)
    }

    // * New term
    //   * existingRows % 20 != 0

    func testThat_whenStartSearchIsCalled_withANewTerm_andNumberOfExistingRowsNotEvenlyDivisibleByPageSize_itFailsImmediatelyWithAnInvalidParameterError() {
        let rows = (0..<25).map { _ in
            SearchResultsRow(
                id: "",
                date: nil,
                cityState: "",
                publicationTitle: "",
                thumbnailURL: nil,
                pdfURL: nil,
                lccn: "",
                edition: 0,
                sequence: 0)
        }
        subject.startSearchForTerm("Jibberish", existingRows: rows)
        XCTAssert(delegate.searchForTerm_didFinish_wasCalled_withError?.isInvalidParameterError() ?? false)
    }

    func testThat_whenStartSearchIsCalled_withANewTerm_andNumberOfExistingRowsNotEvenlyDivisibleByPageSize_itDoesNotCancelTheLastSearch() {
        subject.startSearchForTerm("First Search", existingRows: [])
        let firstSearch = searchFactory.newSearchForTerm_lastReturnedSearch
        let rows = (0..<25).map { _ in
            SearchResultsRow(
                id: "",
                date: nil,
                cityState: "",
                publicationTitle: "",
                thumbnailURL: nil,
                pdfURL: nil,
                lccn: "",
                edition: 0,
                sequence: 0)
        }
        subject.startSearchForTerm("Second Search", existingRows: rows)
        XCTAssertFalse(firstSearch?.cancel_wasCalled ?? true)
    }

    // * Duplicate term
    //   * First search still in progress

    func testThat_whenStartSearchIsCalled_withADuplicateTerm_andTheFirstSearchIsStillInProgress_itFailsImmediatelyWithADuplicateRequestError() {
        subject.startSearchForTerm("First Search", existingRows: [])
        let firstSearch = searchFactory.newSearchForTerm_lastReturnedSearch
        firstSearch?.isSearchInProgress_returnValue = true
        subject.startSearchForTerm("First Search", existingRows: [])
        XCTAssert(delegate.searchForTerm_didFinish_wasCalled_withError!.isDuplicateRequestError() ?? false)

    }

    func testThat_whenStartSearchIsCalled_withADuplicateTerm_andTheFirstSearchIsStillInProgress_itDoesNotCancelTheLastSearch() {
        subject.startSearchForTerm("First Search", existingRows: [])
        let firstSearch = searchFactory.newSearchForTerm_lastReturnedSearch
        firstSearch?.isSearchInProgress_returnValue = true
        subject.startSearchForTerm("First Search", existingRows: [])
        XCTAssertFalse(firstSearch?.cancel_wasCalled ?? true)
    }

    // * Duplicate term
    //   * First search has already finished

    func testThat_whenStartSearchIsCalled_withADuplicateTerm_andTheFirstSearchHasFinished_itAsksTheDataManagerToStartASearchWithTheDuplicateTerm() {
        subject.startSearchForTerm("First Search", existingRows: [])
        let firstSearch = searchFactory.newSearchForTerm_lastReturnedSearch
        firstSearch?.cancel()
        searchFactory.newSearchForTerm_wasCalled_withTerm = nil
        subject.startSearchForTerm("First Search", existingRows: [])

        XCTAssertEqual(searchFactory.newSearchForTerm_wasCalled_withTerm, "First Search")
    }

    // --- startSearchForTerm(_, existingRows:) -> (results, error) --- //

    func testThat_whenASearchSucceeds_itPassesTheResultsToItsDelegate() {
        subject.startSearchForTerm("", existingRows: [])
        let results = SearchResults()
        searchFactory.newSearchForTerm_lastReturnedSearch?.finishRequestWithSearchResults(results, error: nil)
        XCTAssertEqual(delegate.searchForTerm_didFinish_wasCalled_withResults, results)
    }

    func testThat_whenASearchFails_itPassesTheErrorToItsDelegate() {
        subject.startSearchForTerm("", existingRows: [])
        let error = NSError(code: .InvalidParameter, message: "")
        searchFactory.newSearchForTerm_lastReturnedSearch?.finishRequestWithSearchResults(nil, error: error)
        XCTAssertEqual(delegate.searchForTerm_didFinish_wasCalled_withError, error)
    }

    // --- isSearchInProgress() --- //

    func testThat_whenAskedWhetherASearchIsInProgress_itAsksTheActiveSearch() {
        subject.startSearchForTerm("sample search", existingRows: [])
        let search = searchFactory.newSearchForTerm_lastReturnedSearch
        subject.isSearchInProgress()
        XCTAssert(search?.isSearchInProgress_wasCalled ?? false)
    }

    // --- cancelLastSearch() --- //

    func testThat_whenCancelLastSearchIsCalled_itCancelsTheActiveSearch() {
        subject.startSearchForTerm("some term", existingRows: [])
        let search = searchFactory.newSearchForTerm_lastReturnedSearch
        subject.cancelLastSearch()
        XCTAssert(search?.cancel_wasCalled ?? false)
    }
}
