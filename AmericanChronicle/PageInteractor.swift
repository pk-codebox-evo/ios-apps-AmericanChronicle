//
//  PageInteractor.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/21/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

@objc public protocol PageInteractorInterface {

    var delegate: PageInteractorDelegate? { get set }

    func startDownload()
    func cancelDownload()
    func isDownloadInProgress() -> Bool
}

@objc public protocol PageInteractorDelegate: class {
    func download(remoteURL: NSURL, didFinishWithFileURL fileURL: NSURL?, error: NSError?)
}


// Responsibilities:
// - Owns the download URL.
public final class PageInteractor: NSObject, PageInteractorInterface {

    public weak var delegate: PageInteractorDelegate?

    private let dataManager: PageDataManagerInterface
    private let remoteURL: NSURL

    public init(remoteURL: NSURL, dataManager: PageDataManagerInterface) {
        self.remoteURL = remoteURL
        self.dataManager = dataManager
        super.init()
    }

    public func startDownload() {
        dataManager.downloadPage(remoteURL, completionHandler: { remoteURL, fileURL, error in
            self.delegate?.download(self.remoteURL, didFinishWithFileURL: fileURL, error: error)
        })
    }

    public func cancelDownload() {
        dataManager.cancelDownload(remoteURL)
    }

    public func isDownloadInProgress() -> Bool {
        return dataManager.isDownloadInProgress(remoteURL)
    }
}
