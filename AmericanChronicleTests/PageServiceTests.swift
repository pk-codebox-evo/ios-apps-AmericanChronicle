//
//  PageServiceTests.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 10/20/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import XCTest
import AmericanChronicle
import Alamofire
import ObjectMapper

class FakeManager: ManagerProtocol {
    var request_wasCalled_withURLString: URLStringConvertible?
    var request_wasCalled_withParameters: [String: AnyObject]?
    var stubbedReturnValue = FakeRequest()
    func request(
        method: Alamofire.Method,
        URLString: URLStringConvertible,
        parameters: [String: AnyObject]?) -> RequestProtocol? {
            request_wasCalled_withURLString = URLString
            request_wasCalled_withParameters = parameters
            return stubbedReturnValue
    }
    var download_wasCalled_withURLString: URLStringConvertible?
    var download_wasCalled_withParameters: [String: AnyObject]?
    var download_wasCalled_handler: (() -> Void)?
    func download(
        method: Alamofire.Method,
        URLString: URLStringConvertible,
        parameters: [String: AnyObject]?, destination: Request.DownloadFileDestination) -> RequestProtocol? {
            download_wasCalled_withURLString = URLString
            download_wasCalled_handler?()
            return stubbedReturnValue
    }
}


class PageServiceTests: XCTestCase {

    var subject: PageService!
    var manager: FakeManager!

    override func setUp() {

        super.setUp()
        manager = FakeManager()
        subject = PageService(manager: manager)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testThat_whenNewDownloadIsRequested_itStartsTheDownload() {
        let expectation = expectationWithDescription("download_was_called")
        manager.download_wasCalled_handler = {
            expectation.fulfill()
        }
        subject.downloadPage(NSURL(string: "http://notarealurl.com")!, contextID: "") { _, _ in }
        waitForExpectationsWithTimeout(0.2, handler: nil)
        XCTAssertEqual(manager.download_wasCalled_withURLString?.URLString, "http://notarealurl.com")
    }

    func testThat_whenAnOngoingDownloadIsRequested_itDoesNotStartTheDownload() {

        let URL = NSURL(string: "http://notarealurl.com")!

        // Make the first request, which *does* start a download.
        let contextA = "contextA"

        let expectDownloadToBeCalled = expectationWithDescription("Expect download to be called")
        manager.download_wasCalled_handler = {
            expectDownloadToBeCalled.fulfill()
        }
        subject.downloadPage(URL, contextID: contextA) { _, _ in }
        waitForExpectationsWithTimeout(0.2, handler: nil)

        // Make the second request, which doesn't start a download.
        let contextB = "contextB"

        var downloadWasCalled = false
        manager.download_wasCalled_handler = {
            downloadWasCalled = true
        }

        let expectGroupToFinishWork = expectationWithDescription("Expect queue group to finish its work")
        dispatch_group_notify(subject.group, dispatch_get_main_queue()) {
            expectGroupToFinishWork.fulfill()
        }

        subject.downloadPage(URL, contextID: contextB) { _, _ in }
        waitForExpectationsWithTimeout(0.2, handler: nil)
        XCTAssertFalse(downloadWasCalled)
    }

    func testThat_whenAnOngoingDownloadIsRequested_andTheProvidedContextIDIsAlreadyRecorded_itReturnsAnError() {
        let URL = NSURL(string: "http://notarealurl.com")!

        // Make the first request.
        let contextA = "contextA"
        subject.downloadPage(URL, contextID: contextA) { _, _ in }

        // Make the second request, which returns an error.

        let expectGroupToFinishWork = expectationWithDescription("Expect queue group to finish its work")
        dispatch_group_notify(subject.group, dispatch_get_main_queue()) {
            expectGroupToFinishWork.fulfill()
        }

        var returnedError: NSError? = nil
        subject.downloadPage(URL, contextID: contextA) { _, err in
            returnedError = err as? NSError
        }
        waitForExpectationsWithTimeout(0.2, handler: nil)
        XCTAssertNotNil(returnedError)
    }

    func testThat_whenAnOngoingDownloadIsRequested_andTheProvidedContextIDIsNotAlreadyRecorded_itDoesNotReturnAnError() {
        let URLString = "http://notarealurl.com"
        let contextID = "abcd-efgh"
        subject.downloadPage(NSURL(string: URLString)!, contextID: contextID) { _, _ in }

        let expectation = expectationWithDescription("completionHandler_wasCalled")
        var error: NSError? = nil
        subject.downloadPage(NSURL(string: URLString)!, contextID: contextID) { _, err in
            error = err as? NSError
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(0.1, handler: nil)
        XCTAssertNotNil(error)
    }

    func testThat_whenADownloadSucceeds_itTriggersTheHandlersThatRequestedTheDownload() {
        let URLString = "http://notarealurl.com"

        var URLOne: NSURL?
        subject.downloadPage(NSURL(string: URLString)!, contextID: "abcd-efgh") { results, _ in
            URLOne = results
        }

        var URLTwo: NSURL?
        subject.downloadPage(NSURL(string: URLString)!, contextID: "efgh-ijkl") { results, _ in
            URLTwo = results
        }

        var URLThree: NSURL?
        subject.downloadPage(NSURL(string: URLString)!, contextID: "ijkl-mnop") { results, _ in
            URLThree = results
        }

        let expectSubjectGroupToEmpty = expectationWithDescription("empty_subject_group")
        dispatch_group_notify(subject.group, dispatch_get_main_queue()) {
            expectSubjectGroupToEmpty.fulfill()
        }
        waitForExpectationsWithTimeout(0.1, handler: nil)

        manager.stubbedReturnValue.finishWithRequest(nil, response: nil, data: nil, error: nil)

        XCTAssertEqual(URLOne, URLTwo)
        XCTAssertEqual(URLTwo, URLThree)
    }

    func testThat_whenADownloadFails_itTriggersTheHandlersThatRequestedTheDownload() {
        let URLString = "http://notarealurl.com"

        var errorOne: NSError?
        subject.downloadPage(NSURL(string: URLString)!, contextID: "abcd-efgh") { _, err in
            errorOne = err as? NSError
        }

        var errorTwo: NSError?
        subject.downloadPage(NSURL(string: URLString)!, contextID: "efgh-ijkl") { _, err in
            errorTwo = err as? NSError
        }

        var errorThree: NSError?
        subject.downloadPage(NSURL(string: URLString)!, contextID: "ijkl-mnop") { _, err in
            errorThree = err as? NSError
        }

        let expectSubjectGroupToEmpty = expectationWithDescription("empty_subject_group")
        dispatch_group_notify(subject.group, dispatch_get_main_queue()) {
            expectSubjectGroupToEmpty.fulfill()
        }
        waitForExpectationsWithTimeout(0.1, handler: nil)
        manager.stubbedReturnValue.finishWithRequest(nil, response: nil, data: nil, error: NSError(code: .InvalidParameter, message: ""))

        XCTAssertEqual(errorOne, errorTwo)
        XCTAssertEqual(errorTwo, errorThree)
    }
    
}
