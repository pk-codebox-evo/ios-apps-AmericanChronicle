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
    static func earliestPossibleDate() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        components.year = 1836
        return calendar.dateFromComponents(components)!
    }

    static func latestPossibleDate() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        components.year = 1922
        components.month = 12
        components.day = 31
        return calendar.dateFromComponents(components)!
    }
}


