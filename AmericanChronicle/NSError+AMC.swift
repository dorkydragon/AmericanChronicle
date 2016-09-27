extension NSError {
    fileprivate static var appDomain: String {
        return "com.ryanipete.AmericanChronicle"
    }

    enum Code: Int {
        case invalidParameter
        case duplicateRequest
        case missingBundleFile
        case allItemsLoaded
    }

    convenience init(code: Code, message: String?) {
        var userInfo: [String: AnyObject] = [:]
        switch code {
        case .invalidParameter:
            userInfo[NSLocalizedDescriptionKey] = "InvalidParameter" as AnyObject?
        case .duplicateRequest:
            userInfo[NSLocalizedDescriptionKey] = "DuplicateRequest" as AnyObject?
        case .missingBundleFile:
            userInfo[NSLocalizedDescriptionKey] = "MissingBundleFile" as AnyObject?
        case .allItemsLoaded:
            userInfo[NSLocalizedDescriptionKey] = "AllItemsLoaded" as AnyObject?
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
        return (code == -999)
    }
}
