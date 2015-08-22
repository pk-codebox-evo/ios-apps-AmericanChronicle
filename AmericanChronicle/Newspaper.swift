//
//  Newspaper.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/22/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

struct Newspaper {
    let title: String
    let city: String
    var startYear: Int?
    var endYear: Int?

    init(title: String, city: String, startYear: Int?, endYear: Int?) {
        self.title = title
        self.city = city
        self.startYear = startYear
        self.endYear = endYear
    }

    var description: String {
        return title
    }
}
