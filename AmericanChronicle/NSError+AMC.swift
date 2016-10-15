extension NSError {
    fileprivate static var appDomain: String {
        return "com.ryanipete.AmericanChronicle"
    }

    enum Code: Int {
        case invalidParameter
        case invalidRequestURL
        case duplicateRequest
        case missingBundleFile
        case allItemsLoaded
        case cancelled = -999
    }

    convenience init(code: Code, message: String?) {
        var userInfo: [String: AnyObject] = [:]
        switch code {
        case .invalidParameter:
            userInfo[NSLocalizedDescriptionKey] = "invalidParameter" as AnyObject?
        case .invalidRequestURL:
            userInfo[NSLocalizedDescriptionKey] = "invalidRequestURL" as AnyObject?
        case .duplicateRequest:
            userInfo[NSLocalizedDescriptionKey] = "duplicateRequest" as AnyObject?
        case .missingBundleFile:
            userInfo[NSLocalizedDescriptionKey] = "missingBundleFile" as AnyObject?
        case .allItemsLoaded:
            userInfo[NSLocalizedDescriptionKey] = "allItemsLoaded" as AnyObject?
        case .cancelled:
            userInfo[NSLocalizedDescriptionKey] = "cancelled" as AnyObject?
        }
        userInfo[NSLocalizedRecoverySuggestionErrorKey] = message as AnyObject?
        self.init(domain: NSError.appDomain, code: code.rawValue, userInfo: userInfo)
    }

    func isInvalidParameterError() -> Bool {
        return (Code(rawValue: code) == .invalidParameter)
            && (domain == NSError.appDomain)
    }

    func isDuplicateRequestError() -> Bool {
        return (Code(rawValue: code) == .duplicateRequest) && (domain == NSError.appDomain)
    }

    func isMissingBundleFileError() -> Bool {
        return (Code(rawValue: code) == .missingBundleFile) && (domain == NSError.appDomain)
    }

    func isAllItemsLoadedError() -> Bool {
        return (Code(rawValue: code) == .allItemsLoaded) && (domain == NSError.appDomain)
    }

    func isCancelledRequestError() -> Bool {
        return (code == Code.cancelled.rawValue)
    }
}
