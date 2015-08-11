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

    enum ResultType: Int {
        case Newspaper
        case Page
    }

    var data = [[String: AnyObject]]()
    let recentSearches: [[String: AnyObject]] = [
        ["title": "Recent Searches", "rows": ["The Argus", "The Arizona Champion", "Jane Doe Blah"]]
    ]
    let searchResults: [[String: AnyObject]] = [
        [
            "title": "1 matching newspaper",
            "rows": ["The Daily Chronicle"],
            "type": ResultType.Newspaper.rawValue
        ],
        [
            "title": "118 matching pages",
            "rows": [
            "The Daily Chronicle",
            "The Daily Chronicle",
            "The Daily Chronicle",
            "The Daily Chronicle",
            "The Daily Chronicle",
            "The Daily Chronicle",
            "The Daily Chronicle",
            "The Daily Chronicle"
        ],
            "type": ResultType.Page.rawValue
        ]
    ]

    @IBAction func unfocusPage(sender: UIStoryboardSegue) {
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if count(searchBar.text) == 0 {
            searchBar.becomeFirstResponder()
            showRecentSearches()
        }
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if count(searchText) > 0 {
            showSearchResults()
        } else {
            showRecentSearches()
        }
    }

    func showSearchResults() {
        data = searchResults
        tableView.reloadData()
    }

    func showRecentSearches() {
        data = recentSearches
        tableView.reloadData()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rows = data[section]["rows"] as? [String] {
            return count(rows)
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if data == recentSearches {
             cell = tableView.dequeueReusableCellWithIdentifier("RecentSearchCell") as! UITableViewCell
        } else {
            if let rawType = data[indexPath.section]["type"] as? Int {
                if ResultType(rawValue: rawType) == .Newspaper {
                    cell = tableView.dequeueReusableCellWithIdentifier("SearchResultsNewspaperCell") as! UITableViewCell
                } else {
                    cell = tableView.dequeueReusableCellWithIdentifier("SearchResultsPageCell") as! UITableViewCell
                }
            } else {
                cell = tableView.dequeueReusableCellWithIdentifier("SearchResultsPageCell") as! UITableViewCell
            }

        }
        if let rows = data[indexPath.section]["rows"] as? [String] {
            cell.textLabel?.text = rows[indexPath.row]
        } else {
            cell.textLabel?.text = nil
        }
        return cell
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return count(data)
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data[section]["title"] as? String
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if data == recentSearches, let rows = data[indexPath.section]["rows"] as? [String] {
            searchBar.text = rows[indexPath.row]
            showSearchResults()
        } else {
            println("\(__FILE__) | \(__FUNCTION__) | line \(__LINE__)")
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? NewspaperIssuesViewController {
            if let selected = tableView.indexPathForSelectedRow() {
                vc.newspaper = (data[selected.section]["rows"] as! [String])[selected.row]
            }
        }
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
