//
//  SearchViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/8/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

public class SearchResultsRow {
    let date: NSDate?
    let cityState: String
    let publicationTitle: String
    let thumbnailURL: NSURL?
    init(date: NSDate?, cityState: String, publicationTitle: String, thumbnailURL: NSURL?) {
        self.date = date
        self.cityState = cityState
        self.publicationTitle = publicationTitle
        self.thumbnailURL = thumbnailURL
    }

    public var description: String {
        var desc = "<SearchResultsRow: "
        desc += ", date=\(date)"
        desc += ", cityState=\(cityState)"
        desc += ", publicationTitle=\(publicationTitle)"
        desc += ", thumbnailURL=\(thumbnailURL)>"
        return desc
    }
}

// NOTES:
//
// The View is passive. It waits for the Presenter to give it content to display; it never asks the Presenter for data.
// The view controller shouldn’t be making decisions based on (user) actions, but it should pass these events along to something that can.

public protocol SearchView: class {
    var searchResultSelectedCallback: ((SearchResultsRow) -> ())? { get set }
    var cancelCallback: ((Void) -> ())? { get set }
    var searchTermDidChangeCallback: ((String?) -> ())? { get set }

    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showSearchResults(rows: [SearchResultsRow], title: String)
    func showEmptyResults()
    func showErrorMessage(title: String?, message: String?)
}

public class SearchViewController: UIViewController, SearchView, UITableViewDelegate, UITableViewDataSource {

    // MARK: Properties

    var filters: SearchFilters?
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    var resultRows: [SearchResultsRow] = []
    var sectionTitle = ""

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var searchField: SearchField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filtersButton: UIButton!

    // MARK: Internal methods

    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        cancelCallback?()
    }

    @IBAction func addEditFiltersButtonTapped(sender: AnyObject) {
        let vc = SearchFiltersViewController(nibName: "SearchFiltersViewController", bundle: nil)
        vc.searchFilters = filters ?? SearchFilters()
        vc.saveCallback = { [weak self] filters in
            self?.filters = filters
            self?.searchTermDidChangeCallback?(self?.searchField.text)
            self?.dismissViewControllerAnimated(true, completion: nil)
        }
        vc.cancelCallback = { [weak self] in
            self?.dismissViewControllerAnimated(true, completion: nil)
        }
        let nvc = UINavigationController(rootViewController: vc)
        presentViewController(nvc, animated: true, completion: nil)
    }

    // MARK: SearchView properties and methods

    public var searchResultSelectedCallback: ((SearchResultsRow) -> ())?
    public var cancelCallback: ((Void) -> ())?
    public var searchTermDidChangeCallback: ((String?) -> ())?

    public func showLoadingIndicator() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        activityIndicator.startAnimating()
    }

    public func hideLoadingIndicator() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        activityIndicator.stopAnimating()
    }

    public func showSearchResults(rows: [SearchResultsRow], title: String) {
        resultRows = rows
        sectionTitle = title
        tableView.reloadData()
    }

    public func showEmptyResults() {

    }

    public func showErrorMessage(title: String?, message: String?) {

    }

    // MARK: UITableViewDelegate & -DataSource methods

    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("Header") as? TableHeaderView
        headerView?.label.text = sectionTitle
        return headerView
    }

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultRows.count ?? 0
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        let pageCell = tableView.dequeueReusableCellWithIdentifier("SearchResultsPageCell") as! SearchResultsPageCell
        let result = resultRows[indexPath.row]

        if let date = result.date {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MMM dd, yyyy"
            pageCell.dateLabel.text = formatter.stringFromDate(date)
        } else {
            pageCell.dateLabel.text = ""
        }
        pageCell.cityStateLabel.text = result.cityState ?? ""
        pageCell.publicationTitleLabel.text = result.publicationTitle ?? ""
        pageCell.thumbnailImageView.backgroundColor = UIColor.lightGrayColor()
        cell = pageCell
        return cell
    }

    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let row = resultRows[indexPath.row]
        searchResultSelectedCallback?(row)
    }

    // MARK: UIViewController overrides

    override public func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBarHidden = false
        let filtersTitle = (filters == nil) ? "Add Filters" : "Edit Filters"
        filtersButton.setTitle(filtersTitle, forState: .Normal)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        searchField.shouldChangeCharactersCallback = { [weak self] original, range, replacement in
            var text = original
            if let range = original.rangeFromNSRange(range) {
                text.replaceRange(range, with: replacement)
            }

            self?.searchTermDidChangeCallback?(text)

            return true
        }

        filtersButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: UIFont.buttonFontSize())

        tableView.registerClass(TableHeaderView.self, forHeaderFooterViewReuseIdentifier: "Header")
        tableView.sectionHeaderHeight = 40.0
        tableView.rowHeight = 150.0

        activityIndicator.stopAnimating()
        view.addSubview(activityIndicator)

        activityIndicator.snp_makeConstraints { make in
            make.center.equalTo(view.snp_center)
        }
    }

    override public func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        searchField.resignFirstResponder()
    }

    // MARK: UIResponder methods

    public override func becomeFirstResponder() -> Bool {
        return searchField.becomeFirstResponder()
    }
}
