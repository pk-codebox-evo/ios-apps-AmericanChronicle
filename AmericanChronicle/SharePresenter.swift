//
//  SharePresenter.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 11/27/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import Foundation

public class SharePresenter {
    var view: UIActivityViewController? {
        didSet {
            view?.completionWithItemsHandler = { type, completed, returnedItems, activityError in
                //            self.toastButton.frame = CGRect(x: 20.0, y: self.bottomBarBG.frame.origin.y - 80.0, width: self.view.bounds.size.width - 40.0, height: 60)
                //            let message: String = ""
                //            if type == nil {
                //                return
                //            }
                //            switch type {
                //            case UIActivityTypeSaveToCameraRoll:
                //                message = completed ? "Page saved successfully" : "Trouble saving, please try again"
                //            default:
                //                message = completed ? "Success" : "Action failed, please try again"
                //            }

                //            self.toastButton.setTitle(message, forState: .Normal)
                //            self.toastButton.alpha = 0
                //            self.toastButton.hidden = false
                //            UIView.animateWithDuration(0.2, animations: {
                //                self.toastButton.alpha = 1.0
                //            }, completion: { _ in
                //                UIView.animateWithDuration(0.2, delay: 3.0, options: UIViewAnimationOptions(), animations: {
                //                    self.toastButton.alpha = 0
                //                }, completion: { _ in
                //                    self.toastButton.hidden = true
                //                })
                //            })
            }
        }
    }
}