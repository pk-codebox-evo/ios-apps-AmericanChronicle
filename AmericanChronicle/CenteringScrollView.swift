//
//  CenteringScrollView.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/10/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

class CenteringScrollView: UIScrollView {

    let containerView = UIView()

    override func layoutSubviews() {
        super.layoutSubviews()

        let boundsSize = bounds.size
        var frameToCenter = containerView.frame

        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) * 0.5
        } else {
            frameToCenter.origin.x = 0
        }

        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) * 0.5
        } else {
            frameToCenter.origin.y = 0
        }

        containerView.frame = frameToCenter
    }
}
