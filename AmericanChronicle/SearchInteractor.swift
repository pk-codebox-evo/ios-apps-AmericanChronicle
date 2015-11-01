//
//  SearchInteractor.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/6/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

// MARK: -
// MARK: SearchInteractorInterface

public protocol SearchInteractorInterface: class {
    var dataManager: SearchDataManagerInterface? { get set }
    var delegate: SearchInteractorDelegate? { get set }

    func startSearch(term: String, page: Int)
    func isSearchInProgress() -> Bool
    func cancelLastSearch()
}

// MARK: -
// MARK: SearchInteractorDelegate

public protocol SearchInteractorDelegate {
    func searchForTerm(term: String, page: Int, didFinishWithResults: SearchResults?, error: NSError?)
}

// MARK: -
// MARK: SearchInteractor

// Responsibilities:
//  * Ensures that only one request is ongoing at a time.
//  * Waits for some time before starting a new search.
//  * Guarantees that isSearchInProgress will return the correct value.
public class SearchInteractor: NSObject, SearchInteractorInterface {

    public var dataManager: SearchDataManagerInterface?
    public var delegate: SearchInteractorDelegate?

    // MARK: Private Properties

    private var delayedSearch: DelayedSearch?
    public func startSearch(term: String, page: Int) {
        // Calling cancel() on delayedSearch can sometimes trigger the completionHandler
        // synchronously, and the delegate might then call isSearchInProgress to see if
        // it can hide the progress indicator. Wait to start this chain of events until
        // the new delayedSearch has been created.
        let oldDelayedSearch = delayedSearch
        delayedSearch = DelayedSearch(term: term, page: page, dataManager: dataManager!) { (results, error) in
            self.delegate?.searchForTerm(term, page: page, didFinishWithResults: results, error: error as? NSError)
        }
        oldDelayedSearch?.cancel()
    }

    public func isSearchInProgress() -> Bool {
        return delayedSearch?.isSearchInProgress() ?? false
    }

    public func cancelLastSearch() {
        delayedSearch?.cancel()
    }
}