//
//  City.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/22/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

struct City: Equatable {
    let name: String
    let lat: Float
    let lng: Float
    let stateName: StateName
    var newspapers: [Newspaper] = []
}

func ==(lhs: City, rhs: City) -> Bool {
    return true
}

