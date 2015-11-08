//
//  DelayedSearchTests.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 11/3/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import XCTest
import AmericanChronicle



class FakeRunLoop: RunLoopInterface {
    var addTimer_wasCalled_withTimer: NSTimer?
    func addTimer(timer: NSTimer, forMode mode: String) {
        addTimer_wasCalled_withTimer = timer
    }
}

class DelayedSearchTests: XCTestCase {
    var subject: DelayedSearch!
    var runLoop: FakeRunLoop!
    var dataManager: FakeSearchDataManager!
    var completionHandlerExpectation: XCTestExpectation?
    var results: SearchResults?
    var error: NSError?

    override func setUp() {
        super.setUp()
        runLoop = FakeRunLoop()
        dataManager = FakeSearchDataManager()

        subject = DelayedSearch(term: "twain", page: 2, dataManager: dataManager, runLoop: runLoop, completionHandler: { results, error in
            self.results = results
            self.error = error as? NSError
            self.completionHandlerExpectation?.fulfill()
        })
    }

    func testThat_itStartsItsTimerImmediately() {
        XCTAssert(runLoop.addTimer_wasCalled_withTimer?.valid ?? false)
    }

    func testThat_beforeTheTimerHasFired_cancelInvalidatesTheTimer() {
        subject.cancel()
        XCTAssertFalse(runLoop.addTimer_wasCalled_withTimer?.valid ?? true)
    }

    func testThat_beforeTheTimerHasFired_cancelTriggersTheCompletionHandler_withACancelledError() {
        subject.cancel()
        XCTAssertEqual(error?.code, -999)
    }

    func testThat_afterTheTimerHasFired_cancelWillCallCancelOnTheDataManager() {
        runLoop.addTimer_wasCalled_withTimer?.fire()
        subject.cancel()
        XCTAssert(dataManager.cancelSearch_wasCalled)
    }

    func testThat_beforeTheTimerHasFired_isSearchInProgressWillReturnTrue() {
        XCTAssert(subject.isSearchInProgress())
    }

    func testThat_afterTheTimerHasFired_isSearchInProgressWillReturnTheValueReturnedByTheDataManager() {
        runLoop.addTimer_wasCalled_withTimer?.fire()
        dataManager.isSearchInProgress_stubbedReturnValue = true
        XCTAssert(subject.isSearchInProgress())
        dataManager.isSearchInProgress_stubbedReturnValue = false
        XCTAssertFalse(subject.isSearchInProgress())
    }

    func testThat_whenTheTimerFires_itStartsSearchOnTheDataManager_withTheCorrectTerm() {
        runLoop.addTimer_wasCalled_withTimer?.fire()
        XCTAssertEqual(dataManager.startSearch_wasCalled_withTerm, "twain")
    }

    func testThat_whenTheTimerFires_itStartsSearchOnTheDataManager_withTheCorrectPage() {
        runLoop.addTimer_wasCalled_withTimer?.fire()
        XCTAssertEqual(dataManager.startSearch_wasCalled_withPage, 2)
    }
}
