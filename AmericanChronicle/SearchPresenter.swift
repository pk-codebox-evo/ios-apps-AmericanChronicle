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

protocol SearchPresenterInterface: class, SearchInteractorDelegate {
    var wireframe: SearchWireframeInterface? { get set }
    var view: SearchViewInterface? { get set }
    var interactor: SearchInteractorInterface? { get set }

    func userDidTapCancel()
    func userDidTapReturn()
    func userDidTapUSStates()
    func userDidChangeSearchToTerm(term: String?)
    func userIsApproachingLastRow(term: String?, inCollection: [SearchResultsRow])
    func userDidSelectSearchResult(row: SearchResultsRow)
    func viewDidLoad()
    func userDidSaveFilteredUSStates(stateNames: [String])
    func userDidNotSaveFilteredUSStates()
}

// MARK: -
// MARK: SearchPresenter

class SearchPresenter: NSObject, SearchPresenterInterface {

    // MARK: Properties

    weak var wireframe: SearchWireframeInterface?
    weak var view: SearchViewInterface? {
        didSet {
            updateViewForKeyboardFrame(KeyboardService.sharedInstance.keyboardFrame)
        }
    }
    weak var interactor: SearchInteractorInterface?

    override init() {
        super.init()
        KeyboardService.sharedInstance.addFrameChangeHandler("\(unsafeAddressOf(self))") { [weak self] rect in
            self?.updateViewForKeyboardFrame(rect)
        }
    }

    func userDidTapCancel() {
        wireframe?.userDidTapCancel()
    }

    func userDidTapReturn() {
        view?.resignFirstResponder()
    }

    func userDidTapUSStates() {
        wireframe?.userDidTapUSStates(filteredUSStates)
    }

    func userDidChangeSearchToTerm(term: String?) {

        let nonNilTerm = term ?? ""
        if (nonNilTerm.characters.count == 0) {
            view?.setViewState(.EmptySearchField)
            interactor?.cancelLastSearch()
            return
        }

        view?.setViewState(.LoadingNewTerm)

        let parameters = SearchParameters(term: nonNilTerm, states: filteredUSStates)
        interactor?.startSearch(parameters, existingRows: [])
    }

    func userIsApproachingLastRow(term: String?, inCollection collection: [SearchResultsRow]) {
        let nonNilTerm = term ?? ""
        if (nonNilTerm.characters.count == 0) {
            return
        }
        view?.setViewState(.LoadingMoreRows)
        let parameters = SearchParameters(term: nonNilTerm, states: filteredUSStates)
        interactor?.startSearch(parameters, existingRows: collection)
    }

    func userDidSelectSearchResult(row: SearchResultsRow) {
        wireframe?.userDidSelectSearchResult(row, forTerm: view?.currentSearchTerm() ?? "")
    }

    func viewDidLoad() {
        updateViewForKeyboardFrame(KeyboardService.sharedInstance.keyboardFrame)
    }





    func search(parameters: SearchParameters, existingRows: [SearchResultsRow], didFinishWithResults results: SearchResults?, error: NSError?) {

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
                    id: result.id,
                    date: date,
                    cityState: cityStateComponents.joinWithSeparator(", "),
                    publicationTitle: publicationTitle,
                    thumbnailURL: result.thumbnailURL,
                    pdfURL: result.pdfURL,
                    lccn: result.lccn,
                    edition: result.edition,
                    sequence: result.sequence)
                allRows.append(row)
            }

            if allRows.count > 0 {
                let title = "\(results.totalItems ?? 0) matches for '\(parameters.term)'"
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

    private var filteredUSStates: [String] = []

    func userDidSaveFilteredUSStates(stateNames: [String]) {
        filteredUSStates = stateNames
    }

    func userDidNotSaveFilteredUSStates() {
        
    }

    func updateViewForKeyboardFrame(rect: CGRect?) {
        view?.setBottomContentInset(rect?.size.height ?? 0)
    }

    deinit {
        KeyboardService.sharedInstance.removeFrameChangeHandler("\(unsafeAddressOf(self))")
    }
}
