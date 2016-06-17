protocol CachedPageServiceInterface {
    func fileURLForRemoteURL(remoteURL: NSURL) -> NSURL?
    func cacheFileURL(fileURL: NSURL, forRemoteURL remoteURL: NSURL)
}

final class CachedPageService: CachedPageServiceInterface {
    private var completedDownloads: [NSURL: NSURL] = [:]
    func fileURLForRemoteURL(remoteURL: NSURL) -> NSURL? {
        return completedDownloads[remoteURL]
    }
    func cacheFileURL(fileURL: NSURL, forRemoteURL remoteURL: NSURL) {
        completedDownloads[remoteURL] = fileURL
    }
}
