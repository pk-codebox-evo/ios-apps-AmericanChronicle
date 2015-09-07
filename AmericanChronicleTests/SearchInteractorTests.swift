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

class FakeDelayedSearch: DelayedSearch {
    var didCall_start = false
    override func start() {
        didCall_start = true
    }

    var didCall_cancel = false
    override func cancel() {
        didCall_cancel = true
    }
}

class FakeDelayedSearchFactory: DelayedSearchFactory {
    var didCall_newSearchForTerm_withReturnedSearch: FakeDelayedSearch?
    override func newSearchForTerm(term: String,
        callback: ((SearchResults?, ErrorType?) -> ()),
        webService: ChroniclingAmericaWebServiceProtocol) -> FakeDelayedSearch {
            didCall_newSearchForTerm_withReturnedSearch = FakeDelayedSearch(term: term, callback: callback, webService: webService)
            return didCall_newSearchForTerm_withReturnedSearch!
    }
}

class SearchInteractorTests: XCTestCase {

    var subject: SearchInteractor!
    var fakeWebService: FakeChroniclingAmericaWebService!
    var fakeDelayedSearchFactory: FakeDelayedSearchFactory!

    override func setUp() {
        super.setUp()
        fakeWebService = FakeChroniclingAmericaWebService()
        fakeDelayedSearchFactory = FakeDelayedSearchFactory()
        subject = SearchInteractor(webService: fakeWebService, delayedSearchFactory: fakeDelayedSearchFactory)
    }

    func testThatIt_createsANewRequest_withTheCorrectTerm_whenPerformSearchIsCalled_withANonEmptyTerm() {
        subject.performSearch("Jibberish", andThen: { _, _ in })
        XCTAssertEqual(fakeDelayedSearchFactory.didCall_newSearchForTerm_withReturnedSearch?.term, "Jibberish")
    }

    func testThatIt_startsTheNewRequest_whenPerformSearchIsCalled_withANonEmptyTerm() {
        subject.performSearch("Jibberish", andThen: { _, _ in })
        XCTAssertTrue(fakeDelayedSearchFactory.didCall_newSearchForTerm_withReturnedSearch?.didCall_start ?? false)
    }

    func testThatIt_cancelsTheOldRequest_whenPerformSearchIsCalled_withANonEmptyTerm() {
        subject.performSearch("Blah", andThen: { _, _ in })
        let oldRequest = fakeDelayedSearchFactory.didCall_newSearchForTerm_withReturnedSearch
        subject.performSearch("Blugh", andThen: { _, _ in })
        XCTAssertTrue(oldRequest?.didCall_cancel ?? false)
    }

    func testThatIt_doesNotCreateANewRequest_whenPerformSearchIsCalled_withAnEmptyTerm() {
        subject.performSearch("", andThen: { _, _ in })
        XCTAssertNil(fakeDelayedSearchFactory.didCall_newSearchForTerm_withReturnedSearch)
    }

    func testThatIt_triggersCallbackWithACancel_whenPerformSearchIsCalled_withAnEmptyTerm() {
        var returnedError: NSError?
        subject.performSearch("", andThen: { _, error in
            returnedError = error as? NSError
        })
        XCTAssertEqual(returnedError?.code, -999)
    }

    func testThatIt_cancelsTheOldRequest_whenPerformSearchIsCalled_withAnEmptyTerm() {
        subject.performSearch("Blah", andThen: { _, _ in })
        let oldRequest = fakeDelayedSearchFactory.didCall_newSearchForTerm_withReturnedSearch
        subject.performSearch("", andThen: { _, _ in })
        XCTAssertTrue(oldRequest?.didCall_cancel ?? false)
    }

}
