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
    func userDidTapShare(image: UIImage)

    func startDownload()
}

public class PagePresenter: NSObject, PagePresenterInterface {

    // MARK: Properties

    public let view: PageViewInterface
    public let interactor: PageInteractorInterface
    public let searchTerm: String?
    weak public var wireframe: PageWireframe?

    public init(view: PageViewInterface, interactor: PageInteractorInterface, searchTerm: String?) {
        self.view = view
        self.interactor = interactor
        self.searchTerm = searchTerm
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

    public func userDidTapShare(image: UIImage) {
        wireframe?.userDidTapShare(image)
    }

    public func startDownload() {
        view.showLoadingIndicator()
        interactor.startDownload()
        interactor.startOCRCoordinatesRequest()
    }

    public func download(remoteURL: NSURL, didFinishWithFileURL fileURL: NSURL?, error: NSError?) {
        if let error = error {
            view.showErrorWithTitle("Trouble Downloading PDF", message: error.localizedDescription)
        } else {
            view.pdfPage = CGPDFDocumentGetPage(CGPDFDocumentCreateWithURL(fileURL), 1)
        }
        view.hideLoadingIndicator()
    }

    public func requestDidFinishWithOCRCoordinates(coordinates: OCRCoordinates?, error: NSError?) {
        guard let searchTerm = searchTerm else { return }
        var terms = [searchTerm]
        terms.appendContentsOf(searchTerm.componentsSeparatedByString(" "))

        var matchingCoordinates: [String: [CGRect]] = [:]
        if let wordsWithCoordinates = coordinates?.wordCoordinates?.keys {
            for word in wordsWithCoordinates {
                for term in terms {
                    if word.lowercaseString == term.lowercaseString {
                        matchingCoordinates[word] = coordinates?.wordCoordinates?[word]
                        continue
                    }
                }
            }
        }

        coordinates?.wordCoordinates = matchingCoordinates
        view.highlights = coordinates
    }

    // MARK: Private methods

    private func cancelDownloadAndFinish() {
        interactor.cancelDownload()
        wireframe?.userDidTapDone()
    }
}
