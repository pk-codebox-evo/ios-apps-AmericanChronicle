//
//  LocationSearchViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/16/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit
import CoreLocation

protocol Location {
    var name: String { get }
    var lat: Float { get }
    var lng: Float { get }
}

struct State: Location, Equatable {
    var name: String
    var lat: Float
    var lng: Float
    init(name: String, lat: Float, lng: Float) {
        self.name = name
        self.lat = lat
        self.lng = lng
    }
}

struct City: Location, Equatable {
    var name: String
    var lat: Float
    var lng: Float
    init(name: String, lat: Float, lng: Float) {
        self.name = name
        self.lat = lat
        self.lng = lng
    }
}

func ==<T: Location>(lhs: T, rhs: T) -> Bool {
    return true
}

func ==(lhs: City, rhs: City) -> Bool {
    return true
}

func ==(lhs: State, rhs: State) -> Bool {
    return true
}

class LocationSearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var locationSelectedCallback: ((Location) -> ())?

    var results: [Location] = []

    var recentSearches: [Location] = [
        City(name: "Phoenix, AZ", lat: 0, lng: 0),
        City(name: "Santa Fe, NM", lat: 0, lng: 0),
        State(name: "California", lat: 0, lng: 0)
    ]

    var searchResults: [Location] = [
        State(name: "Wyoming", lat: 0, lng: 0),
        City(name: "Wyoming, MI", lat: 42.913408, lng: -85.708272)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        results = recentSearches
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CurrentLocationCell")
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "RecentLocationCell")
    }

    // MARK: UITableViewDelegate methods

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0: locationSelectedCallback?(City(name: "San Francisco, CA", lat: 0, lng: 0))
        case 1: locationSelectedCallback?(results[indexPath.row])
        default:
            break
        }
    }

    // MARK: UITableViewDataSource methods {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return results.count
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
            let cell = tableView.dequeueReusableCellWithIdentifier("RecentLocationCell") as! UITableViewCell
            cell.textLabel?.text = results[indexPath.row].name
            return cell
        default:
            return UITableViewCell()
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 1) && (results.count == recentSearches.count) {
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
        if count(searchText) > 0 {
            results = searchResults
        } else {
            results = recentSearches
        }
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
