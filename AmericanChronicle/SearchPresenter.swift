//
//  SearchPresenter.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/6/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

// MARK: -
// MARK: SearchPresenterInterface

public protocol SearchPresenterInterface: class, SearchInteractorDelegate {
    var wireframe: SearchWireframeInterface? { get set }
    var view: SearchViewInterface? { get set }
    var interactor: SearchInteractorInterface? { get set }

    func userDidTapCancel()
    func userDidChangeSearchToTerm(term: String?)
    func userIsApproachingLastRow(term: String?, inCollection: [SearchResultsRow])
    func userDidSelectSearchResult(row: SearchResultsRow)
    func viewDidLoad()
}

// MARK: -
// MARK: SearchPresenter

public class SearchPresenter: NSObject, SearchPresenterInterface {

    // MARK: Public Properties

    weak public var wireframe: SearchWireframeInterface?
    weak public var view: SearchViewInterface? {
        didSet {
            updateViewForKeyboardFrame(KeyboardObserver.sharedInstance.keyboardFrame)
        }
    }
    weak public var interactor: SearchInteractorInterface?

    override init() {
        super.init()
        KeyboardObserver.sharedInstance.addFrameChangeHandler("\(unsafeAddressOf(self))") { [weak self] rect in
            self?.updateViewForKeyboardFrame(rect)
        }
    }

    func updateViewForKeyboardFrame(rect: CGRect?) {
        view?.setBottomContentInset(rect?.size.height ?? 0)
    }

    public func userDidTapCancel() {
        wireframe?.userDidTapCancel()
    }

    public func userDidSelectSearchResult(row: SearchResultsRow) {
        wireframe?.userDidSelectSearchResult(row)
    }

    public func viewDidLoad() {
        updateViewForKeyboardFrame(KeyboardObserver.sharedInstance.keyboardFrame)
    }

    public func userDidChangeSearchToTerm(term: String?) {

        let nonNilTerm = term ?? ""
        if (nonNilTerm.characters.count == 0) {
            view?.setViewState(.EmptySearchField)
            interactor?.cancelLastSearch()
            return
        }

        view?.setViewState(.LoadingNewTerm)

        interactor?.startSearchForTerm(nonNilTerm, existingRows: [])
    }

    public func userIsApproachingLastRow(term: String?, inCollection collection: [SearchResultsRow]) {
        let nonNilTerm = term ?? ""
        if (nonNilTerm.characters.count == 0) {
            return
        }
        view?.setViewState(.LoadingMoreRows)
        interactor?.startSearchForTerm(nonNilTerm, existingRows: collection)
    }

    public func searchForTerm(term: String, existingRows: [SearchResultsRow], didFinishWithResults results: SearchResults?, error: NSError?) {

        if let results = results, items = results.items {
            var allRows = existingRows
            for result in items {
                let date = result.date
                var cityStateComponents: [String] = []

                if let city = result.city?.first {
                    cityStateComponents.append(city)
                }
                if let state = result.state?.first {
                    cityStateComponents.append(state)
                }


                let publicationTitle = result.titleNormal ?? ""
                let row = SearchResultsRow(
                    date: date,
                    cityState: cityStateComponents.joinWithSeparator(", "),
                    publicationTitle: publicationTitle,
                    thumbnailURL: result.thumbnailURL,
                    pdfURL: result.pdfURL,
                    estimatedPDFSize: result.estimatedPDFSize)
                allRows.append(row)
            }

            if allRows.count > 0 {
                let title = "\(results.totalItems ?? 0) matches for \(term)"
                view?.setViewState(.Ideal(title: title, rows: allRows))
            } else {
                view?.setViewState(.EmptyResults)
            }
        } else if let err = error {
            if err.code == -999 {
                return
            }
            if err.isDuplicateRequestError() {
                return
            }
            view?.setViewState(.Error(title: err.localizedDescription, message: err.localizedRecoverySuggestion))
        } else {
            view?.setViewState(.EmptyResults)
        }
    }

    deinit {
        KeyboardObserver.sharedInstance.removeFrameChangeHandler("\(unsafeAddressOf(self))")
    }
}
