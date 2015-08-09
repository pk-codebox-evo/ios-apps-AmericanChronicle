//
//  SearchViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/8/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }

//    optional func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool // return NO to not become first responder

//    optional func searchBarTextDidBeginEditing(searchBar: UISearchBar) // called when text starts editing
//    optional func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool // return NO to not resign first responder
//    optional func searchBarTextDidEndEditing(searchBar: UISearchBar) // called when text ends editing
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if count(searchText) > 0 {
            // Show search results
        } else {
            // Show recent searches
        }
    }

//
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}