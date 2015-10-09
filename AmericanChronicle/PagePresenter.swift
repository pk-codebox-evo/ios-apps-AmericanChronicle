//
//  PagePresenter.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/27/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

public protocol PagePresenterProtocol: class {
    var shareCallback: (() -> Void)? { get set }
    var doneCallback: (() -> Void)? { get set }
    func setUpView(view: PageView, url: NSURL, estimatedSize: Int)
}

public class PagePresenter: NSObject, PagePresenterProtocol {

    public var shareCallback: (() -> Void)?
    public var doneCallback: (() -> Void)?
    public let interactor: PageInteractorProtocol
    public init(interactor: PageInteractorProtocol = PageInteractor()) {
        self.interactor = interactor
        super.init()
    }

    public func setUpView(view: PageView, url: NSURL, estimatedSize: Int) {
        view.shareCallback = { [weak self] in
            self?.shareCallback?()
        }

        view.doneCallback = { [weak self] in
            self?.cancelDownloadAndFinish(url)
        }

        view.cancelCallback = { [weak self] in
            self?.cancelDownloadAndFinish(url)
        }

        view.showLoadingIndicator()
        interactor.downloadPage(url, totalBytesRead: { totalRead in
            let progress = Float(totalRead)/Float(estimatedSize)
            view.setDownloadProgress(progress)
        }, completion: { url, error in
            if let error = error as? NSError {
                view.showErrorWithTitle("Trouble Downloading PDF", message: error.localizedDescription)
            } else {
                view.pdfPage = CGPDFDocumentGetPage(CGPDFDocumentCreateWithURL(url), 1)
            }
            view.hideLoadingIndicator()
        } )
    }

    private func cancelDownloadAndFinish(url: NSURL) {
        interactor.cancelDownload(url)
        doneCallback?()
    }
}
