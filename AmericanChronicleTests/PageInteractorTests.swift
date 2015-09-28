//
//  PageInteractorTests.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/21/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import XCTest
import AmericanChronicle

class PageInteractorTests: XCTestCase {

    var subject: PageInteractor!
    var fakeWebService: FakeChroniclingAmericaWebService!

    override func setUp() {
        super.setUp()
        fakeWebService = FakeChroniclingAmericaWebService()
        subject = PageInteractor(webService: fakeWebService)
    }

    func testThat_whenADownloadCompletesSuccessfully_itReturnsTheLocationOfTheDownloadedFile() {
        var returnedFileURL: NSURL?
        subject.downloadPage(NSURL(string: "")!, andThen: { url, error in
            returnedFileURL = url
        })
        let expectedFileURL = NSURL(string: "www.google.com")
        fakeWebService.downloadPage_called_withParameters?.andThen(expectedFileURL, nil)
        XCTAssertEqual(expectedFileURL, returnedFileURL)
    }

    func testThat_whenADownloadFails_itReturnsAnError() {
        var returnedError: NSError?
        subject.downloadPage(NSURL(string: "")!, andThen: { url, error in
            returnedError = error as? NSError
        })
        let expectedError = NSError(domain: "", code: 0, userInfo: nil)
        fakeWebService.downloadPage_called_withParameters?.andThen(nil, expectedError)
        XCTAssertEqual(expectedError, returnedError)
    }

    func testThat_whileTheCallbackIsBeingTriggered_itStillConsidersTheRequestOngoing() {
        var stillOngoing = false
        let requestURL = NSURL(string: "chroniclingamerica.loc.gov")!
        subject.downloadPage(requestURL, andThen: { url, error in
            stillOngoing = self.subject.isDownloadInProgress(requestURL)
        })
        fakeWebService.downloadPage_called_withParameters?.andThen(nil, nil)
        XCTAssertTrue(stillOngoing)
    }

    func testThat_afterTriggeringTheCallback_itNoLongerConsidersTheRequestOngoing() {
        let requestURL = NSURL(string: "chroniclingamerica.loc.gov")!
        subject.downloadPage(requestURL, andThen: { url, error in
        })
        fakeWebService.downloadPage_called_withParameters?.andThen(nil, nil)
        XCTAssertFalse(subject.isDownloadInProgress(requestURL))
    }

    func testThat_whenItIsAskedToCancelADownload_itCancelsTheCorrectRequest() {
        let url = NSURL(string: "chroniclingamerica.com")!
        subject.downloadPage(url, andThen: { _, _ in })
        let request = subject.activeRequests[url] as! FakeRequest
        subject.cancelDownload(url)
        XCTAssertTrue(request.cancel_wasCalled)
    }
}
