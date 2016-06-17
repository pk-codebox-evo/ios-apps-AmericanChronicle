// MARK: -
// MARK: PageDataManagerInterface protocol

/**
 Conforming types can be used as the Page module's data manager.
 */
protocol PageDataManagerInterface {
    func downloadPage(remoteURL: NSURL, completionHandler: (NSURL, NSURL?, NSError?) -> Void)
    func cancelDownload(remoteURL: NSURL)
    func isDownloadInProgress(remoteURL: NSURL) -> Bool
    func startOCRCoordinatesRequest(id: String,
                                    completionHandler: (OCRCoordinates?, NSError?) -> Void)
    func cancelOCRCoordinatesRequest(id: String)
    func isOCRCoordinatesRequestInProgress(id: String) -> Bool
}

// MARK: -
// MARK: PageDataManager class

/**
 Responsibilities:
    - Knows which service to use.
 */
final class PageDataManager: PageDataManagerInterface {

    // MARK: Properties

    private let pageService: PageServiceInterface
    private let cachedPageService: CachedPageServiceInterface
    private let coordinatesService: OCRCoordinatesServiceInterface
    private var contextID: String { return "\(unsafeAddressOf(self))" }

    // MARK: Init methods

    /**
        - Parameters:
            - pageService: The service to use for API requests.
            - cachedPageService: The service to check before making API requests.
    */
    required init(pageService: PageServiceInterface = PageService(),
                  cachedPageService: CachedPageServiceInterface = CachedPageService(),
                  coordinatesService: OCRCoordinatesServiceInterface = OCRCoordinatesService()) {
        self.pageService = pageService
        self.cachedPageService = cachedPageService
        self.coordinatesService = coordinatesService
    }

    // MARK: PageDataManagerInterface methods

    func downloadPage(remoteURL: NSURL, completionHandler: (NSURL, NSURL?, NSError?) -> Void) {
        if let fileURL = cachedPageService.fileURLForRemoteURL(remoteURL) {
            completionHandler(remoteURL, fileURL, nil)
            return
        }

        pageService.downloadPage(remoteURL, contextID: contextID) { fileURL, error in
            if let fileURL = fileURL where error == nil {
                self.cachedPageService.cacheFileURL(fileURL, forRemoteURL: remoteURL)
            }
            completionHandler(remoteURL, fileURL, error as? NSError)
        }
    }

    func cancelDownload(remoteURL: NSURL) {
        pageService.cancelDownload(remoteURL, contextID: contextID)
    }

    func isDownloadInProgress(remoteURL: NSURL) -> Bool {
        return pageService.isDownloadInProgress(remoteURL)
    }

    func startOCRCoordinatesRequest(id: String,
                                    completionHandler: (OCRCoordinates?, NSError?) -> Void) {
        coordinatesService.startRequest(id,
                                        contextID: contextID,
                                        completionHandler: { coordinates, err in
            completionHandler(coordinates, err as? NSError)
        })
    }

    func cancelOCRCoordinatesRequest(id: String) {
        coordinatesService.cancelRequest(id, contextID: contextID)
    }

    func isOCRCoordinatesRequestInProgress(id: String) -> Bool {
        return coordinatesService.isRequestInProgress(id, contextID: contextID)
    }
}
