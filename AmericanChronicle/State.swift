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
}

func ==(lhs: State, rhs: State) -> Bool {
    return true
}