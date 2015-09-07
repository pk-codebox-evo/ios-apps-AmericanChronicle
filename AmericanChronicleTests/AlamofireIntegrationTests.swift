//
//  AlamofireIntegrationTests.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/10/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit
import XCTest
import Alamofire

class AlamofireIntegrationTests: XCTestCase {

    var manager: Manager!

    override func setUp() {
        super.setUp()
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.protocolClasses?.insert(TestURLProtocol.self, atIndex: 0)
        manager = Manager(configuration: configuration)
        manager.startRequestsImmediately = false
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testThatIt_callsTheResponseBlock_whenARunningRequestIsCancelled() {
//        let expectation = expectationWithDescription("request")
//        let url = "http://google.com"
//        let request = manager.request(.GET, url).response?({ request, response, data, err in
//            XCTAssertEqual(err?.code ?? 0, -999)
//            expectation.fulfill()
//        })
//        TestURLProtocol.didStartLoadingCallbacks[url] = {
//            request.cancel()
//        }
//        request.resume()
//        waitForExpectationsWithTimeout(3.0, handler: nil)
    }

}
