//
//  SearchInteractor.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/6/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

struct SearchParameters: Equatable {
    let term: String
    let states: [String]
}

func ==(lhs: SearchParameters, rhs: SearchParameters) -> Bool {
    return (lhs.term == rhs.term) && (lhs.states == rhs.states)
}

// MARK: -
// MARK: SearchInteractorInterface

protocol SearchInteractorInterface: class {
    var delegate: SearchInteractorDelegate? { get set }

    func startSearch(parameters: SearchParameters, existingRows: [SearchResultsRow])
    func isSearchInProgress() -> Bool
    func cancelLastSearch()
}

// MARK: -
// MARK: SearchInteractorDelegate

protocol SearchInteractorDelegate {
    func search(parameters: SearchParameters, existingRows: [SearchResultsRow], didFinishWithResults: SearchResults?, error: NSError?)
}

// MARK: -
// MARK: SearchInteractor

// Responsibilities:
//  * Ensures that only one request is ongoing at a time.
//  * Waits for some time before starting a new search.
class SearchInteractor: NSObject, SearchInteractorInterface {

    var delegate: SearchInteractorDelegate?

    // MARK: Private Properties

    private let searchFactory: DelayedSearchFactoryInterface
    private var delayedSearch: DelayedSearchInterface?

    // MARK: Init methods

    init(searchFactory: DelayedSearchFactoryInterface) {
        self.searchFactory = searchFactory
        super.init()
    }

    func startSearch(parameters: SearchParameters, existingRows: [SearchResultsRow]) {

        if (parameters == delayedSearch?.parameters) && isSearchInProgress() {
            // There is already a search in progress for this term.
            // It's not possible to request a new page until the
            // previous page has loaded, so fail.
            let error = NSError(code: .DuplicateRequest, message: "Tried to start a search that is already ongoing. Taking no action.")
            self.delegate?.search(parameters, existingRows: existingRows, didFinishWithResults: nil, error: error)
            return
        }

        if existingRows.count % 20 != 0 {
            // The last search returned partial results, so we can
            // assume that there are no more results to fetch. 
            let error = NSError(code: .InvalidParameter, message: "Existing row count isn't evenly divisible by 20, there are no more rows.")
            self.delegate?.search(parameters, existingRows: existingRows, didFinishWithResults: nil, error: error)
            return
        }

        let page = (existingRows.count / 20) + 1

        // Calling cancel() on delayedSearch can sometimes trigger the completionHandler
        // synchronously, and the delegate might then call isSearchInProgress to see if
        // it can hide the progress indicator. Wait to start this chain of events until
        // the new delayedSearch has been created.
        let oldDelayedSearch = delayedSearch

        delayedSearch = searchFactory.newSearch(parameters, page: page) { (results, error) in
            self.delegate?.search(parameters, existingRows: existingRows, didFinishWithResults: results, error: error as? NSError)
        }
        oldDelayedSearch?.cancel()
    }

    func isSearchInProgress() -> Bool {
        return delayedSearch?.isSearchInProgress() ?? false
    }

    func cancelLastSearch() {
        delayedSearch?.cancel()
    }
}