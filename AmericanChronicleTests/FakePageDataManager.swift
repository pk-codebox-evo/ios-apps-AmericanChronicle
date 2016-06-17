@testable import AmericanChronicle

class FakePageDataManager: PageDataManagerInterface {

    var downloadPage_wasCalled_withRemoteURL: NSURL?
    var downloadPage_wasCalled_withCompletionHandler: ((NSURL, NSURL?, NSError?) -> Void)?
    func downloadPage(remoteURL: NSURL, completionHandler: (NSURL, NSURL?, NSError?) -> Void) {
        downloadPage_wasCalled_withRemoteURL = remoteURL
        downloadPage_wasCalled_withCompletionHandler = completionHandler
    }

    var cancelDownload_wasCalled_withRemoteURL: NSURL?
    func cancelDownload(remoteURL: NSURL) {
        cancelDownload_wasCalled_withRemoteURL = remoteURL
    }

    func isDownloadInProgress(remoteURL: NSURL) -> Bool {
        return false
    }

    func startOCRCoordinatesRequest(id: String, completionHandler: (OCRCoordinates?, NSError?) -> Void) {

    }

    func cancelOCRCoordinatesRequest(id: String) {

    }

    func isOCRCoordinatesRequestInProgress(id: String) -> Bool {
        return false
    }
}
