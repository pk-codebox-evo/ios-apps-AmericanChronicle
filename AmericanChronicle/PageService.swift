import Alamofire

protocol PageServiceInterface {
    func downloadPage(remoteURL: NSURL,
                      contextID: String,
                      completionHandler: (NSURL?, ErrorType?) -> Void)
    func cancelDownload(remoteURL: NSURL, contextID: String)
    func isDownloadInProgress(remoteURL: NSURL) -> Bool
}

typealias ContextID = String

struct ActivePageDownload {
    let request: RequestProtocol
    var requesters: [ContextID: PageDownloadRequester]

}

struct PageDownloadRequester {
    let contextID: ContextID
    let completionHandler: (NSURL?, ErrorType?) -> Void
}

/// Doesn't allow more than one instance of any download, but keeps track of the completion blocks
/// when there are duplicates.
final class PageService: PageServiceInterface {

    // MARK: Properties

    let group = dispatch_group_create()
    var activeDownloads: [NSURL: ActivePageDownload] = [:]
    private let manager: ManagerProtocol
    private let queue = dispatch_queue_create("com.ryanipete.AmericanChronicle.PageService",
                                              DISPATCH_QUEUE_SERIAL)

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

    init(manager: ManagerProtocol = Manager()) {
        self.manager = manager
    }

    // MARK: PageServiceInterface methods

    func downloadPage(remoteURL: NSURL,
                      contextID: String,
                      completionHandler: (NSURL?, ErrorType?) -> Void) {
        // Note: Resumes are not currently supported by chroniclingamerica.loc.gov.
        // Note: Estimated filesize isn't currently supported by chroniclingamerica.loc.gov

        var fileURL: NSURL?
        let destination: (NSURL, NSHTTPURLResponse) -> (NSURL) = { (temporaryURL, response) in
            let documentsDirectoryURL = NSFileManager.defaultDocumentDirectoryURL
            let remotePath = remoteURL.path ?? ""
            fileURL = documentsDirectoryURL?.URLByAppendingPathComponent(remotePath)
                        .URLByStandardizingPath
            do {
                if let fileDirectoryURL = fileURL?.URLByDeletingLastPathComponent {
                    let manager = NSFileManager.defaultManager()
                    try manager.createDirectoryAtURL(fileDirectoryURL,
                                                     withIntermediateDirectories: true,
                                                     attributes: nil)
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
                        let error = NSError(code: .DuplicateRequest,
                                            message: "Tried to send a duplicate request.")
                        completionHandler(nil, error)
                    }
                } else {
                    let requester = PageDownloadRequester(contextID: contextID,
                                                          completionHandler: completionHandler)
                    activeDownload.requesters[contextID] = requester
                }
            } else {
                let requester = PageDownloadRequester(contextID: contextID,
                                                      completionHandler: completionHandler)
                let request = self.manager
                    .download(.GET,
                        URLString: remoteURL.absoluteString,
                        parameters: nil,
                        destination: destination)?
                    .response(queue: nil) { [weak self] request, response, data, error in
                    if let error = error where error.code == NSFileWriteFileExistsError {
                        // Not a real error, the file was found on disk.
                        self?.finishRequestWithRemoteURL(remoteURL,
                                                         fileURL: fileURL,
                                                         error: nil)
                    } else {
                        self?.finishRequestWithRemoteURL(remoteURL,
                                                         fileURL: fileURL,
                                                         error: error)
                    }
                }
                if let request = request {
                    let download = ActivePageDownload(request: request,
                                                      requesters: [contextID: requester])
                    self.activeDownloads[remoteURL] = download
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        let error = NSError(code: .InvalidParameter,
                                            message: "Couldn't create the request.")
                        completionHandler(nil, error)
                    }
                }
            }
        }
    }

    func isDownloadInProgress(remoteURL: NSURL) -> Bool {
        var isInProgress = false
        dispatch_sync(queue) {
            isInProgress = self.activeDownloads[remoteURL] != nil
        }
        return isInProgress
    }

    func cancelDownload(remoteURL: NSURL, contextID: String) {
        dispatch_group_async(group, queue) {
            var activeDownload = self.activeDownloads[remoteURL]
            let requester = activeDownload?.requesters[contextID]
            if let requesters = activeDownload?.requesters where requesters.isEmpty {
                activeDownload?.request.cancel()
            } else {
                requester?.completionHandler(nil, NSError(domain: "", code: -999, userInfo: nil))
                activeDownload?.requesters.removeValueForKey(contextID)
                self.activeDownloads[remoteURL] = activeDownload
            }
        }
    }

}
