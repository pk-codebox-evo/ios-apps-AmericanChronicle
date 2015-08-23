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

    let notMatchingResults: TableViewData = {
        let data = TableViewData()
        data.sections.append(TableViewSection(title: "6 matches", rows: [
            SearchResultsRow(
                date: "Mar 14, 1889",
                cityState: "Scranton, PA",
                matchingText: "...Der befannte Runftbaudler Elie Wolf in Bajeljtadt...",
                publicationTitle: "Scranton Wochenblatt.",
                moreMatchesCount: "",
                imageName: "the_holbrook_news"),
            SearchResultsRow(
                date: "Dec 10, 1903",
                cityState: "Logan, OH",
                matchingText: "...the home of Mesers Wolf and Grossman on East Hunter...",
                publicationTitle: "The Ohio Democrat",
                moreMatchesCount: "",
                imageName: "the_holbrook_news"),
            SearchResultsRow(
                date: "Jan 09, 1920",
                cityState: "Plentywood, MO",
                matchingText: "...and Mrs. Eli Maltby of Wolf Point, spent her holiday...",
                publicationTitle: "The producers news",
                moreMatchesCount: "",
                imageName: "the_holbrook_news"),
            SearchResultsRow(
                date: "Jul 07, 1905",
                cityState: "Canton, OH",
                matchingText: "...Reeder on the saw-mill. Eliza Wolf has returned home...",
                publicationTitle: "The Stark County Democrat",
                moreMatchesCount: "",
                imageName: "the_holbrook_news"),
            SearchResultsRow(
                date: "Mar 08, 1921",
                cityState: "Astoria, OR",
                matchingText: "...kohtalosta. Beethoven eli Wienissa edelleenkin. V. 1806...",
                publicationTitle: "Toveritar",
                moreMatchesCount: "and 5 more",
                imageName: "the_holbrook_news"),
            SearchResultsRow(
                date: "Dec 03, 1898",
                cityState: "Maysville, KY",
                matchingText: "...it many new cases. Eli Perkins. Eli Perkins. Mr Perkins'...",
                publicationTitle: "The evening bulletin.",
                moreMatchesCount: "and 1 more",
                imageName: "thumb_1")
            ]))
        return data
    }()

    let matchingResults: TableViewData = {
        let data = TableViewData()
        data.sections.append(TableViewSection(title: "4 matches", rows: [
            SearchResultsRow(
                date: "Sep 20, 1902",
                cityState: "Williams, AZ",
                matchingText: "...in this city, Eli W. Wolf, aged seventy-one years...",
                publicationTitle: "Williams news",
                moreMatchesCount: "and 3 more",
                imageName: "seq-1-highlight"
            ), SearchResultsRow(
                date: "Feb 03, 1922",
                cityState: "Williams, AZ",
                matchingText: "...the death of Calvin M. Wolfe in Phoenix, Arizona, on...",
                publicationTitle: "Williams news",
                moreMatchesCount: "and 9 more",
                imageName: "the_williams_news_2"
            ), SearchResultsRow(
                date: "Dec 19, 1919",
                cityState: "Holbrook, AZ",
                matchingText: "...Braam, Messrs. Sims Ely, Williams, Kelley, Wolfe...",
                publicationTitle: "The Holbrook news",
                moreMatchesCount: "",
                imageName: "the_holbrook_news"
            ), SearchResultsRow(
                date: "Aug 10, 1916",
                cityState: "Williams, AZ",
                matchingText: "...Williams News. Fred Wolfe took out a new Maxwell...",
                publicationTitle: "Williams news",
                moreMatchesCount: "and 3 more",
                imageName: "the_williams_news")
            ]))
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
            activeData = matchingResults
        } else {
            activeData = notMatchingResults
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

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return activeData?.sections.count ?? 0
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return activeData?.sections[section].title
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if activeData === recentSearches {
            searchBar.text = activeData?.sections[indexPath.section].rows[indexPath.row].cellText
            performSearchWithResultsCount(count(searchBar.text))
        }

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (activeData === notMatchingResults) || (activeData === matchingResults) {
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
