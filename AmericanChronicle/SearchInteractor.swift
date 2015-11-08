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
public class SearchInteractor: NSObject, SearchInteractorInterface {

    public var delegate: SearchInteractorDelegate?

    // MARK: Private Properties

    private let searchFactory: DelayedSearchFactoryInterface
    private var delayedSearch: DelayedSearchInterface?

    // MARK: Init methods

    public init(searchFactory: DelayedSearchFactoryInterface) {
        self.searchFactory = searchFactory
        super.init()
    }

    public func startSearch(term: String, page: Int) {
        // Calling cancel() on delayedSearch can sometimes trigger the completionHandler
        // synchronously, and the delegate might then call isSearchInProgress to see if
        // it can hide the progress indicator. Wait to start this chain of events until
        // the new delayedSearch has been created.
        let oldDelayedSearch = delayedSearch

        delayedSearch = searchFactory.newSearchForTerm(term, page: page) { (results, error) in
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