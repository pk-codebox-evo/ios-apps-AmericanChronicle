//
//  PageDataManagerTests.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 10/24/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import XCTest
import AmericanChronicle

class FakeCachedPageService: CachedPageServiceInterface {
    var stubbed_fileURL: NSURL?
    func fileURLForRemoteURL(remoteURL: NSURL) -> NSURL? {
        return stubbed_fileURL
    }

    func cacheFileURL(fileURL: NSURL, forRemoteURL remoteURL: NSURL) {

    }
}

class PageDataManagerTests: XCTestCase {
    var subject: PageDataManager!
    var webService: FakePageService!
    var cacheService: FakeCachedPageService!

    override func setUp() {
        super.setUp()
        webService = FakePageService()
        cacheService = FakeCachedPageService()
        subject = PageDataManager(webService: webService, cacheService: cacheService)
    }

    func testThat_whenDownloadPageIsCalled_andThePageIsNotCached_itStartsAWebServiceRequest() {
        let URL = NSURL(string: "http://notrealurl.com")!
        subject.downloadPage(URL, completionHandler: { _, _, _ in })
        XCTAssertEqual(webService.downloadPage_wasCalled_withURL, URL)
    }

    func testThat_whenDownloadPageIsCalled_andThePageIsCached_itDoesNotStartAWebServiceRequest() {
        let remoteURL = NSURL(string: "http://notrealurl.com")!
        cacheService.stubbed_fileURL = NSURL(string: "file://doesnotexist")
        subject.downloadPage(remoteURL, completionHandler: { _, _, _ in })

        XCTAssertNil(webService.downloadPage_wasCalled_withURL)
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

    func testThat_whenAWebServiceRequestSucceeds_itReturnsAFileURL() {
        let remoteURL = NSURL(string: "http://notrealurl.com")!
        var returnedFileURL: NSURL?
        subject.downloadPage(remoteURL, completionHandler: { _, fileURL, _ in
            returnedFileURL = fileURL
        })
        let stubbedFileURL = NSURL(string: "file://somewhere")
        webService.downloadPage_wasCalled_withCompletionHandler?(stubbedFileURL, nil)

        XCTAssertEqual(returnedFileURL, stubbedFileURL)
    }

    func testThat_whenAWebServiceRequestFails_itReturnsAnError() {
        let remoteURL = NSURL(string: "http://notrealurl.com")!
        var returnedError: NSError?
        subject.downloadPage(remoteURL, completionHandler: { _, _, error in
            returnedError = error
        })
        let stubbedError = NSError(domain: "", code: 0, userInfo: nil)
        webService.downloadPage_wasCalled_withCompletionHandler?(nil, stubbedError)

        XCTAssertEqual(returnedError, stubbedError)
    }

    func testThat_whenAWebServiceRequestIsCancelled_itPassesTheMessageAlongToTheWebService() {
        let remoteURL = NSURL(string: "http://notrealurl.com")!
        subject.cancelDownload(remoteURL)
        XCTAssertEqual(webService.cancelDownload_wasCalled_withURL, remoteURL)
    }

    func testThat_whenAskedWhetherADownloadIsInProgress_itReturnsTheStatusReportedByTheWebService() {
        webService.stubbed_isDownloadInProgress = true
        XCTAssert(subject.isDownloadInProgress(NSURL(string: "http://notrealurl.com")!))
    }
}
