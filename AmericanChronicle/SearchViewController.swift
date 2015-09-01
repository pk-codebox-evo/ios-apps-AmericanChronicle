//
//  SearchViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/8/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

protocol TableViewRow: Printable {
    var cellText: String { get }
}

extension String: TableViewRow {
    var cellText: String {
        return self
    }

    public var description: String {
        return self
    }
}

class TableViewData {
    var sections: [TableViewSection] = []
}

class TableViewSection: Printable {
    var rows: [TableViewRow] = []
    var maxRowsToShow: Int?
    var title: String = ""
    init(title: String, rows: [TableViewRow]) {
        self.rows = rows
        self.title = title
    }

    var rowsToShow: Int {
        return maxRowsToShow ?? rows.count
    }

    var description: String {
        var desc = "TableViewSection <\(unsafeAddressOf(self))>"
        desc += " (\(rows.count) rows)\n"
        for row in rows {
            desc += "* \(row)\n"
        }
        return desc
    }
}

class SearchResultsRow: TableViewRow {
    var cellText: String {
        return matchingText
    }
    var date = "Jan 3, 1902"
    var cityState = "Denver, CO"
    var matchingText = "…with a full season of practice, Jane Doe had learned enough to overtake the incumbent…"
    var publicationTitle = "The Daily Mail"
    var moreMatchesCount = "and 3 more"
    var imageName = ""
    init(date: String, cityState: String, matchingText: String, publicationTitle: String, moreMatchesCount: String, imageName: String) {
        self.date = date
        self.cityState = cityState
        self.matchingText = matchingText
        self.publicationTitle = publicationTitle
        self.moreMatchesCount = moreMatchesCount
        self.imageName = imageName
    }

    var description: String {
        var desc = "SearchResultsRow <\(unsafeAddressOf(self))>\n"
        desc += "* * date: \(date)\n"
        desc += "* * cityState: \(cityState)\n"
        desc += "* * matchingText: \(matchingText)\n"
        desc += "* * publicationTitle: \(publicationTitle)\n"
        desc += "* * moreMatchesCount: \(moreMatchesCount)\n"
        desc += "* * imageName: \(imageName)\n"
        return desc
    }
}

class SearchViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filtersButton: UIButton!
    var filters: SearchFilters?

    @IBAction func addEditFiltersButtonTapped(sender: AnyObject) {
        let vc = SearchFiltersViewController(nibName: "SearchFiltersViewController", bundle: nil)
        vc.searchFilters = filters ?? SearchFilters()
        vc.saveCallback = { [weak self] filters in
            self?.filters = filters
            self?.performSearchWithResultsCount(0)
            self?.dismissViewControllerAnimated(true, completion: nil)
        }
        vc.cancelCallback = { [weak self] in
            self?.dismissViewControllerAnimated(true, completion: nil)
        }
        let nvc = UINavigationController(rootViewController: vc)
        presentViewController(nvc, animated: true, completion: nil)
    }

    let recentSearches: TableViewData = {
        let data = TableViewData()
        data.sections = [TableViewSection(title: "Recent Searches", rows: ["Eli", "The Arizona Champion", "Jane Doe"])]
        return data
    }()

    var activeData: TableViewData?

    @IBAction func unfocusPage(sender: UIStoryboardSegue) {
        println("\(__FILE__) | \(__FUNCTION__) | line \(__LINE__)")
    }

    @IBAction func dismissFilters(sender: UIStoryboardSegue) {
        println("\(__FILE__) | \(__FUNCTION__) | line \(__LINE__)")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBarHidden = false
        if count(searchBar.text) == 0 {
            searchBar.becomeFirstResponder()
            showRecentSearches()
        }
        let filtersTitle = (filters == nil) ? "Add Filters" : "Edit Filters"
        filtersButton.setTitle(filtersTitle, forState: .Normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(TableHeaderView.self, forHeaderFooterViewReuseIdentifier: "Header")
        filtersButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: UIFont.buttonFontSize())
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.resignFirstResponder()
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
        searchDelayTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "searchDelayTimerFired:", userInfo: ["resultsCount": resultsCount], repeats: false)
    }

    func searchDelayTimerFired(timer: NSTimer) {
        searchDelayTimer = nil

        let termMatches = NSString(string: searchBar.text.lowercaseString).containsString("eli")
        let earlyDateSet = filters?.earliestDate != nil
        let lateDateSet = filters?.latestDate != nil
        let locationsSet = filters?.cities?.count > 0
        if termMatches && (earlyDateSet || lateDateSet) && locationsSet {
            activeData = FakeData.searchResultsHit
        } else {
            activeData = FakeData.searchResultsMiss
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
            cell.textLabel?.font = UIFont(name: "AvenirNext-Regular", size: UIFont.systemFontSize())
            cell.textLabel?.text = activeData?.sections[indexPath.section].rows[indexPath.row].cellText
        } else {
            let pageCell = tableView.dequeueReusableCellWithIdentifier("SearchResultsPageCell") as! SearchResultsPageCell
            let result = activeData?.sections[indexPath.section].rows[indexPath.row] as! SearchResultsRow
            pageCell.dateLabel.text = result.date
            pageCell.cityStateLabel.text = result.cityState
            pageCell.matchingTextLabel.text = result.matchingText
            pageCell.publicationTitleLabel.text = result.publicationTitle
            pageCell.moreMatchesCountLabel.text = result.moreMatchesCount
            cell = pageCell
        }
        return cell
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("Header") as? TableHeaderView
        headerView?.label.text = "Recent Searches"
        return headerView
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return activeData?.sections.count ?? 0
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }


    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if activeData === recentSearches {
            searchBar.text = activeData?.sections[indexPath.section].rows[indexPath.row].cellText
            performSearchWithResultsCount(count(searchBar.text))
        }

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (activeData === FakeData.searchResultsMiss) || (activeData === FakeData.searchResultsHit) {
            return 150.0 // Page cell
        }
        return 44.0
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let nvc = segue.destinationViewController as? UINavigationController, let vc = nvc.viewControllers.first as? SearchFiltersViewController {
            vc.searchFilters = filters ?? SearchFilters()
            vc.saveCallback = { [weak self] filters in
                self?.filters = filters
                self?.dismissViewControllerAnimated(true, completion: nil)
            }
            vc.cancelCallback = { [weak self] in
                self?.dismissViewControllerAnimated(true, completion: nil)
            }
        } else if let vc = segue.destinationViewController as? PageViewController,
        let selectedIndexPath = tableView.indexPathForSelectedRow() {
            let selectedSection = activeData?.sections[selectedIndexPath.section]
            if let selectedItem = selectedSection?.rows[selectedIndexPath.row] as? SearchResultsRow {
                vc.imageName = selectedItem.imageName
            }
            vc.doneCallback = { [weak self] in
                self?.navigationController?.popViewControllerAnimated(true)
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
