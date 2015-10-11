//
//  FakeChroniclingAmericaWebService.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/12/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import AmericanChronicle

class FakeChroniclingAmericaWebService: ChroniclingAmericaWebServiceProtocol {

    var performSearch_called = false
    var performSearch_called_withTerm: String?
    func performSearch(term: String, page: Int, andThen: ((SearchResults?, ErrorType?) -> ())?) {
        performSearch_called = true
        performSearch_called_withTerm = term
        andThen?(nil, nil)
    }

    var cancelLastSearch_wasCalled = false
    func cancelLastSearch() {
        cancelLastSearch_wasCalled = true
    }

    func isPerformingSearch() -> Bool {
        return false
    }

    var downloadPage_called_withURL: NSURL?
    var downloadPage_called_withTotalBytesRead: ((Int64) -> Void)?
    var downloadPage_called_withCompletion: ((NSURL?, ErrorType?) -> ())?
    func downloadPage(url: NSURL, totalBytesRead: ((Int64) -> Void), completion: ((NSURL?, ErrorType?) -> ())?) -> RequestProtocol? {
        downloadPage_called_withURL = url
        downloadPage_called_withTotalBytesRead = totalBytesRead
        downloadPage_called_withCompletion = completion
        return FakeRequest()
    }
}
