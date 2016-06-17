extension NSError {
    private static var appDomain: String {
        return "com.ryanipete.AmericanChronicle"
    }

    enum Code: Int {
        case InvalidParameter
        case DuplicateRequest
        case MissingBundleFile
        case AllItemsLoaded
    }

    convenience init(code: Code, message: String?) {
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

    func isInvalidParameterError() -> Bool {
        return (Code(rawValue: code) == .InvalidParameter)
            && (domain == NSError.appDomain)
    }

    func isDuplicateRequestError() -> Bool {
        return (Code(rawValue: code) == .DuplicateRequest) && (domain == NSError.appDomain)
    }

    func isMissingBundleFileError() -> Bool {
        return (Code(rawValue: code) == .MissingBundleFile) && (domain == NSError.appDomain)
    }

    func isAllItemsLoadedError() -> Bool {
        return (Code(rawValue: code) == .AllItemsLoaded) && (domain == NSError.appDomain)
    }

    func isCancelledRequestError() -> Bool {
        return (code == -999)
    }
}
