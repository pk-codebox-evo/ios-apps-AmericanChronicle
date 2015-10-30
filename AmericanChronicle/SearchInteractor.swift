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
//  * Waits for some time before starting a new search. (Incomplete)
public class SearchInteractor: NSObject, SearchInteractorInterface {

    public var dataManager: SearchDataManagerInterface?
    public var delegate: SearchInteractorDelegate?

    // MARK: Private Properties

    private var activeSearchTerm: String?
    private var activeSearchPage: Int?

    public func startSearch(term: String, page: Int) {

        cancelLastSearch()

        activeSearchTerm = nil
        activeSearchPage = nil

        // TODO: Add delay here.

        activeSearchTerm = term
        activeSearchPage = page
        dataManager?.startSearch(term, page: page, completionHandler: { [weak self] results, error in
            self?.delegate?.searchForTerm(term, page: page, didFinishWithResults: results, error: error)
        })
    }

    public func isSearchInProgress() -> Bool {
        if let term = activeSearchTerm, page = activeSearchPage {
            return dataManager?.isSearchInProgress(term, page: page) ?? false
        }
        return false
    }

    public func cancelLastSearch() {
        if let term = activeSearchTerm, page = activeSearchPage {
            dataManager?.cancelSearch(term, page: page)
        }
    }
}