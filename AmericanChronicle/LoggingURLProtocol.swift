//
//  LoggingURLProtocol.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/20/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import UIKit

class LoggingURLProtocol: NSURLProtocol {
    static var instancesLoading: [String: LoggingURLProtocol] = [:]
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
        print("Start Loading \(request.URLString)")
    }

    override func stopLoading() {
        print("Stop Loading \(request.URLString)")
    }

    override class func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest {
        return request
    }
}
