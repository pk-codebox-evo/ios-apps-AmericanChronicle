//
//  SearchViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/8/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    class TableViewData {
        class TableViewSection {
            var rows: [String] = []
            var maxRowsToShow: Int?
            var title: String = ""
            init(rows: [String], title: String) {
                self.rows = rows
                self.title = title
            }

            var rowsToShow: Int {
                return maxRowsToShow ?? rows.count
            }
        }
        var sections: [TableViewSection] = []
    }

    let recentSearches: TableViewData = {
        let data = TableViewData()
        data.sections = [TableViewData.TableViewSection(rows: ["The Argus", "The Arizona Champion", "Jane Doe Blah"], title: "Recent Searches")]
        return data
    }()

    let searchResults: TableViewData = {
        let data = TableViewData()
        data.sections.append(TableViewData.TableViewSection(rows: ["The Daily Chronicle"], title: "1 matching newspaper"))
        data.sections.append(TableViewData.TableViewSection(rows: ["The Daily Chronicle", "The Daily Chronicle", "The Daily Chronicle", "The Daily Chronicle"], title: "118 matching pages"))
        return data
    }()

    var activeData: TableViewData?

    @IBAction func unfocusPage(sender: UIStoryboardSegue) {
        println("\(__FILE__) | \(__FUNCTION__) | line \(__LINE__)")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = false
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
            performSearchWithResultsCount(count(searchText))
        } else {
            showRecentSearches()
        }
    }

    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)

    var searchDelayTimer: NSTimer?

    func performSearchWithResultsCount(resultsCount: Int) {

        // If showing recent searches, then activate loading indicator.
        if activeData === recentSearches {
            activeData = nil

            activityIndicator.center = CGPoint(x: view.bounds.size.width / 2.0, y: 300)
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            tableView.reloadData()
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true

        searchDelayTimer?.invalidate()
        searchDelayTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "searchDelayTimerFired:", userInfo: ["resultsCount": resultsCount], repeats: false)
    }

    func searchDelayTimerFired(timer: NSTimer) {
        searchDelayTimer = nil

        if let userInfo = timer.userInfo as? [String: Int], let count = userInfo["resultsCount"] {
            let allPageResults = searchResults.sections[1].rows
            searchResults.sections[1].maxRowsToShow = min(count, allPageResults.count)
            activeData = searchResults
        }
        tableView.reloadData()
        activityIndicator.removeFromSuperview()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }

    func showRecentSearches() {
        searchDelayTimer?.invalidate()
        searchDelayTimer = nil
        self.activityIndicator.removeFromSuperview()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        activeData = recentSearches
        tableView.reloadData()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeData?.sections[section].rowsToShow ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if activeData === recentSearches {
            cell = tableView.dequeueReusableCellWithIdentifier("RecentSearchCell") as! UITableViewCell
            cell.textLabel?.text = activeData?.sections[indexPath.section].rows[indexPath.row]
        } else {
            switch indexPath.section {
            case 0:
                cell = tableView.dequeueReusableCellWithIdentifier("SearchResultsNewspaperCell") as! UITableViewCell
                cell.textLabel?.text = activeData?.sections[indexPath.section].rows[indexPath.row]
            default:
                let pageCell = tableView.dequeueReusableCellWithIdentifier("SearchResultsPageCell") as! SearchResultsPageCell
                pageCell.dateLabel.text = "Jan 3, 1902"
                pageCell.cityStateLabel.text = "Denver, CO"
                pageCell.matchingTextLabel.text = "…with a full season of practice, Jane Doe had learned enough to overtake the incumbent…"
                pageCell.publicationTitleLabel.text = "The Daily Mail"
                pageCell.moreMatchesCountLabel.text = "and 3 more"
                cell = pageCell
            }
        }

        return cell
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return activeData?.sections.count ?? 0
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return activeData?.sections[section].title
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if activeData === recentSearches {
            searchBar.text = activeData?.sections[indexPath.section].rows[indexPath.row]
            performSearchWithResultsCount(count(searchBar.text))
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 150.0 // Page cell
        }
        return 44.0
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? NewspaperIssuesViewController {
            if let selected = tableView.indexPathForSelectedRow() {
                vc.newspaper = activeData?.sections[selected.section].rows[selected.row]
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
