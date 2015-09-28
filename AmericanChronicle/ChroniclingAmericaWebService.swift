//
//  ChroniclingAmericaWebService.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/15/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

public protocol ChroniclingAmericaWebServiceProtocol {
    func performSearch(term: String, page: Int, andThen: ((SearchResults?, ErrorType?) -> ())?)
    func cancelLastSearch()
    func isPerformingSearch() -> Bool
    func downloadPage(url: NSURL, andThen: ((NSURL?, ErrorType?) -> ())?) -> RequestProtocol?
}

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

public class ChroniclingAmericaWebService: ChroniclingAmericaWebServiceProtocol {

    enum Path: String {
        case PagesSearch = "search/pages/results"
        static let baseURLString = "http://chroniclingamerica.loc.gov/"
        func asURL() -> NSURL {
            let str = "\(Path.baseURLString)\(self.rawValue)"
            return NSURL(string: str)!
        }
    }

    // MARK: Properties

    public private(set) var currentPagesSearch: RequestProtocol?

    static let earliestPossibleDate: NSDate = {
        let calendar = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        components.year = 1836
        return calendar.dateFromComponents(components)!
    }()

    static let latestPossibleDate: NSDate = {
        let calendar = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        components.year = 1922
        components.month = 12
        components.day = 31
        return calendar.dateFromComponents(components)!
    }()

    let manager: ManagerProtocol

    static func newManagerWithLogging() -> Manager {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
//        configuration.protocolClasses?.insert(LoggingURLProtocol.self, atIndex: 0)
        let mgr = Manager(configuration: configuration)
        return mgr
    }

    // MARK: Init methods

    public init(manager: ManagerProtocol = ChroniclingAmericaWebService.newManagerWithLogging()) {
        self.manager = manager
    }

    // MARK: ChroniclingAmericaWebServiceProtocol methods

    public func performSearch(term: String, page: Int, andThen: ((SearchResults?, ErrorType?) -> ())? = nil) {
        self.cancelLastSearch()
        let url = Path.PagesSearch.asURL()
        let params: [String: AnyObject] = ["format": "json", "rows": 20, "proxtext": term, "page": page]
        currentPagesSearch = manager.request(.GET, URLString: url, parameters: params)
        currentPagesSearch?.responseObject { (obj: SearchResults?, error) in
            if let error = error {
                andThen?(nil, error)
            } else {
                andThen?(obj, nil)
            }
        }
    }

    public func cancelLastSearch() {
        currentPagesSearch?.cancel()
    }

    public func isPerformingSearch() -> Bool {
        if let search = currentPagesSearch where search.task.state == .Running {
            return true
        }
        return false
    }

    // ---

    public func downloadPage(remoteURL: NSURL, andThen: ((NSURL?, ErrorType?) -> ())?) -> RequestProtocol? {
        var fileURL: NSURL?
        let destination: (NSURL, NSHTTPURLResponse) -> (NSURL) = { (temporaryURL, response) in
            let documentsDirectoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
            let remotePath = remoteURL.path ?? ""
            fileURL = documentsDirectoryURL.URLByAppendingPathComponent(remotePath).URLByStandardizingPath
            do {
                if let fileDirectoryURL = fileURL?.URLByDeletingLastPathComponent {
                    try NSFileManager.defaultManager().createDirectoryAtURL(fileDirectoryURL, withIntermediateDirectories: true, attributes: nil)
                }
            } catch let error {
                print("[RP] error: \(error)")
            }

            return fileURL ?? temporaryURL
        }
        return manager.download(.GET, URLString: remoteURL.absoluteString, parameters: nil, destination: destination)?.response({ request, response, data, error in
            andThen?(fileURL, error)
        })
    }
}
