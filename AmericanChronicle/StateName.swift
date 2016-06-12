//
//  StateName.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/22/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

enum StateName: String {
    case Alabama = "Alabama"
    case Arizona = "Arizona"
    case Arkansas = "Arkansas"
    static var alphabeticalList: [StateName] {
        return [.Alabama, .Arizona, .Arkansas]
    }
    var abbreviation: String {
        switch self {
        case Alabama: return "AL"
        case Arizona: return "AZ"
        case Arkansas: return "AR"
        }
    }
}
