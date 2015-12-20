//
//  PageDataManagerTests.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 10/24/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import XCTest
@testable import AmericanChronicle
import ObjectMapper

class FakeCachedPageService: CachedPageServiceInterface {
    var stubbed_fileURL: NSURL?
    func fileURLForRemoteURL(remoteURL: NSURL) -> NSURL? {
        return stubbed_fileURL
    }

    func cacheFileURL(fileURL: NSURL, forRemoteURL remoteURL: NSURL) {

    }
}

class FakeOCRCoordinatesService: OCRCoordinatesServiceInterface {
    var startRequest_wasCalled_withID: String?
    var startRequest_wasCalled_withContextID: String?
    var startRequest_wasCalled_withCompletionHandler: ((OCRCoordinates?, ErrorType?) -> Void)?

    internal func startRequest(
        id: String,
        contextID: String,
        completionHandler: ((OCRCoordinates?, ErrorType?) -> Void))
    {
        startRequest_wasCalled_withID = id
        startRequest_wasCalled_withContextID = contextID
        startRequest_wasCalled_withCompletionHandler = completionHandler
    }

    var cancelRequest_wasCalled_withID: String?
    var cancelRequest_wasCalled_withContextID: String?
    internal func cancelRequest(
        id: String,
        contextID: String)
    {
        cancelRequest_wasCalled_withID = id
        cancelRequest_wasCalled_withContextID = contextID
    }
    
    var stubbed_isRequestInProgress = false
    internal func isRequestInProgress(
        id: String,
        contextID: String) -> Bool
    {
        return stubbed_isRequestInProgress
    }
}

class PageDataManagerTests: XCTestCase {
    var subject: PageDataManager!
    var pageService: FakePageService!
    var cacheService: FakeCachedPageService!
    var coordinatesService: FakeOCRCoordinatesService!

    override func setUp() {
        super.setUp()
        pageService = FakePageService()
        cacheService = FakeCachedPageService()
        coordinatesService = FakeOCRCoordinatesService()
        subject = PageDataManager(pageService: pageService, cachedPageService: cacheService, coordinatesService: coordinatesService)
    }

    func testThat_whenDownloadPageIsCalled_andThePageIsNotCached_itStartsAPageServiceRequest() {
        let URL = NSURL(string: "http://notrealurl.com")!
        subject.downloadPage(URL, completionHandler: { _, _, _ in })
        XCTAssertEqual(pageService.downloadPage_wasCalled_withURL, URL)
    }

    func testThat_whenDownloadPageIsCalled_andThePageIsCached_itDoesNotStartAPageServiceRequest() {
        let remoteURL = NSURL(string: "http://notrealurl.com")!
        cacheService.stubbed_fileURL = NSURL(string: "file://doesnotexist")
        subject.downloadPage(remoteURL, completionHandler: { _, _, _ in })

        XCTAssertNil(pageService.downloadPage_wasCalled_withURL)
    }

    func testThat_whenDownloadPageIsCalled_andThePageIsCached_itReturnsAFileURLImmediately() {
        let remoteURL = NSURL(string: "http://notrealurl.com")!
        var returnedFileURL: NSURL?
        cacheService.stubbed_fileURL = NSURL(string: "file://doesnotexist")
        subject.downloadPage(remoteURL, completionHandler: { _, fileURL, _ in
            returnedFileURL = fileURL
        })

        XCTAssertEqual(returnedFileURL, cacheService.stubbed_fileURL)
    }

    func testThat_whenAPageServiceRequestSucceeds_itReturnsAFileURL() {
        let remoteURL = NSURL(string: "http://notrealurl.com")!
        var returnedFileURL: NSURL?
        subject.downloadPage(remoteURL, completionHandler: { _, fileURL, _ in
            returnedFileURL = fileURL
        })
        let stubbedFileURL = NSURL(string: "file://somewhere")
        pageService.downloadPage_wasCalled_withCompletionHandler?(stubbedFileURL, nil)

        XCTAssertEqual(returnedFileURL, stubbedFileURL)
    }

    func testThat_whenAPageServiceRequestFails_itReturnsAnError() {
        let remoteURL = NSURL(string: "http://notrealurl.com")!
        var returnedError: NSError?
        subject.downloadPage(remoteURL, completionHandler: { _, _, error in
            returnedError = error
        })
        let stubbedError = NSError(domain: "", code: 0, userInfo: nil)
        pageService.downloadPage_wasCalled_withCompletionHandler?(nil, stubbedError)

        XCTAssertEqual(returnedError, stubbedError)
    }



    func testThat_whenAPageServiceRequestIsCancelled_itPassesTheMessageAlongToThePageService() {
        let remoteURL = NSURL(string: "http://notrealurl.com")!
        subject.cancelDownload(remoteURL)
        XCTAssertEqual(pageService.cancelDownload_wasCalled_withURL, remoteURL)
    }



    func testThat_whenAskedWhetherADownloadIsInProgress_itReturnsTheStatusReportedByThePageService() {
        pageService.stubbed_isDownloadInProgress = true
        XCTAssert(subject.isDownloadInProgress(NSURL(string: "http://notrealurl.com")!))
    }

    func testThat_whenStartOCRCoordinatesRequestIsCalled_itStartsAnOCRCoordinatesServiceRequest_withTheSameLCCN() {
        subject.startOCRCoordinatesRequest("sn83045487", completionHandler: { _, _ in })
        XCTAssertEqual(coordinatesService.startRequest_wasCalled_withID, "sn83045487")
    }

    func testThat_whenAnOCRCoordinatesRequestSucceeds_itPassesTheReceivedCoordinatesAlong() {
        var returnedCoordinates: OCRCoordinates?
        subject.startOCRCoordinatesRequest("") { coordinates, _ in
            returnedCoordinates = coordinates
        }

        let expectedCoordinates = OCRCoordinates(Map(mappingType: .FromJSON, JSONDictionary: [:]))
        coordinatesService.startRequest_wasCalled_withCompletionHandler?(expectedCoordinates, nil)

        XCTAssertEqual(returnedCoordinates, expectedCoordinates)
    }

    func testThat_whenAnOCRCoordinatesRequestFails_itPassesTheReceivedErrorAlong() {
        var returnedError: NSError?
        subject.startOCRCoordinatesRequest("") { _, err in
            returnedError = err
        }

        let expectedError = NSError(code: .DuplicateRequest, message: "")
        coordinatesService.startRequest_wasCalled_withCompletionHandler?(nil, expectedError)

        XCTAssertEqual(returnedError, expectedError)
    }

    func testThat_whenAnOCRCoordinatesRequestIsCancelled_itPassesTheMessageAlongToTheOCRCoordinatesService() {
        subject.cancelOCRCoordinatesRequest("sn83045487")
        XCTAssertEqual(coordinatesService.cancelRequest_wasCalled_withID, "sn83045487")
    }

    func testThat_whenAskedWhetherAnOCRCoordinatesRequestIsInProgress_itReturnsTheStatusReportedByTheOCRCoordinatesService() {
        coordinatesService.stubbed_isRequestInProgress = true
        XCTAssert(subject.isOCRCoordinatesRequestInProgress(""))
    }
}
