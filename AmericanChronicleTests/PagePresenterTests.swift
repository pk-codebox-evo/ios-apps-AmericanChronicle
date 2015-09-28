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
    var downloadPage_called = false
    var downloadPage_called_withCallback: ((NSURL?, ErrorType?) -> ())?
    func downloadPage(url: NSURL, andThen callback: ((NSURL?, ErrorType?) -> ())) {
        downloadPage_called = true
        downloadPage_called_withCallback = callback
    }
}

class FakePageView: NSObject, PageView {

    var doneCallback: ((Void) -> ())?
    var shareCallback: ((Void) -> ())?
    var fileURL: NSURL?

    var showError_wasCalled_withTitle: String?
    var showError_wasCalled_withMessage: String?
    func showErrorWithTitle(title: String?, message: String?) {
        showError_wasCalled_withTitle = title
        showError_wasCalled_withMessage = message
    }

    var showLoadingIndicator_called = false
    func showLoadingIndicator() {
        showLoadingIndicator_called = true
    }

    var hideLoadingIndicator_called = false
    func hideLoadingIndicator() {
        hideLoadingIndicator_called = true
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
        subject.setUpView(view, url: url)
        XCTAssertTrue(view.showLoadingIndicator_called)
    }

    func testThat_whenItSetsUpAView_itStartsTheDownload() {
        let view = FakePageView()
        let url = NSURL(string: "")!
        subject.setUpView(view, url: url)
        XCTAssertTrue(fakeInteractor.downloadPage_called)
    }

    func testThat_whenADownloadFinishes_itTellsTheViewToHideItsLoadingIndicator() {
        let view = FakePageView()
        let url = NSURL(string: "")!
        subject.setUpView(view, url: url)
        fakeInteractor.downloadPage_called_withCallback?(nil, nil)
        XCTAssertTrue(view.hideLoadingIndicator_called)
    }

    func testThat_whenADownloadFinishesWithoutAnError_itTellsTheViewToShowThePDF() {
        let view = FakePageView()
        let requestURL = NSURL(string: "")!
        subject.setUpView(view, url: requestURL)
        let returnedFileURL = NSURL(string: "")
        fakeInteractor.downloadPage_called_withCallback?(returnedFileURL, nil)
        XCTAssertEqual(view.fileURL, returnedFileURL)
    }

    func testThat_whenADownloadFinishesWithAnError_itTellsTheViewToShowTheErrorMessage() {
        let view = FakePageView()
        let requestURL = NSURL(string: "")!
        subject.setUpView(view, url: requestURL)
        let returnedError = NSError(domain: "", code: 0, userInfo: nil)
        fakeInteractor.downloadPage_called_withCallback?(nil, returnedError)
        XCTAssertNotNil(view.showError_wasCalled_withTitle)
    }
    
}
