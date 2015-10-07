//
//  CGPDFPageRef+AMC.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 10/6/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import Foundation

extension CGPDFPageRef {
    var mediaBoxRect: CGRect {
        return CGPDFPageGetBoxRect(self, .MediaBox)
    }
}
