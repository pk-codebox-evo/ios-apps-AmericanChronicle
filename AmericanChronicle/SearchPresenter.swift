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
    var showPageCallback: ((SearchResult) -> ())? { get set }
    func setUpView(searchView: SearchView)
}

// MARK: -
// MARK: SearchPresenter class

public class SearchPresenter: NSObject, SearchPresenterProtocol {

    public let interactor: SearchInteractorProtocol
    public let searchDelay: NSTimeInterval
    public var cancelCallback: ((Void) -> ())?
    public var showPageCallback: ((SearchResult) -> ())?

    public func setUpView(searchView: SearchView) {

        searchView.searchResultSelectedCallback = { row in

        }

        searchView.cancelCallback = { [weak self] in
            self?.cancelCallback?()
        }

        searchView.searchTermDidChangeCallback = { [weak self] term in

            let nonNilTerm = term ?? ""
            print("[RP] '\(nonNilTerm)' - search term changed")

            if (nonNilTerm.characters.count == 0) {
                print("[RP] '\(nonNilTerm)' - search term was empty, cleaning up and returning.")
                searchView.hideLoadingIndicator()
                self?.interactor.cancelLastSearch()
                searchView.showSearchResults([], title: "")
                return
            }

            searchView.showLoadingIndicator()

            self?.interactor.performSearch(nonNilTerm, andThen: { results, error in

                var isACancelledRequest = false
                if let error = error as? NSError {
                    isACancelledRequest = error.code == -999
                }

                if isACancelledRequest {
                    print("[RP] '\(nonNilTerm)' - the request was cancelled")
                } else {
                    print("[RP] '\(nonNilTerm)' - the request returned on its own")
                }

                if let welf = self where !welf.interactor.isDoingWork {
                    print("[RP] '\(nonNilTerm)' - the interactor has stopped doing work, hiding loading indicator")
                    searchView.hideLoadingIndicator()
                } else {
                    print("[RP] '\(nonNilTerm)' - the interactor still has work ongoing, not hiding loading indicator")
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
                            matchingText: "",
                            publicationTitle: publicationTitle,
                            moreMatchesCount: "3",
                            imageName: "")
                        rows.append(row)
                    }
                    print("[RP] '\(nonNilTerm)' - \(rows.count) items returned")
                    if rows.count > 0 {
                        let title = "\(results.totalItems ?? 0) matches for \(nonNilTerm)"
                        searchView.showSearchResults(rows, title: title)
                    } else {
                        searchView.showEmptyResults()
                    }
                } else if let err = error as? NSError {
                    print("[RP] '\(nonNilTerm)' - no items returned")
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
