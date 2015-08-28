//
//  LocationSearchViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/16/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit
import CoreLocation


class LocationSearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var locationSelectedCallback: ((City) -> ())?

    var recentSearches: [String] = [
        "Phoenix",
        "Williams",
        "Alabama"
    ]

    var searchResults: [City] = [
        City(name: "Williams", lat: 0, lng: 0, stateName: .Arizona, newspapers: [])
    ]

    var shouldShowSearchResults: Bool {
        return count(searchBar.text) > 0
    }

    var shouldShowCurrentLocation: Bool {
        return !shouldShowSearchResults
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CurrentLocationCell")
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "RecentLocationCell")
    }

    // MARK: UITableViewDelegate methods

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            searchBar.text = "Tucson, AZ"
            tableView.reloadData()
        case 1:
            if shouldShowSearchResults {
                locationSelectedCallback?(searchResults[indexPath.row])
            } else {
                searchBar.text = recentSearches[indexPath.row]
                tableView.reloadData()
            }
        default:
            break
        }
    }

    // MARK: UITableViewDataSource methods {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return shouldShowCurrentLocation ? 1 : 0
        case 1:
            return shouldShowSearchResults ? searchResults.count : recentSearches.count
        default:
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("CurrentLocationCell") as! UITableViewCell
            cell.textLabel?.text = "Current Location"
            cell.imageView?.image = UIImage(named: "TrackingLocationMask")?.imageWithRenderingMode(.AlwaysTemplate)
            cell.imageView?.tintColor = UIColor.blueColor().colorWithAlphaComponent(0.5)
            return cell
        case 1:
            if shouldShowSearchResults {
                let cell = tableView.dequeueReusableCellWithIdentifier("RecentLocationCell") as! UITableViewCell
                let searchResult = searchResults[indexPath.row]
                cell.textLabel?.text = "\(searchResult.name), \(searchResult.stateName.abbreviation)"
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("RecentLocationCell") as! UITableViewCell
                cell.textLabel?.text = recentSearches[indexPath.row]
                return cell
            }
        default:
            return UITableViewCell()
        }

    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 1) && !shouldShowSearchResults {
            return "Recent searches"
        }
        return nil
    }

    // MARK: UISearchBarDelegate methods

    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        return true
    }

    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {

    }

    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        return true
    }

    func searchBarTextDidEndEditing(searchBar: UISearchBar) {

    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.reloadData()
    }

//    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
//
//    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
//
//    func searchBarBookmarkButtonClicked(searchBar: UISearchBar) {
//
//    }
//
//    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
//
//    }
//
//    func searchBarResultsListButtonClicked(searchBar: UISearchBar) {
//
//    }
//
//    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
//
//    }

}
