//
//  LocationSearchViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/16/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

class LocationSearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var results: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CurrentLocationCell")
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "RecentLocationCell")
        // Do any additional setup after loading the view.
    }

    // MARK: UITableViewDelegate methods

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = MapSelectionViewController(nibName: "MapSelectionViewController", bundle: nil)
        vc.savedCallback = { [weak self] in
        }
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("RecentLocationCell") as! UITableViewCell
            cell.textLabel?.text = results[indexPath.row]
            return cell
        default:
            return UITableViewCell()
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    //
    //    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return nil
    //    }
    //
    //    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    //        return nil
    //    }
    //
    //    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    //        return false
    //    }
    //
    //    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    //        return false
    //    }
    //
    //    func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
    //    }
    //
    //    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
    //        return 0
    //    }
    //
    //    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    //    }
    //
    //    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
    //    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
            results = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        } else {
            results = []
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
