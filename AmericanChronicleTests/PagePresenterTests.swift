//
//  PagePresenterTests.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/28/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import XCTest
import AmericanChronicle

class FakePageInteractor: NSObject, PageInteractorProtocol {
    var downloadPage_wasCalled_withURL: NSURL?
    var downloadPage_wasCalled_withTotalBytesRead: ((Int64) -> ())?
    var downloadPage_wasCalled_withCompletion: ((NSURL?, ErrorType?) -> ())?
    func downloadPage(url: NSURL, totalBytesRead: ((Int64) -> ()), completion: ((NSURL?, ErrorType?) -> ())) {
        downloadPage_wasCalled_withURL = url
        downloadPage_wasCalled_withTotalBytesRead = totalBytesRead
        downloadPage_wasCalled_withCompletion = completion
    }

    var cancelDownload_wasCalled_withURL: NSURL?
    func cancelDownload(url: NSURL) {
        cancelDownload_wasCalled_withURL = url
    }
}

class FakePageView: NSObject, PageView {

    var doneCallback: ((Void) -> ())?
    var shareCallback: ((Void) -> ())?
    var cancelCallback: ((Void) -> ())?
    var pdfPage: CGPDFPageRef?

    var showError_wasCalled_withTitle: String?
    var showError_wasCalled_withMessage: String?
    func showErrorWithTitle(title: String?, message: String?) {
        showError_wasCalled_withTitle = title
        showError_wasCalled_withMessage = message
    }

    var showLoadingIndicator_wasCalled = false
    func showLoadingIndicator() {
        showLoadingIndicator_wasCalled = true
    }

    func setDownloadProgress(progress: Float) {

    }

    var hideLoadingIndicator_wasCalled = false
    func hideLoadingIndicator() {
        hideLoadingIndicator_wasCalled = true
    }
}

class PagePresenterTests: XCTestCase {
    var subject: PagePresenter!
    var fakeInteractor: FakePageInteractor!
    override func setUp() {
        super.setUp()
        fakeInteractor = FakePageInteractor()
        subject = PagePresenter(interactor: fakeInteractor)
    }
    
    override func tearDown() {

        super.tearDown()
    }

    func testThat_whenItSetsUpAView_itTellsTheViewToShowItsLoadingIndicator() {
        let view = FakePageView()
        let url = NSURL(string: "")!
        subject.setUpView(view, url: url, estimatedSize: 0)
        XCTAssertTrue(view.showLoadingIndicator_wasCalled)
    }

    func testThat_whenItSetsUpAView_itStartsTheDownload() {
        let view = FakePageView()
        let url = NSURL(string: "")!
        subject.setUpView(view, url: url, estimatedSize: 0)
        XCTAssertNotNil(fakeInteractor.downloadPage_wasCalled_withURL)
    }

    func testThat_whenADownloadFinishes_itTellsTheViewToHideItsLoadingIndicator() {
        let view = FakePageView()
        let url = NSURL(string: "")!
        subject.setUpView(view, url: url, estimatedSize: 0)
        fakeInteractor.downloadPage_wasCalled_withCompletion?(nil, nil)
        XCTAssertTrue(view.hideLoadingIndicator_wasCalled)
    }

    func testThat_whenADownloadFinishesWithoutAnError_itPassesThePDFToTheView() {
        let view = FakePageView()
        let requestURL = NSURL(string: "")!
        subject.setUpView(view, url: requestURL, estimatedSize: 0)
        let currentBundle = NSBundle(forClass: PagePresenterTests.self)
        let returnedFilePathString = currentBundle.pathForResource("seq-1", ofType: "pdf")
        let returnedFileURL = NSURL(fileURLWithPath: returnedFilePathString ?? "")
        fakeInteractor.downloadPage_wasCalled_withCompletion?(returnedFileURL, nil)
        XCTAssertNotNil(view.pdfPage)
    }

    func testThat_whenADownloadFinishesWithAnError_itTellsTheViewToShowTheErrorMessage() {
        let view = FakePageView()
        let requestURL = NSURL(string: "")!
        subject.setUpView(view, url: requestURL, estimatedSize: 0)
        let returnedError = NSError(domain: "", code: 0, userInfo: nil)
        fakeInteractor.downloadPage_wasCalled_withCompletion?(nil, returnedError)
        XCTAssertNotNil(view.showError_wasCalled_withTitle)
    }

    func testThat_whenTheViewAsksToCancelTheDownload_itPassesTheMessageToTheInteractor() {
        let view = FakePageView()
        let requestURL = NSURL(string: "")!
        subject.setUpView(view, url: requestURL, estimatedSize: 0)
        view.cancelCallback?()
        XCTAssertEqual(fakeInteractor.cancelDownload_wasCalled_withURL, requestURL)
    }

    func testThat_whenTheViewAsksToCancelTheDownload_itConsidersItselfDone() {
        let view = FakePageView()
        let requestURL = NSURL(string: "")!
        subject.setUpView(view, url: requestURL, estimatedSize: 0)
        var doneCallbackTriggered = false
        subject.doneCallback = {
            doneCallbackTriggered = true
        }
        view.cancelCallback?()
        XCTAssertTrue(doneCallbackTriggered)
    }
}
