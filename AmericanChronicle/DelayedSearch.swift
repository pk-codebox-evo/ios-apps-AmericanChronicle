//
//  DelayedSearch.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/20/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import UIKit

public class DelayedSearchFactory {
    public func newSearchForTerm(term: String,
            callback: ((SearchResults?, ErrorType?) -> ()),
            webService: ChroniclingAmericaWebServiceProtocol) -> DelayedSearch {
            return DelayedSearch(term: term, callback: callback, webService: webService)
    }

    public init() {
        
    }
}

public class DelayedSearch: NSObject {

    public let term: String
    let callback: (SearchResults?, ErrorType?) -> ()
    let webService: ChroniclingAmericaWebServiceProtocol

    var timer: NSTimer?

    public var inProgress: Bool {
        if let timer = timer where timer.valid {
            return true
        }
        if webService.isPerformingSearch() {
            return true
        }

        return false
    }

    public init(term: String, callback: ((SearchResults?, ErrorType?) -> ()), webService: ChroniclingAmericaWebServiceProtocol) {
        self.term = term
        self.callback = callback
        self.webService = webService
        super.init()
    }

    public func start() {
        assert(timer == nil)
        timer = NSTimer(timeInterval: 0.3, target: self, selector: "timerFired:", userInfo: nil, repeats: false)
        NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSDefaultRunLoopMode)
    }

    func timerFired(sender: NSTimer) {
        webService.performSearch(term, page: 0, andThen: callback)
    }

    public func cancel() {
        if let timer = timer where timer.valid { // Request hasn't started yet
            timer.invalidate()
            let error = NSError(domain: "", code: -999, userInfo: nil)
            callback(nil, error)
        } else { // Request has started already. Cancelling will trigger the callback.
            webService.cancelLastSearch()
        }
    }
}
