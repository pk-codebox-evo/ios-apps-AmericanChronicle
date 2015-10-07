//
//  SearchInteractor.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/6/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

public protocol SearchInteractorProtocol {
    var isDoingWork: Bool { get }
    func performSearch(term: String?, andThen callback: ((SearchResults?, ErrorType?) -> ()))
    func cancelLastSearch()
}

public class SearchInteractor: NSObject, SearchInteractorProtocol {

    let webService: ChroniclingAmericaWebServiceProtocol
    let searchFactory: DelayedSearchFactory
    var activeSearchTerm: String?
    var activeCallback: ((SearchResults?, NSError?) -> ())?
    var activeRequest: DelayedSearch?

    public init(webService: ChroniclingAmericaWebServiceProtocol = ChroniclingAmericaWebService(),
        delayedSearchFactory: DelayedSearchFactory = DelayedSearchFactory()) {
        self.webService = webService
        self.searchFactory = delayedSearchFactory
        super.init()
    }

    // MARK: SearchInteractorProtocol properties and methods

    public var isDoingWork: Bool {
        return activeRequest?.inProgress ?? false
    }

    public func performSearch(term: String?, andThen callback: ((SearchResults?, ErrorType?) -> ())) {
        let oldRequest = activeRequest
        if let term = term where term.characters.count > 0 {
            activeRequest = searchFactory.newSearchForTerm(term, callback: callback, webService: webService)
            activeRequest?.start()
        } else {
            let err = NSError(domain: "", code: -999, userInfo: nil)
            callback(nil, err)
        }
        oldRequest?.cancel()
    }

    public func cancelLastSearch() {
        activeRequest?.cancel()
    }
}
