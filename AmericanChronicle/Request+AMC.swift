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
    func responseObject<T: Mappable>(completionHandler: Response<T, NSError> -> Void) -> Self
    func response(queue queue: dispatch_queue_t?, completionHandler: (NSURLRequest?, NSHTTPURLResponse?, NSData?, NSError?) -> Void) -> Self
    func cancel()
}

extension Request: RequestProtocol {
    
//    public func response(queue queue: dispatch_queue_t? = default, completionHandler: (NSURLRequest?, NSHTTPURLResponse?, NSData?, NSError?) -> Void) -> Self {
//        return response(queue: nil, completionHandler: completionHandler)
//    }
}
