//
//  PageService.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 10/12/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import Alamofire

public protocol PageServiceInterface {
    func downloadPage(remoteURL: NSURL, contextID: String, completionHandler: (NSURL?, ErrorType?) -> Void)
    func cancelDownload(remoteURL: NSURL, contextID: String)
    func isDownloadInProgress(remoteURL: NSURL) -> Bool
}

typealias ContextID = String

public struct ActivePageDownload {
    let request: RequestProtocol
    var requesters: [ContextID: PageDownloadRequester]

}

public struct PageDownloadRequester {
    let contextID: ContextID
    let completionHandler: (NSURL?, ErrorType?) -> Void
}

/// Doesn't allow more than one instance of any download, but keeps track of the completion blocks
/// when there are duplicates.
public class PageService: NSObject, PageServiceInterface {

    // MARK: Properties

    public let group = dispatch_group_create()
    var activeDownloads: [NSURL: ActivePageDownload] = [:]
    private let manager: ManagerProtocol
    private let queue = dispatch_queue_create("com.ryanipete.AmericanChronicle.PageService", DISPATCH_QUEUE_SERIAL)

    private func finishRequestWithRemoteURL(remoteURL: NSURL, fileURL: NSURL?, error: NSError?) {
        dispatch_group_async(group, queue) {
            if let activeDownload = self.activeDownloads[remoteURL] {
                dispatch_async(dispatch_get_main_queue()) {
                    for (_, requester) in activeDownload.requesters {
                        requester.completionHandler(fileURL, nil)
                    }
                    self.activeDownloads[remoteURL] = nil
                }
            }
        }
    }

    // MARK: Init methods

    public init(manager: ManagerProtocol = Manager()) {
        self.manager = manager
        super.init()
    }

    // MARK: PageServiceInterface methods



    public func downloadPage(remoteURL: NSURL, contextID: String, completionHandler: (NSURL?, ErrorType?) -> Void) {
        // Note: Resumes are not currently supported by chroniclingamerica.loc.gov.
        // Note: Estimated filesize isn't currently supported by chroniclingamerica.loc.gov

        var fileURL: NSURL?
        let destination: (NSURL, NSHTTPURLResponse) -> (NSURL) = { (temporaryURL, response) in
            let documentsDirectoryURL = NSFileManager.defaultDocumentDirectoryURL
            let remotePath = remoteURL.path ?? ""
            fileURL = documentsDirectoryURL?.URLByAppendingPathComponent(remotePath).URLByStandardizingPath
            do {
                if let fileDirectoryURL = fileURL?.URLByDeletingLastPathComponent {
                    try NSFileManager.defaultManager().createDirectoryAtURL(fileDirectoryURL, withIntermediateDirectories: true, attributes: nil)
                }
            } catch let error {
                print("ERROR: \(error)")
            }

            return fileURL ?? temporaryURL
        }
        dispatch_group_async(group, queue) {
            if var activeDownload = self.activeDownloads[remoteURL] {
                if activeDownload.requesters[contextID] != nil {
                    dispatch_async(dispatch_get_main_queue()) {
                        completionHandler(nil, NSError(code: .DuplicateRequest, message: "Tried to send a duplicate request."))
                    }
                } else {
                    activeDownload.requesters[contextID] = PageDownloadRequester(contextID: contextID, completionHandler: completionHandler)
                }
            } else {
                let requester = PageDownloadRequester(contextID: contextID, completionHandler: completionHandler)
                let request = self.manager.download(.GET, URLString: remoteURL.absoluteString, parameters: nil, destination: destination)?
                    .response { [weak self] request, response, data, error in
                    if let error = error as? NSError where error.code == NSFileWriteFileExistsError {
                        // Not a real error, the file was found on disk.
                        self?.finishRequestWithRemoteURL(remoteURL, fileURL: fileURL, error: nil)
                    } else {
                        self?.finishRequestWithRemoteURL(remoteURL, fileURL: fileURL, error: error as? NSError)
                    }
                }
                if let request = request {
                    self.activeDownloads[remoteURL] = ActivePageDownload(request: request, requesters: [contextID: requester])
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        completionHandler(nil, NSError(code: .InvalidParameter, message: "Couldn't create the request."))
                    }
                }
            }
        }
    }

    public func isDownloadInProgress(remoteURL: NSURL) -> Bool {
        var isInProgress = false
        dispatch_sync(queue) {
            isInProgress = self.activeDownloads[remoteURL] != nil
        }
        return isInProgress
    }

    public func cancelDownload(remoteURL: NSURL, contextID: String) {
        dispatch_group_async(group, queue) {
            var activeDownload = self.activeDownloads[remoteURL]
            let requester = activeDownload?.requesters[contextID]
            if let count = activeDownload?.requesters.count where count == 0 {
                activeDownload?.request.cancel()
            } else {
                requester?.completionHandler(nil, NSError(domain: "", code: -999, userInfo: nil))
                activeDownload?.requesters.removeValueForKey(contextID)
                self.activeDownloads[remoteURL] = activeDownload
            }
        }
    }

}
