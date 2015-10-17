//
//  PagePresenter.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/27/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

public protocol PagePresenterInterface: class, PageInteractorDelegate {
    var wireframe: PageWireframe? { get set }
    var view: PageViewInterface { get }
    var interactor: PageInteractorInterface { get }

    func userDidTapDone()
    func userDidTapCancel()
    func startDownload()
}

public class PagePresenter: NSObject, PagePresenterInterface {

    // MARK: Properties

    public let view: PageViewInterface
    public let interactor: PageInteractorInterface
    weak public var wireframe: PageWireframe?

    public init(view: PageViewInterface, interactor: PageInteractorInterface) {
        self.view = view
        self.interactor = interactor
        super.init()
        view.presenter = self
        interactor.delegate = self
    }

    // MARK: PagePresenterInterface conformance

    public func userDidTapDone() {
        cancelDownloadAndFinish()
    }

    public func userDidTapCancel() {
        cancelDownloadAndFinish()
    }

    public func startDownload() {
        view.showLoadingIndicator()
        interactor.startDownload()
    }

    public func download(remoteURL: NSURL, didFinishWithFileURL fileURL: NSURL?, error: NSError?) {
        if let error = error {
            view.showErrorWithTitle("Trouble Downloading PDF", message: error.localizedDescription)
        } else {
            view.pdfPage = CGPDFDocumentGetPage(CGPDFDocumentCreateWithURL(fileURL), 1)
        }
        view.hideLoadingIndicator()
    }

    // MARK: Private methods

    private func cancelDownloadAndFinish() {
        interactor.cancelDownload()
        wireframe?.userDidTapDone()
    }
}
