@testable import AmericanChronicle

class FakeCachedPageService: CachedPageServiceInterface {
    var stubbed_fileURL: NSURL?
    func fileURLForRemoteURL(remoteURL: NSURL) -> NSURL? {
        return stubbed_fileURL
    }

    func cacheFileURL(fileURL: NSURL, forRemoteURL remoteURL: NSURL) {

    }
}
