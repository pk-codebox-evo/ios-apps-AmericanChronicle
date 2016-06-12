//
//  ChroniclingAmericaEndpoint.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/15/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

enum ChroniclingAmericaEndpoint: String {
    case PagesSearch = "search/pages/results/"

    // ---

    internal static let baseURLString = "http://chroniclingamerica.loc.gov/"
    var fullURLString: String? { return "\(ChroniclingAmericaEndpoint.baseURLString)\(self.rawValue)" }
    var fullURL: NSURL? { return NSURL(string: fullURLString ?? "") }
}

struct SearchConstants {
    static let earliestPossibleDayMonthYear = DayMonthYear(day: 1, month: 1, year: 1836)
    static let latestPossibleDayMonthYear = DayMonthYear(day: 31, month: 12, year: 1922)
}


