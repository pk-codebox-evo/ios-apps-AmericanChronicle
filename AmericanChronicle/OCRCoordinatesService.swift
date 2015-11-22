//
//  OCRCoordinatesService.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 11/22/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import Alamofire

// MARK: -
// MARK: OCRCoordinatesServiceInterface

public protocol OCRCoordinatesServiceInterface {
    func startRequest(lccn: String, year: Int, month: Int, day: Int, edition: String, sequence: String, contextID: String, completionHandler: ((SearchResults?, ErrorType?) -> Void))
    func isSearchInProgress(term: String, page: Int, contextID: String) -> Bool
    func cancelSearch(term: String, page: Int, contextID: String)
}