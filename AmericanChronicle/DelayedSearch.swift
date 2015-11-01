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
            return DelayedSearch(term: term, page: page, dataManager: dataManager, completionHandler: callback)
    }

    public init() {}
}

public class DelayedSearch: NSObject {

    private let term: String
    private let page: Int
    private let dataManager: SearchDataManagerInterface
    private let completionHandler: (SearchResults?, ErrorType?) -> ()
    private var timer: NSTimer!

    // MARK: Init methods

    public init(term: String, page: Int, dataManager: SearchDataManagerInterface, completionHandler: ((SearchResults?, ErrorType?) -> ())) {
        self.term = term
        self.page = page
        self.dataManager = dataManager
        self.completionHandler = completionHandler

        super.init()

        timer = NSTimer(timeInterval: 0.3, target: self, selector: "timerFired:", userInfo: nil, repeats: false)
        NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSDefaultRunLoopMode)
    }
    
    public func cancel() {
        if timer.valid { // Request hasn't started yet
            timer.invalidate()
            let error = NSError(domain: "", code: -999, userInfo: nil)
            completionHandler(nil, error)
        } else { // Request has started already.
            dataManager.cancelSearch(term, page: page) // Cancelling will trigger the completionHandler.
        }
    }

    /// This will return the correct value by the time the completion handler is called.
    public func isSearchInProgress() -> Bool {
        if timer.valid {
            return true
        }
        return dataManager.isSearchInProgress(term, page: page)
    }

    func timerFired(sender: NSTimer) {
        dataManager.startSearch(term, page: page, completionHandler: completionHandler)
    }
}
