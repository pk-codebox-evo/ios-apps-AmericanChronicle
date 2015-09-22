//
//  State.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/22/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

struct State: Equatable {
    var name: StateName
    var lat: Float
    var lng: Float
    var cities: [City] = []
    var newspapers: [Newspaper] {
        var papers: [Newspaper] = []
        for city in cities {
            papers.appendContentsOf(city.newspapers)
        }
        return papers
    }
}

func ==(lhs: State, rhs: State) -> Bool {
    return true
}