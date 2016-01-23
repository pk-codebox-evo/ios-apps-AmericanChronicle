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

protocol SearchPresenterInterface: class, SearchViewDelegate, SearchInteractorDelegate {
    var wireframe: SearchWireframeInterface? { get set }
    var view: SearchViewInterface? { get set }
    var interactor: SearchInteractorInterface? { get set }

    func userDidSaveFilteredUSStates(stateNames: [String])
    func userDidSaveDate(date: NSDate)
}

// MARK: -
// MARK: SearchPresenter

class SearchPresenter: NSObject, SearchPresenterInterface {

    private enum DateType {
        case Earliest
        case Latest
        case None
    }

    // MARK: Properties

    weak var wireframe: SearchWireframeInterface?
    weak var view: SearchViewInterface? {
        didSet {
            updateViewForKeyboardFrame(KeyboardService.sharedInstance.keyboardFrame)
            view?.earliestDate = dateFormatter.stringFromDate(earliestDate)
            view?.latestDate = dateFormatter.stringFromDate(latestDate)
        }
    }
    weak var interactor: SearchInteractorInterface?

    var term: String?
    var states: [String] = []
    var earliestDate: NSDate = SearchConstants.earliestPossibleDate()
    var latestDate: NSDate = SearchConstants.latestPossibleDate()

    private let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter
    }()
    private var typeBeingEdited = DateType.None

    // MARK: Init methods

    override init() {
        super.init()
        KeyboardService.sharedInstance.addFrameChangeHandler("\(unsafeAddressOf(self))") { [weak self] rect in
            self?.updateViewForKeyboardFrame(rect)
        }
    }

    // MARK: SearchPresenterInterface methods

    func userDidSaveFilteredUSStates(stateNames: [String]) {
        states = stateNames.sort()
        let str: String
        if states.count == 0 {
            str = "All US states"
        } else if states.count <= 3 {
            str = states.joinWithSeparator(", ")
        } else {
            str = "\(states[0..<3].joinWithSeparator(", ")) (and \(states.count - 3) more)"
        }
        view?.USStates = str
        searchIfReady()
    }

    func userDidSaveDate(date: NSDate) {
        switch typeBeingEdited {
        case .Earliest:
            earliestDate = date
            view?.earliestDate = dateFormatter.stringFromDate(date)
            searchIfReady()
        case .Latest:
            latestDate = date
            view?.latestDate = dateFormatter.stringFromDate(date)
            searchIfReady()
        case .None:
            break
        }
    }

    // MARK: SearchViewDelegate methods

    func userDidTapCancel() {
        wireframe?.userDidTapCancel()
    }

    func userDidTapReturn() {
        view?.resignFirstResponder()
    }

    func userDidTapUSStates() {
        wireframe?.showUSStatesPicker(states)
    }

    func userDidTapEarliestDateButton() {
        typeBeingEdited = .Earliest
        wireframe?.userDidTapDate(earliestDate)
    }

    func userDidTapLatestDateButton() {
        typeBeingEdited = .Latest
        wireframe?.userDidTapDate(latestDate)
    }

    func userDidChangeSearchToTerm(term: String?) {
        self.term = term
        if (term?.characters.count == 0) {
            view?.setViewState(.EmptySearchField)
            interactor?.cancelLastSearch()
            return
        }
        searchIfReady()
    }

    func userIsApproachingLastRow(term: String?, inCollection collection: [SearchResultsRow]) {
        guard (term?.characters.count > 0) else { return }
        searchIfReady(.LoadingMoreRows)
    }

    func userDidSelectSearchResult(row: SearchResultsRow) {
        wireframe?.userDidSelectSearchResult(row, forTerm: view?.searchTerm ?? "")
    }

    func viewDidLoad() {
        updateViewForKeyboardFrame(KeyboardService.sharedInstance.keyboardFrame)
    }

    // MARK: SearchInteractorDelegate methods

    func search(parameters: SearchParameters, didFinishWithResults results: SearchResults?, error: NSError?) {
        if let results = results, items = results.items {
            let rows = rowsForSearchResultItems(items)
            if rows.count > 0 {
                let title = "\(results.totalItems ?? 0) matches"
                view?.setViewState(.Ideal(title: title, rows: rows))
            } else {
                view?.setViewState(.EmptyResults)
            }
        } else if let err = error {
            guard !err.isCancelledRequestError() else { return }
            guard !err.isDuplicateRequestError() else { return }
            guard !err.isAllItemsLoadedError() else { return }
            view?.setViewState(.Error(title: err.localizedDescription, message: err.localizedRecoverySuggestion))
        } else {
            view?.setViewState(.EmptyResults)
        }
    }

    // MARK: Private methods

    private func updateViewForKeyboardFrame(rect: CGRect?) {
        view?.setBottomContentInset(rect?.size.height ?? 0)
    }

    private func rowsForSearchResultItems(items: [SearchResult]) -> [SearchResultsRow] {
        var rows: [SearchResultsRow] = []

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
                publicationTitle: publicationTitle.capitalizedString.stringByReplacingOccurrencesOfString(".", withString: ""),
                thumbnailURL: result.thumbnailURL,
                pdfURL: result.pdfURL,
                lccn: result.lccn,
                edition: result.edition,
                sequence: result.sequence)
            rows.append(row)
        }

        return rows
    }

    private func searchIfReady(loadingViewState: ViewState = .LoadingNewParamaters) {
        if let term = term {
            view?.setViewState(loadingViewState)
            let params = SearchParameters(term: term, states: states, earliestDate: earliestDate, latestDate: latestDate)
            interactor?.fetchNextPageOfResults(params)
        }
    }

    // MARK: Deinit method

    deinit {
        KeyboardService.sharedInstance.removeFrameChangeHandler("\(unsafeAddressOf(self))")
    }
}
