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

    func startOCRCoordinatesRequest()
}

@objc public protocol PageInteractorDelegate: class {
    func download(remoteURL: NSURL, didFinishWithFileURL fileURL: NSURL?, error: NSError?)
    func requestDidFinishWithOCRCoordinates(coordinates: OCRCoordinates?, error: NSError?)
}


// Responsibilities:
// - Owns the download URL.
public final class PageInteractor: NSObject, PageInteractorInterface {

    public weak var delegate: PageInteractorDelegate?

    private let dataManager: PageDataManagerInterface
    private let remoteURL: NSURL
    private let id: String
    private let date: NSDate?
    private let lccn: String?
    private let sequence: Int?
    private let edition: Int?

    public init(remoteURL: NSURL, id: String, date: NSDate?, lccn: String?, edition: Int?, sequence: Int?, dataManager: PageDataManagerInterface) {
        self.remoteURL = remoteURL
        self.id = id
        self.date = date
        self.lccn = lccn
        self.sequence = sequence
        self.edition = edition
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

    public func startOCRCoordinatesRequest() {
        dataManager.startOCRCoordinatesRequest(id) { coordinates, error in
            self.delegate?.requestDidFinishWithOCRCoordinates(coordinates, error: error)
        }
    }
}
