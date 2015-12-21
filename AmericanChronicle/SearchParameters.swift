//
//  SearchParameters.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 1/3/16.
//  Copyright © 2016 ryanipete. All rights reserved.
//

struct SearchParameters {
    let term: String
    let states: [String]
    let earliestDate: NSDate
    let latestDate: NSDate
}

extension SearchParameters: Hashable {
    var hashValue: Int {
        return "\(term)-\(states)-earliestDate-latestDate".hashValue
    }
}

extension SearchParameters: Equatable {}
func ==(lhs: SearchParameters, rhs: SearchParameters) -> Bool {
    return (lhs.term == rhs.term)
        && (lhs.states == rhs.states)
        && (lhs.earliestDate == rhs.earliestDate)
        && (lhs.latestDate == rhs.latestDate)
}