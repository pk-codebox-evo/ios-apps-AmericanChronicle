//
//  SearchViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/8/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

// NOTES:
//
// The View is passive. It waits for the Presenter to give it content to display; it never asks the Presenter for data.
// The view controller shouldn’t be making decisions based on (user) actions, but it should pass these events along to something that can.

protocol SearchViewInterface: class {
    weak var presenter: SearchPresenterInterface? { get set }
    func setViewState(state: ViewState)
    func setBottomContentInset(bottom: CGFloat)
    func resignFirstResponder() -> Bool
    func currentSearchTerm() -> String
}

// http://scotthurff.com/posts/why-your-user-interface-is-awkward-youre-ignoring-the-ui-stack
enum ViewState: Equatable, CustomStringConvertible {
    case EmptySearchField // Blank (A)
    case EmptyResults // Blank (B)
    case LoadingNewTerm
    case LoadingMoreRows
    case Partial(title: String, rows: [SearchResultsRow])
    case Ideal(title: String, rows: [SearchResultsRow])
    case Error(title: String?, message: String?)

    var description: String {
        var desc = "<ViewState: "
        switch self {
        	case .EmptySearchField: desc += "EmptySearchField"
            case .EmptyResults: desc += "EmptyResults"
            case .LoadingNewTerm: desc += "LoadingNewTerm"
            case .LoadingMoreRows: desc += "LoadingMoreRows"
            case let .Partial(title, rows):
                desc += "Partial, title=\(title), rows=["
                desc += rows.map({"\($0.description)" }).joinWithSeparator(", ")
                desc += "]"
            case let .Ideal(title, rows):
                desc += "Ideal, title=\(title), rows=["
                desc += rows.map({"\($0.description)" }).joinWithSeparator(", ")
                desc += "]"
            case let .Error(title, message):
                desc += "Error, title=\(title), message=\(message)"

        }
        desc += ">"
        return desc
    }
}

func ==(a: ViewState, b: ViewState) -> Bool {
    switch (a, b) {
        case (.EmptySearchField, .EmptySearchField): return true
        case (.EmptyResults, .EmptyResults): return true
        case (.LoadingNewTerm, .LoadingNewTerm): return true
        case (.LoadingMoreRows, .LoadingMoreRows): return true
        case (let .Partial(titleA, rowsA), let .Partial(titleB, rowsB)):
            return (titleA == titleB) && (rowsA == rowsB)
        case (let .Ideal(titleA, rowsA), let .Ideal(titleB, rowsB)):
            return (titleA == titleB) && (rowsA == rowsB)
        case (let .Error(titleA, messageA), let .Error(titleB, messageB)):
            return (titleA == titleB) && (messageA == messageB)
        default: return false
    }
}

class SearchViewController: UIViewController, SearchViewInterface, UITableViewDelegate, UITableViewDataSource {

    // MARK: Properties

    weak var presenter: SearchPresenterInterface?

    @IBOutlet weak var emptyResultsLabel: UILabel!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorTitleLabel: UILabel!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var searchField: SearchField!
    @IBOutlet weak var tableView: UITableView!

