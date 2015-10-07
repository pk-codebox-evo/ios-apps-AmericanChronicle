//
//  PageInteractor.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/21/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

public protocol PageInteractorProtocol {
    func downloadPage(url: NSURL, andThen: ((NSURL?, ErrorType?) -> ()))
    func cancelDownload(url: NSURL)
}

public class PageInteractor: NSObject, PageInteractorProtocol {

    let webService: ChroniclingAmericaWebServiceProtocol
    public init(webService: ChroniclingAmericaWebServiceProtocol = ChroniclingAmericaWebService()) {
            self.webService = webService
            super.init()
    }

    public var activeRequests: [NSURL: RequestProtocol] = [:]
    public var completedDownloads: [NSURL: NSURL] = [:]

    public func downloadPage(url: NSURL, andThen: ((NSURL?, ErrorType?) -> ())) {
        if let fileURL = completedDownloads[url] {
            andThen(fileURL, nil)
            return
        }
        let request = webService.downloadPage(url) { [weak self] fileURL, error in
            if let fileURL = fileURL {
                self?.completedDownloads[url] = fileURL
            }
            if let error = error as? NSError where error.code == NSFileWriteFileExistsError {
                // Not a real error
                andThen(fileURL, nil)
            } else {
                andThen(fileURL, error)
            }
            self?.activeRequests[url] = nil
        }
        if let request = request {
            activeRequests[url] = request
        }
    }

    public func cancelDownload(url: NSURL) {
        if let request = activeRequests[url] {
            request.cancel()
        }
    }

    public func isDownloadInProgress(url: NSURL) -> Bool {
        return activeRequests[url] != nil
    }
}
