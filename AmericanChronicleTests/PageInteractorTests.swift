import XCTest
@testable import AmericanChronicle

class PageInteractorTests: XCTestCase {

    var subject: PageInteractor!
    var remoteURL: NSURL!
    var dataManager: FakePageDataManager!

    override func setUp() {
        super.setUp()

        remoteURL = NSURL(string: "http://www.notreal.com")!
        dataManager = FakePageDataManager()

        subject = PageInteractor(dataManager: dataManager)
    }

    func testThat_whenStartDownloadIsCalled_itStartsTheDownloadForItsRemoteURL() {
        subject.startDownloadWithRemoteURL(remoteURL)
        XCTAssertEqual(dataManager.downloadPage_wasCalled_withRemoteURL, remoteURL)
    }

    func testThat_whenCancelDownloadIsCalled_itAsksItsDataManagerToCancelTheRequestForItsRemoteURL() {
        subject.cancelDownloadWithRemoteURL(remoteURL)
        XCTAssertEqual(dataManager.cancelDownload_wasCalled_withRemoteURL, remoteURL)
    }
}