    var filters: SearchFilters?
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)

    var sectionTitle = ""

    private var rows: [SearchResultsRow] = []

    // MARK: Internal methods

    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        presenter?.userDidTapCancel()
    }

    func setBottomContentInset(bottom: CGFloat) {
        if !isViewLoaded() {
            return
        }
        var contentInset = tableView.contentInset
        contentInset.bottom = bottom
        tableView.contentInset = contentInset

        var indicatorInsets = tableView.scrollIndicatorInsets
        indicatorInsets.bottom = bottom
        tableView.scrollIndicatorInsets = indicatorInsets
    }

    // > The partial state is the screen someone will see when the page is no longer empty and
    //   sparsely populated. Your job here is to prevent people from getting discouraged and giving
    //   up on your product.
    //
    // - http://scotthurff.com/posts/why-your-user-interface-is-awkward-youre-ignoring-the-ui-stack
    func setViewState(state: ViewState) {
        switch state {
        case .EmptySearchField:
            setLoadingIndicatorsVisible(false)
            emptyResultsLabel.alpha = 0
            errorView.alpha = 0
            sectionTitle = ""
            rows = []
            tableView.reloadData()
            tableView.tableFooterView?.alpha = 0
        case .EmptyResults:
            setLoadingIndicatorsVisible(false)
            emptyResultsLabel.alpha = 1.0
            errorView.alpha = 0
            sectionTitle = ""
            rows = []
            tableView.reloadData()
            tableView.tableFooterView?.alpha = 0
        case .LoadingNewTerm:
            setLoadingIndicatorsVisible(true)
            emptyResultsLabel.alpha = 0
            errorView.alpha = 0
            tableView.tableFooterView?.alpha = 0
        case .LoadingMoreRows:
            setLoadingIndicatorsVisible(false)
            emptyResultsLabel.alpha = 0
            errorView.alpha = 0
            tableView.tableFooterView?.alpha = 1.0
        case let .Partial(title, rows):
            setLoadingIndicatorsVisible(false)
            emptyResultsLabel.alpha = 0
            errorView.alpha = 0
            sectionTitle = title
            self.rows = rows
            tableView.reloadData()
            tableView.tableFooterView?.alpha = 0
        case let .Ideal(title, rows):
            setLoadingIndicatorsVisible(false)
            emptyResultsLabel.alpha = 0
            errorView.alpha = 0
            sectionTitle = title
            self.rows = rows
            tableView.reloadData()
            tableView.tableFooterView?.alpha = 0
        case let .Error(title, message):
            setLoadingIndicatorsVisible(false)
            emptyResultsLabel.alpha = 0
            errorView.alpha = 1.0
            sectionTitle = ""
            rows = []
            tableView.reloadData()
            errorTitleLabel.text = title
            errorMessageLabel.text = message
            tableView.tableFooterView?.alpha = 0
        }
    }

    @IBAction func filterButtonTapped(sender: UIButton) {
        presenter?.userDidTapUSStates()
    }

    func currentSearchTerm() -> String {
        return searchField?.text ?? ""
    }

    // MARK: SearchView properties and methods

    private func setLoadingIndicatorsVisible(visible: Bool) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = visible
        if visible {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

    // MARK: UITableViewDelegate & -DataSource methods

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("Header") as? TableHeaderView
        headerView?.label.text = sectionTitle
        return headerView
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        let pageCell = tableView.dequeueReusableCellWithIdentifier("SearchResultsPageCell") as! SearchResultsPageCell
        let result = rows[indexPath.row]

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
        pageCell.thumbnailImageView.sd_setImageWithURL(result.thumbnailURL)
        cell = pageCell
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        searchField.resignFirstResponder()
        let row = rows[indexPath.row]
        presenter?.userDidSelectSearchResult(row)
    }

    static let approachingCount = 5

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

        if (rows.count > 0) && ((rows.count - indexPath.row) < SearchViewController.approachingCount) {
            presenter?.userIsApproachingLastRow(searchField.text, inCollection: rows)
        }
    }

    // MARK: UIViewController overrides

    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBarHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        searchField.shouldChangeCharactersHandler = { [weak self] original, range, replacement in
            var text = original
            if let range = original.rangeFromNSRange(range) {
                text.replaceRange(range, with: replacement)
            }

            self?.presenter?.userDidChangeSearchToTerm(text)

            return true
        }

        searchField.shouldReturnHandler = { [weak self] in
            self?.presenter?.userDidTapReturn()
            return false
        }

        tableView.registerClass(TableHeaderView.self, forHeaderFooterViewReuseIdentifier: "Header")
        tableView.sectionHeaderHeight = 40.0
        tableView.rowHeight = 150.0

        view.addSubview(activityIndicator)

        activityIndicator.snp_makeConstraints { make in
            make.center.equalTo(view.snp_center)
        }

        presenter?.viewDidLoad()

        setViewState(.EmptySearchField)
    }

    // MARK: UIResponder methods

    override func becomeFirstResponder() -> Bool {
        return searchField.becomeFirstResponder()
    }

    override func resignFirstResponder() -> Bool {
        return searchField.resignFirstResponder()
    }
}
