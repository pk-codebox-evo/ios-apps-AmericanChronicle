//
//  NewspaperIssue.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/27/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import SwiftMoment

struct NewspaperIssue {
    let date: Moment
    let imageName: String
    let pages: [NewspaperPage]
    var description: String {
        return date.format(dateFormat: "MMM dd, yyyy")
    }
}

