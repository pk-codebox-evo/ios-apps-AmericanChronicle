extension NSBundle {
    var versionNumber: String {
        let version = objectForInfoDictionaryKey("CFBundleShortVersionString") as? String
        return version ?? "not found"
    }

    var buildNumber: String {
        let build = objectForInfoDictionaryKey("CFBundleVersion") as? String
        return build ?? "not found"
    }
}
