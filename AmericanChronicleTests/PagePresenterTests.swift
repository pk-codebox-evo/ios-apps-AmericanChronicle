//
//  PagePresenterTests.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/28/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import XCTest
import AmericanChronicle

class FakePageInteractor: NSObject, PageInteractorInterface {

    var delegate: PageInteractorDelegate?

    var startDownload_wasCalled = false
    func startDownload() {
        startDownload_wasCalled = true
    }

    var cancelDownload_wasCalled = false
    func cancelDownload() {
        cancelDownload_wasCalled = true
    }

    func isDownloadInProgress() -> Bool {
        return false
    }

    func startOCRCoordinatesRequest() {
        
    }
}

class FakePageView: NSObject, PageViewInterface {

    var doneCallback: ((Void) -> ())?
    var shareCallback: ((Void) -> ())?
    var cancelCallback: ((Void) -> ())?
    var pdfPage: CGPDFPageRef?
    var highlights: OCRCoordinates?
    var presenter: PagePresenterInterface?

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

class FakePageWireframe: PageWireframe {
    var userDidTapDone_wasCalled = false
    override func userDidTapDone() {
        userDidTapDone_wasCalled = true
    }
}

class PagePresenterTests: XCTestCase {
    var subject: PagePresenter!
    var interactor: FakePageInteractor!
    var view: FakePageView!
    var wireframe: FakePageWireframe!
    override func setUp() {
        super.setUp()
        view = FakePageView()
        interactor = FakePageInteractor()
        wireframe = FakePageWireframe(remoteURL: NSURL(string: "")!, id: "", searchTerm: nil, date: NSDate(), lccn: "", edition: 0, sequence: 0)
        subject = PagePresenter(view: view, interactor: interactor, searchTerm: "")
        subject.wireframe = wireframe
    }

    func testThat_itSetsTheViewsPresenter() {
        XCTAssertEqual(view.presenter as? PagePresenter, subject)
    }

    func testThat_itSetsTheInteractorsDelegate() {
        XCTAssertEqual(interactor.delegate as? PagePresenter, subject)
    }

    func testThat_whenStartDownloadIsCalled_itTellsTheViewToShowItsLoadingIndicator() {
        subject.startDownload()
        XCTAssertTrue(view.showLoadingIndicator_wasCalled)
    }

    func testThat_whenStartDownloadIsCalled_itTellsTheInteractor() {
        subject.startDownload()
        XCTAssert(interactor.startDownload_wasCalled)
    }

    func testThat_whenADownloadFinishes_itTellsTheViewToHideItsLoadingIndicator() {
        subject.download(NSURL(string: "http://google.com")!, didFinishWithFileURL: nil, error: nil)
        XCTAssertTrue(view.hideLoadingIndicator_wasCalled)
    }

    func testThat_whenADownloadFinishesWithoutAnError_itPassesThePDFToTheView() {
        let requestURL = NSURL(string: "")!
        let currentBundle = NSBundle(forClass: PagePresenterTests.self)
        let returnedFilePathString = currentBundle.pathForResource("seq-1", ofType: "pdf")
        let returnedFileURL = NSURL(fileURLWithPath: returnedFilePathString ?? "")
        XCTAssertNotNil(returnedFileURL)
        subject.download(requestURL, didFinishWithFileURL: returnedFileURL, error: nil)
        XCTAssertNotNil(view.pdfPage)
    }

    func testThat_whenADownloadFinishesWithAnError_itTellsTheViewToShowTheErrorMessage() {
        let requestURL = NSURL(string: "")!
        let returnedError = NSError(domain: "", code: 0, userInfo: nil)
        subject.download(requestURL, didFinishWithFileURL: nil, error: returnedError)
        XCTAssertNotNil(view.showError_wasCalled_withTitle)
    }

    func testThat_whenTheUserTapsCancel_itTellsTheInteractorToCancel() {
        subject.userDidTapCancel()
        XCTAssert(interactor.cancelDownload_wasCalled)
    }

    func testThat_whenTheUserTapsCancel_itTellsTheWireframe() {
        subject.userDidTapCancel()
        XCTAssert(wireframe.userDidTapDone_wasCalled)
    }
}
