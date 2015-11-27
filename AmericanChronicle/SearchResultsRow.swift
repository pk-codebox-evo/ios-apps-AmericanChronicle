//
//  SearchResultsRow.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 10/24/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import UIKit

public class SearchResultsRow: CustomStringConvertible {
    let id: String?
    let date: NSDate?
    let cityState: String
    let publicationTitle: String
    let thumbnailURL: NSURL?
    let pdfURL: NSURL?
    let lccn: String?
    let edition: Int?
    let sequence: Int?
    public init(id: String?, date: NSDate?, cityState: String, publicationTitle: String, thumbnailURL: NSURL?, pdfURL: NSURL?, lccn: String?, edition: Int?, sequence: Int?) {
        self.id = id
        self.date = date
        self.cityState = cityState
        self.publicationTitle = publicationTitle
        self.thumbnailURL = thumbnailURL
        self.pdfURL = pdfURL
        self.lccn = lccn
        self.edition = edition
        self.sequence = sequence
    }

    public var description: String {
        var desc = "<SearchResultsRow: "
        desc += "id=\(id)"
        desc += ", date=\(date)"
        desc += ", cityState=\(cityState)"
        desc += ", publicationTitle=\(publicationTitle)"
        desc += ", thumbnailURL=\(thumbnailURL)"
        desc += ", lccn=\(lccn)"
        desc += ", edition=\(edition)"
        desc += ", sequence=\(sequence)"
        desc += ">"
        return desc
    }
}
extension SearchResultsRow: Equatable { }
public func ==(lhs: SearchResultsRow, rhs: SearchResultsRow) -> Bool {
    return lhs.date == rhs.date
        && lhs.cityState == rhs.cityState
        && lhs.publicationTitle == rhs.publicationTitle
        && lhs.thumbnailURL == rhs.thumbnailURL
}
