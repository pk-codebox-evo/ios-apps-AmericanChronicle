//
//  DelayedSearch.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/20/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import UIKit

protocol DelayedSearchFactoryInterface {
    func newSearch(parameters: SearchParameters, page: Int, callback: ((SearchResults?, ErrorType?) -> ())) -> DelayedSearchInterface?
}

class DelayedSearchFactory: DelayedSearchFactoryInterface {

    let dataManager: SearchDataManagerInterface
    init(dataManager: SearchDataManagerInterface) {
        self.dataManager = dataManager
    }

    func newSearch(parameters: SearchParameters, page: Int, callback: ((SearchResults?, ErrorType?) -> ())) -> DelayedSearchInterface? {
        return DelayedSearch(parameters: parameters, page: page, dataManager: dataManager, completionHandler: callback)
    }
}

protocol DelayedSearchInterface {
    var parameters: SearchParameters { get }
    init(parameters: SearchParameters, page: Int, dataManager: SearchDataManagerInterface, runLoop: RunLoopInterface, completionHandler: ((SearchResults?, ErrorType?) -> ()))
    func cancel()
    func isSearchInProgress() -> Bool
}

protocol RunLoopInterface {
    func addTimer(timer: NSTimer, forMode mode: String)
}

extension NSRunLoop: RunLoopInterface {}

class DelayedSearch: NSObject, DelayedSearchInterface {

    let parameters: SearchParameters
    private let page: Int
    private let dataManager: SearchDataManagerInterface
    private let completionHandler: (SearchResults?, ErrorType?) -> ()
    private var timer: NSTimer!

    // MARK: Init methods

    required init(
        parameters: SearchParameters,
        page: Int,
        dataManager: SearchDataManagerInterface,
        runLoop: RunLoopInterface = NSRunLoop.currentRunLoop(),
        completionHandler: ((SearchResults?, ErrorType?) -> ()))
    {
        self.parameters = parameters
        self.page = page
        self.dataManager = dataManager
        self.completionHandler = completionHandler

        super.init()

        timer = NSTimer(timeInterval: 0.3, target: self, selector: "timerFired:", userInfo: nil, repeats: false)
        runLoop.addTimer(timer!, forMode: NSDefaultRunLoopMode)
    }
    
    func cancel() {
        if timer.valid { // Request hasn't started yet
            timer.invalidate()
            let error = NSError(domain: "", code: -999, userInfo: nil)
            completionHandler(nil, error)
        } else { // Request has started already.
            dataManager.cancelSearch(parameters, page: page) // Cancelling will trigger the completionHandler.
        }
    }

    /// This will return the correct value by the time the completion handler is called.
    func isSearchInProgress() -> Bool {
        if timer.valid {
            return true
        }
        return dataManager.isSearchInProgress(parameters, page: page)
    }

    func timerFired(sender: NSTimer) {
        dataManager.startSearch(parameters, page: page, completionHandler: completionHandler)
    }
}
