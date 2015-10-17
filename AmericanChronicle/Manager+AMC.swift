//
//  Manager+AMC.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 10/12/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import Alamofire

public protocol ManagerProtocol {
    func request(
        method: Alamofire.Method,
        URLString: URLStringConvertible,
        parameters: [String: AnyObject]?) -> RequestProtocol?
    func download(
        method: Alamofire.Method,
        URLString: URLStringConvertible,
        parameters: [String: AnyObject]?, destination: Request.DownloadFileDestination) -> RequestProtocol?
}

extension Manager: ManagerProtocol {
    public func request(
        method: Alamofire.Method,
        URLString: URLStringConvertible,
        parameters: [String: AnyObject]?) -> RequestProtocol? {
            return request(method, URLString, parameters: parameters, encoding: .URL,
                headers: nil)
    }

    public func download(
        method: Alamofire.Method,
        URLString: URLStringConvertible,
        parameters: [String: AnyObject]?, destination: Request.DownloadFileDestination) -> RequestProtocol? {
            return download(method, URLString, parameters: parameters, encoding: .URL, headers: nil, destination: destination)
    }
}
