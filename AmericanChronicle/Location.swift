//
//  Location.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/22/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

protocol Location {
    var name: String { get }
    var lat: Float { get }
    var lng: Float { get }
}

func ==<T: Location>(lhs: T, rhs: T) -> Bool {
    return true
}

