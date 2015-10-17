//
//  PageDataManager.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 10/17/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

/// Conforming types can be used as the Page module's data manager.
public protocol PageDataManagerInterface {
    func downloadPage(remoteURL: NSURL, completionHandler: (NSURL, NSURL?, NSError?) -> Void)
    func cancelDownload(remoteURL: NSURL)
    func isDownloadInProgress(remoteURL: NSURL) -> Bool
}

/// Responsibilities:
/// * Knows which service to use.
public class PageDataManager: NSObject, PageDataManagerInterface {

    private let webService: PageServiceInterface
    private let cacheService: CachedPageServiceInterface
    private var contextID: String { return "\(unsafeAddressOf(self))" }

    /// * parameters:
    ///     * webService: The service to use for API requests.
    ///     * cacheService: The service to check before making API requests.
    public required init(webService: PageServiceInterface = PageService(),
                         cacheService: CachedPageServiceInterface = CachedPageService())
    {
        self.webService = webService
        self.cacheService = cacheService
        super.init()
    }

    public func downloadPage(remoteURL: NSURL, completionHandler: (NSURL, NSURL?, NSError?) -> Void) {
        if let fileURL = cacheService.fileURLForRemoteURL(remoteURL) {
            completionHandler(remoteURL, fileURL, nil)
            return
        }

        webService.downloadPage(remoteURL, contextID: contextID) { fileURL, error in
            if let fileURL = fileURL where error == nil {
                self.cacheService.cacheFileURL(fileURL, forRemoteURL: remoteURL)
            }
            completionHandler(remoteURL, fileURL, error as? NSError)
        }
    }

    public func cancelDownload(remoteURL: NSURL) {
        webService.cancelDownload(remoteURL, contextID: contextID)
    }

    public func isDownloadInProgress(remoteURL: NSURL) -> Bool {
        return webService.isDownloadInProgress(remoteURL)
    }
}
