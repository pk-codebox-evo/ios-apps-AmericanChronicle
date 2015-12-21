//
//  NSError+AMC.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 10/25/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

public extension NSError {
    private static var appDomain: String {
        return "com.ryanipete.AmericanChronicle"
    }

    public enum Code: Int {
        case InvalidParameter
        case DuplicateRequest
        case MissingBundleFile
        case AllItemsLoaded
    }

    public convenience init(code: Code, message: String?) {
        var userInfo: [String: AnyObject] = [:]
        switch code {
        case .InvalidParameter:
            userInfo[NSLocalizedDescriptionKey] = "InvalidParameter"
        case .DuplicateRequest:
            userInfo[NSLocalizedDescriptionKey] = "DuplicateRequest"
        case .MissingBundleFile:
            userInfo[NSLocalizedDescriptionKey] = "MissingBundleFile"
        case .AllItemsLoaded:
            userInfo[NSLocalizedDescriptionKey] = "AllItemsLoaded"
        }
        userInfo[NSLocalizedRecoverySuggestionErrorKey] = message
        self.init(domain: NSError.appDomain, code: code.rawValue, userInfo: userInfo)
    }

    public func isInvalidParameterError() -> Bool {
        return (Code(rawValue: code) == .InvalidParameter)
            && (domain == NSError.appDomain)
    }

    public func isDuplicateRequestError() -> Bool {
        return (Code(rawValue: code) == .DuplicateRequest) && (domain == NSError.appDomain)
    }

    public func isMissingBundleFileError() -> Bool {
        return (Code(rawValue: code) == .MissingBundleFile) && (domain == NSError.appDomain)
    }

    public func isAllItemsLoadedError() -> Bool {
        return (Code(rawValue: code) == .AllItemsLoaded) && (domain == NSError.appDomain)
    }

    public func isCancelledRequestError() -> Bool {
        return (code == -999)
    }
}
