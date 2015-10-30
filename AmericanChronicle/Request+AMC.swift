//
//  Request+AMC.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 10/12/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import Alamofire
import ObjectMapper
import AlamofireObjectMapper

public protocol RequestProtocol {
    var task: NSURLSessionTask { get }
    func responseObject<T: Mappable>(completionHandler: (T?, ErrorType?) -> Void) -> Self
    func response(completionHandler: (NSURLRequest?, NSHTTPURLResponse?, NSData?, ErrorType?) -> Void) -> Self
    func cancel()
}

extension Request: RequestProtocol {
    public func response(completionHandler: (NSURLRequest?, NSHTTPURLResponse?, NSData?, ErrorType?) -> Void) -> Self {
        return response(queue: nil, completionHandler: completionHandler)
    }
}
