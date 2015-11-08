//
//  DelayedSearch.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/20/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import UIKit

public protocol DelayedSearchFactoryInterface {
    func newSearchForTerm(term: String, page: Int, callback: ((SearchResults?, ErrorType?) -> ())) -> DelayedSearchInterface?
}

public class DelayedSearchFactory: DelayedSearchFactoryInterface {

    let dataManager: SearchDataManagerInterface
    public init(dataManager: SearchDataManagerInterface) {
        self.dataManager = dataManager
    }

    public func newSearchForTerm(term: String,
                page: Int,
                callback: ((SearchResults?, ErrorType?) -> ())) -> DelayedSearchInterface? {
            return DelayedSearch(term: term, page: page, dataManager: dataManager, completionHandler: callback)
    }
}

public protocol DelayedSearchInterface {
    init(term: String, page: Int, dataManager: SearchDataManagerInterface, runLoop: RunLoopInterface, completionHandler: ((SearchResults?, ErrorType?) -> ()))
    func cancel()
    func isSearchInProgress() -> Bool
}

public protocol RunLoopInterface {
    func addTimer(timer: NSTimer, forMode mode: String)
}

extension NSRunLoop: RunLoopInterface {}

public class DelayedSearch: NSObject, DelayedSearchInterface {

    private let term: String
    private let page: Int
    private let dataManager: SearchDataManagerInterface
    private let completionHandler: (SearchResults?, ErrorType?) -> ()
    private var timer: NSTimer!

    // MARK: Init methods

    public required init(
                        term: String,
                        page: Int,
                        dataManager: SearchDataManagerInterface,
                        runLoop: RunLoopInterface = NSRunLoop.currentRunLoop(),
                        completionHandler: ((SearchResults?, ErrorType?) -> ()))
    {
        self.term = term
        self.page = page
        self.dataManager = dataManager
        self.completionHandler = completionHandler

        super.init()

        timer = NSTimer(timeInterval: 0.3, target: self, selector: "timerFired:", userInfo: nil, repeats: false)
        runLoop.addTimer(timer!, forMode: NSDefaultRunLoopMode)
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
