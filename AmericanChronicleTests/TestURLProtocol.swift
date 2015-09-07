//
//  TestURLProtocol.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/12/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

class TestURLProtocol: NSURLProtocol {

    static var instancesLoading: [String: TestURLProtocol] = [:]
    static var didStartLoadingCallbacks: [String: ((Void) -> ())] = [:]

    override init(request: NSURLRequest, cachedResponse: NSCachedURLResponse?, client: NSURLProtocolClient?) {
        super.init(request: request, cachedResponse: cachedResponse, client: client)
    }

    class func finishLoading(URL: String) {
        if let instance = instancesLoading[URL] {
            instance.client?.URLProtocolDidFinishLoading(instance)
        }
    }

    override class func canInitWithRequest(request: NSURLRequest) -> Bool {
        return true
    }

    override func startLoading() {
        if let callback = TestURLProtocol.didStartLoadingCallbacks[request.URL?.absoluteString ?? ""] {
            callback()
        }
        TestURLProtocol.instancesLoading[request.URL?.absoluteString ?? ""] = self
    }

    override func stopLoading() {
        TestURLProtocol.instancesLoading[request.URL?.absoluteString ?? ""] = nil
    }

    override class func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest {
        return request
    }

}
