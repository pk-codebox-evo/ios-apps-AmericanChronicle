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
                page: Int,
                callback: ((SearchResults?, ErrorType?) -> ()),
                dataManager: SearchDataManager) -> DelayedSearch {
            return DelayedSearch(term: term, page: page, callback: callback, dataManager: dataManager)
    }

    public init() {}
}

public class DelayedSearch: NSObject {

    public let term: String
    public let page: Int
    let callback: (SearchResults?, ErrorType?) -> ()
    let dataManager: SearchDataManager
    var timer: NSTimer?

    // MARK: Init methods

    public init(term: String, page: Int, callback: ((SearchResults?, ErrorType?) -> ()), dataManager: SearchDataManager) {
        self.term = term
        self.page = page
        self.callback = callback
        self.dataManager = dataManager
        super.init()
    }

    public var isDoingWork: Bool {
        if let timer = timer where timer.valid {
            return true
        }
        return dataManager.isSearchInProgress(term, page: page)
    }

    public func start() {
        assert(timer == nil)
        timer = NSTimer(timeInterval: 0.3, target: self, selector: "timerFired:", userInfo: nil, repeats: false)
        NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSDefaultRunLoopMode)
    }
    
    public func cancel() {
        if let timer = timer where timer.valid { // Request hasn't started yet
            timer.invalidate()
            let error = NSError(domain: "", code: -999, userInfo: nil)
            callback(nil, error)
        } else { // Request has started already. Cancelling will trigger the callback.
            dataManager.cancelSearch(term, page: page)
        }
    }

    func timerFired(sender: NSTimer) {
//        dataManager.startSearch(term, page: 0)
    }
}
