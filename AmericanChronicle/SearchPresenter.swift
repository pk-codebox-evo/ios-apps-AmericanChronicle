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
    func userDidSelectSearchResult(row: SearchResultsRow)
}

// MARK: -
// MARK: SearchPresenter

public class SearchPresenter: NSObject, SearchPresenterInterface {

    // MARK: Public Properties

    weak public var view: SearchViewInterface?
    weak public var interactor: SearchInteractorInterface?
    weak public var wireframe: SearchWireframeInterface?

    public func userDidTapCancel() {
        wireframe?.userDidTapCancel()
    }

    public func userDidSelectSearchResult(row: SearchResultsRow) {
        wireframe?.userDidSelectSearchResult(row)
    }

    public func userDidChangeSearchToTerm(term: String?) {

        let nonNilTerm = term ?? ""
        if (nonNilTerm.characters.count == 0) {
            view?.showSearchResults([], title: "")
            interactor?.cancelLastSearch()
            return
        }

        view?.showLoadingIndicator()

        interactor?.startSearch(nonNilTerm, page: 1)
    }

    public func searchForTerm(term: String, page: Int, didFinishWithResults results: SearchResults?, error: NSError?) {

        if let inProgress = self.interactor?.isSearchInProgress() where inProgress == false {
            view?.hideLoadingIndicator()
        }

        if let results = results, items = results.items {
            var rows = [SearchResultsRow]()
            for result in items {
                let date = result.date
                let city = result.city?.first ?? ""
                let state = result.state?.first ?? ""
                let cityState = "\(city), \(state)"
                let publicationTitle = result.titleNormal ?? ""
                let row = SearchResultsRow(
                    date: date,
                    cityState: cityState,
                    publicationTitle: publicationTitle,
                    thumbnailURL: result.thumbnailURL,
                    pdfURL: result.pdfURL,
                    estimatedPDFSize: result.estimatedPDFSize)
                rows.append(row)
            }

            if rows.count > 0 {
                let title = "\(results.totalItems ?? 0) matches for \(term)"
                view?.showSearchResults(rows, title: title)
            } else {
                view?.showEmptyResults()
            }
        } else if let err = error {
            if err.code == -999 {
                return
            }
            view?.showErrorMessage(err.localizedDescription, message: err.localizedRecoverySuggestion)
        } else {
            view?.showEmptyResults()
        }
    }
}
