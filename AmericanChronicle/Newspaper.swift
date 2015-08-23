//
//  Newspaper.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/22/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

struct Newspaper {
    let title: String
    let city: City
    var startYear: Int?
    var endYear: Int?

    var description: String {
        return title
    }
}
