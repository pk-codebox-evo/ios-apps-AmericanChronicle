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
//        configuration.protocolClasses?.insert(TestURLProtocol.self, atIndex: 0)
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

    func testDownload() {
//        let expectation = expectationWithDescription("request")
//        let destination = Alamofire.Request.suggestedDownloadDestination()
//        manager.download(.GET, "http://chroniclingamerica.loc.gov/lccn/sn83045487/1913-02-20/ed-1/seq-18.pdf", destination: destination).progress { bytesRead, totalBytesRead, totalBytesExpected in
//            print("[RP] bytesRead: \(bytesRead)")
//            print("[RP] totalBytesRead: \(totalBytesRead)")
//            print("[RP] totalBytesExpected: \(totalBytesExpected)")
//        }.response { request, response, data, error in
//            print("[RP] request: \(request)")
//            print("[RP] response: \(response)")
//            print("[RP] data: \(data)")
//            print("[RP] error: \(error)")
//            expectation.fulfill()
//        }.resume()
//        waitForExpectationsWithTimeout(60.0, handler: nil)
    }
}
