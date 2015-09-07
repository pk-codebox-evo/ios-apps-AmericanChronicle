//
//  NewspaperPageUnfocusSegue.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/9/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

class NewspaperPageUnfocusSegue: UIStoryboardSegue {

    func performUnfocusToPages(pagesViewController: NewspaperPagesViewController, pageViewController: PageViewController) {
        pagesViewController.dismissViewControllerAnimated(true, completion: nil)
    }

    func performUnfocusToSearch(searchViewController: SearchViewController, pageViewController: PageViewController) {
        searchViewController.navigationController?.popViewControllerAnimated(true)
    }

    override func perform() {
        if let pageViewController = sourceViewController as? PageViewController {
            if let pagesViewController = destinationViewController as? NewspaperPagesViewController {
                performUnfocusToPages(pagesViewController, pageViewController: pageViewController)
            } else if let searchViewController = destinationViewController as? SearchViewController {
                performUnfocusToSearch(searchViewController, pageViewController: pageViewController)
            }
        }
    }
}

