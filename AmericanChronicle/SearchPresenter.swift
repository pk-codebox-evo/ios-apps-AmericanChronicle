//
//  SearchPresenter.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/6/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

// MARK: -
// MARK: SearchPresenterProtocol

public protocol SearchPresenterProtocol: class {
    var cancelCallback: ((Void) -> ())? { get set }
    var showPageCallback: ((SearchResultsRow) -> ())? { get set }
    func setUpView(searchView: SearchView)
}

// MARK: -
// MARK: SearchPresenter class

public class SearchPresenter: NSObject, SearchPresenterProtocol {

    public let interactor: SearchInteractorProtocol
    public let searchDelay: NSTimeInterval
    public var cancelCallback: ((Void) -> ())?
    public var showPageCallback: ((SearchResultsRow) -> ())?

    public func setUpView(searchView: SearchView) {

        searchView.searchResultSelectedCallback = { row in
            self.showPageCallback?(row)
        }

        searchView.cancelCallback = { [weak self] in
            self?.cancelCallback?()
        }

        searchView.searchTermDidChangeCallback = { [weak self] term in

            let nonNilTerm = term ?? ""

            if (nonNilTerm.characters.count == 0) {
                searchView.hideLoadingIndicator()
                self?.interactor.cancelLastSearch()
                searchView.showSearchResults([], title: "")
                return
            }

            searchView.showLoadingIndicator()

            self?.interactor.performSearch(nonNilTerm, andThen: { results, error in

                if let welf = self where !welf.interactor.isDoingWork {
                    searchView.hideLoadingIndicator()
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
                        let title = "\(results.totalItems ?? 0) matches for \(nonNilTerm)"
                        searchView.showSearchResults(rows, title: title)
                    } else {
                        searchView.showEmptyResults()
                    }
                } else if let err = error as? NSError {
                    searchView.showErrorMessage(err.localizedDescription, message: err.localizedRecoverySuggestion)
                } else {
                    searchView.showEmptyResults()
                }
            })
        }
    }

    public init(interactor: SearchInteractorProtocol = SearchInteractor(), searchDelay: NSTimeInterval = 0.3) {
        self.interactor = interactor
        self.searchDelay = searchDelay
        super.init()
    }
}
