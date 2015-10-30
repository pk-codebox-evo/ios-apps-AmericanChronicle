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
    }

    public convenience init(code: Code) {
        self.init(domain: NSError.appDomain, code: code.rawValue, userInfo: nil)
    }

    public func isInvalidParameterError() -> Bool {
        return (Code(rawValue: code) == .InvalidParameter)
            && (domain == NSError.appDomain)
    }

    public func isDuplicateRequestError() -> Bool {
        return (Code(rawValue: code) == .DuplicateRequest) && (domain == NSError.appDomain)
    }
}
