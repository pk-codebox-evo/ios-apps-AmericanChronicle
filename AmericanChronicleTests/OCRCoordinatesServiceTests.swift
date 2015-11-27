//
//  OCRCoordinatesServiceTests.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 11/22/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import XCTest
import AmericanChronicle
import ObjectMapper

class OCRCoordinatesServiceTests: XCTestCase {

    var subject: OCRCoordinatesService!
    var manager: FakeManager!

    override func setUp() {
        super.setUp()
        manager = FakeManager()
        subject = OCRCoordinatesService(manager: manager)
    }

    func testThat_whenStartRequestIsCalled_withAnEmptyLCCN_itImmediatelyReturnsAnInvalidParameterError() {
        var error: NSError? = nil
        subject.startRequest("", date: NSDate(), edition: 0, sequence: 0, contextID: "") { _, err in
            error = err as? NSError
        }
        XCTAssert(error?.isInvalidParameterError() ?? false)
    }

    func testThat_whenStartRequestIsCalled_withTheCorrectParameters_itStartsARequest_withTheCorrectURL() {
        let lccn = "sn83045487"
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.dateFromString("1913-02-20")!
        let edition = 1
        let sequence = 18

        subject.startRequest(lccn, date: date, edition: edition, sequence: sequence, contextID: "fake-context") { _, _ in }
        XCTAssertEqual(manager.request_wasCalled_withURLString?.URLString, "lccn/sn83045487/1913-02-20/ed-1/seq-18/coordinates/")
    }

    func testThat_whenStartRequestIsCalled_withADuplicateRequest_itImmediatelyReturnsADuplicateRequestError() {
        
        subject.startRequest("sn83045487", date: NSDate(), edition: 1, sequence: 18, contextID: "fake-context") { _, err in }
        var error: NSError? = nil
        subject.startRequest("sn83045487", date: NSDate(), edition: 1, sequence: 18, contextID: "fake-context") { _, err in
            error = err as? NSError
        }
        XCTAssert(error?.isDuplicateRequestError() ?? false)
    }

    func testThat_whenARequestSucceeds_itCallsTheCompletionHandler_withTheCoordinates() {
        var returnedCoordinates: OCRCoordinates?
        subject.startRequest("sn83045487", date: NSDate(), edition: 1, sequence: 18, contextID: "fake-context") { coordinates, _ in
            returnedCoordinates = coordinates
        }
        let expectedCoordinates = OCRCoordinates(Map(mappingType: .FromJSON, JSONDictionary: [:]))
        manager.stubbedReturnValue.finishWithResponseObject(expectedCoordinates, error: nil)
        XCTAssertEqual(returnedCoordinates, expectedCoordinates)
    }

    func testThat_whenARequestFails_itCallsTheCompletionHandler_withTheError() {
        var returnedError: NSError?
        subject.startRequest("sn83045487", date: NSDate(), edition: 1, sequence: 18, contextID: "fake-context") { _, err in
            returnedError = err as? NSError
        }
        let expectedError = NSError(code: .InvalidParameter, message: "")
        let obj: OCRCoordinates? = nil
        manager.stubbedReturnValue.finishWithResponseObject(obj, error: expectedError)
        XCTAssertEqual(returnedError, expectedError)
    }

    func testThat_byTheTimeTheCompletionHandlerIsCalled_theRequestIsNotConsideredToBeInProgress() {
        var isInProgress = true
        let request = FakeRequest()
        manager.stubbedReturnValue = request
        subject.startRequest("", date: NSDate(), edition: 1, sequence: 18, contextID: "") { _, _ in
            isInProgress = self.subject.isRequestInProgress("", date: NSDate(), edition: 1, sequence: 18, contextID: "")
        }
        let obj: OCRCoordinates? = nil
        request.finishWithResponseObject(obj, error: nil)
        XCTAssertFalse(isInProgress)
    }
}
