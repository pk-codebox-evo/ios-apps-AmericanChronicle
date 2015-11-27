//
//  PageInteractorTests.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/21/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import XCTest
import AmericanChronicle

class FakePageDataManager: PageDataManagerInterface {

    var downloadPage_wasCalled_withRemoteURL: NSURL?
    var downloadPage_wasCalled_withCompletionHandler: ((NSURL, NSURL?, NSError?) -> Void)?
    func downloadPage(remoteURL: NSURL, completionHandler: (NSURL, NSURL?, NSError?) -> Void) {
        downloadPage_wasCalled_withRemoteURL = remoteURL
        downloadPage_wasCalled_withCompletionHandler = completionHandler
    }

    var cancelDownload_wasCalled_withRemoteURL: NSURL?
    func cancelDownload(remoteURL: NSURL) {
        cancelDownload_wasCalled_withRemoteURL = remoteURL
    }

    func isDownloadInProgress(remoteURL: NSURL) -> Bool {
        return false
    }

    func startOCRCoordinatesRequest(
        lccn: String,
        date: NSDate,
        edition: Int,
        sequence: Int,
        completionHandler: (OCRCoordinates?, NSError?) -> Void) {

    }
    func cancelOCRCoordinatesRequest(
        lccn: String,
        date: NSDate,
        edition: Int,
        sequence: Int) {

    }
    func isOCRCoordinatesRequestInProgress(
        lccn: String,
        date: NSDate,
        edition: Int,
        sequence: Int) -> Bool {
            return false
    }
}

class PageInteractorTests: XCTestCase {

    var subject: PageInteractor!
    var remoteURL: NSURL!
    var dataManager: FakePageDataManager!

    override func setUp() {
        super.setUp()

        remoteURL = NSURL(string: "http://www.notreal.com")!
        dataManager = FakePageDataManager()

        subject = PageInteractor(remoteURL: remoteURL, date: NSDate(), lccn: "", edition: 1, sequence: 18, dataManager: dataManager)
    }

    func testThat_whenStartDownloadIsCalled_itStartsTheDownloadForItsRemoteURL() {
        subject.startDownload()
        XCTAssertEqual(dataManager.downloadPage_wasCalled_withRemoteURL, remoteURL)
    }

    func testThat_whenCancelDownloadIsCalled_itAsksItsDataManagerToCancelTheRequestForItsRemoteURL() {
        subject.cancelDownload()
        XCTAssertEqual(dataManager.cancelDownload_wasCalled_withRemoteURL, remoteURL)
    }
}
