extension Bundle {
    var versionNumber: String {
        let version = object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        return version ?? "not found"
    }

    var buildNumber: String {
        let build = object(forInfoDictionaryKey: "CFBundleVersion") as? String
        return build ?? "not found"
    }
}
