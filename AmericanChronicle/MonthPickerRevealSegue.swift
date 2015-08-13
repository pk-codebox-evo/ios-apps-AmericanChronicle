//
//  MonthPickerRevealSegue.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/12/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

class MonthPickerRevealSegue: UIStoryboardSegue {
    override func perform() {
        if let monthPickerVC = destinationViewController as? MonthPickerViewController,
           let searchFiltersVC = sourceViewController as? SearchFiltersViewController {
//            var pickerFrame = searchFiltersVC.view.bounds ?? CGRectZero
//            monthPickerVC.view.frame = pickerFrame
//            searchFiltersVC.view.addSubview(monthPickerVC.view)
//
//

//
//            println("monthPickerVC.view: \(monthPickerVC.view)")
//
//
//            monthPickerVC.view.alpha = 0
//


//            monthPickerVC.backdropHeight.constant = searchFiltersVC.view.bounds.size.height ?? 0
            searchFiltersVC.view.addSubview(monthPickerVC.view)
            monthPickerVC.backdropView.alpha = 0

//            var relativeButtonFrame = UIApplication.sharedApplication().keyWindow!.convertRect(searchFiltersVC.monthButton.frame, fromView: searchFiltersVC.view)
//            monthPickerVC.backdropHeight.constant = CGRectGetMaxY(relativeButtonFrame ?? CGRectZero)
//            monthPickerVC.view.setNeedsUpdateConstraints()


            UIView.animateWithDuration(1.0, animations: {
//                monthPickerVC.view.layoutIfNeeded()
                monthPickerVC.backdropView.alpha = 1.0
                }, completion: { _ in
                    searchFiltersVC.presentViewController(monthPickerVC, animated: false, completion: nil)
            })

        }
    }
}
