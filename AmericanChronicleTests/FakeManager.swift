//
//  FakeManager.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 12/27/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

@testable import AmericanChronicle
import Alamofire

class FakeManager: ManagerProtocol {
    var request_wasCalled_withURLString: URLStringConvertible?
    var request_wasCalled_withParameters: [String: AnyObject]?
    var stubbedReturnValue = FakeRequest()
    func request(
        method: Alamofire.Method,
        URLString: URLStringConvertible,
        parameters: [String: AnyObject]?) -> RequestProtocol? {
            request_wasCalled_withURLString = URLString
            request_wasCalled_withParameters = parameters
            return stubbedReturnValue
    }
    var download_wasCalled_withURLString: URLStringConvertible?
    var download_wasCalled_withParameters: [String: AnyObject]?
    var download_wasCalled_handler: (() -> Void)?
    func download(
        method: Alamofire.Method,
        URLString: URLStringConvertible,
        parameters: [String: AnyObject]?, destination: Request.DownloadFileDestination) -> RequestProtocol? {
            download_wasCalled_withURLString = URLString
            download_wasCalled_handler?()
            return stubbedReturnValue
    }
}