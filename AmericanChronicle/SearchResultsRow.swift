//
//  SearchResultsRow.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 10/24/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import UIKit

public class SearchResultsRow {
    let date: NSDate?
    let cityState: String
    let publicationTitle: String
    let thumbnailURL: NSURL?
    let pdfURL: NSURL?
    let estimatedPDFSize: Int
    init(date: NSDate?, cityState: String, publicationTitle: String, thumbnailURL: NSURL?, pdfURL: NSURL?, estimatedPDFSize: Int) {
        self.date = date
        self.cityState = cityState
        self.publicationTitle = publicationTitle
        self.thumbnailURL = thumbnailURL
        self.pdfURL = pdfURL
        self.estimatedPDFSize = estimatedPDFSize
    }

    public var description: String {
        var desc = "<SearchResultsRow: "
        desc += ", date=\(date)"
        desc += ", cityState=\(cityState)"
        desc += ", publicationTitle=\(publicationTitle)"
        desc += ", thumbnailURL=\(thumbnailURL)"
        desc += ", estimatedPDFSize=\(estimatedPDFSize)>"
        return desc
    }
}
extension SearchResultsRow: Equatable { }
public func ==(lhs: SearchResultsRow, rhs: SearchResultsRow) -> Bool {
    return lhs.date == rhs.date
        && lhs.cityState == rhs.cityState
        && lhs.publicationTitle == rhs.publicationTitle
        && lhs.thumbnailURL == rhs.thumbnailURL
        && lhs.estimatedPDFSize == rhs.estimatedPDFSize
}
