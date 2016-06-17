@testable import AmericanChronicle

class FakePageInteractor: NSObject, PageInteractorInterface {

    var delegate: PageInteractorDelegate?

    var startDownload_wasCalled = false
    func startDownloadWithRemoteURL(remoteURL: NSURL) {
        startDownload_wasCalled = true
    }

    var cancelDownload_wasCalled = false
    func cancelDownloadWithRemoteURL(remoteURL: NSURL) {
        cancelDownload_wasCalled = true
    }

    func isDownloadWithRemoteURLInProgress(remoteURL: NSURL) -> Bool {
        return false
    }

    func startOCRCoordinatesRequestWithID(id: String) {
    }
}
