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
    weak var delegate: SearchViewDelegate? { get set }
    func setViewState(state: ViewState)
    func setBottomContentInset(bottom: CGFloat)
    func resignFirstResponder() -> Bool
    func currentSearchTerm() -> String
    func setEarliestDateString(str: String)
    func setLatestDateString(str: String)
    func setStatesString(str: String)
}

protocol SearchViewDelegate: class {
    func userDidTapCancel()
    func userDidTapReturn()
    func userDidTapUSStates()
    func userDidTapEarliestDateButton()
    func userDidTapLatestDateButton()
    func userDidChangeSearchToTerm(term: String?)
    func userIsApproachingLastRow(term: String?, inCollection: [SearchResultsRow])
    func userDidSelectSearchResult(row: SearchResultsRow)
    func viewDidLoad()
}

// http://scotthurff.com/posts/why-your-user-interface-is-awkward-youre-ignoring-the-ui-stack
enum ViewState: Equatable, CustomStringConvertible {
    case EmptySearchField // Blank (A)
    case EmptyResults // Blank (B)
    case LoadingNewParamaters
    case LoadingMoreRows
    case Partial(title: String, rows: [SearchResultsRow])
    case Ideal(title: String, rows: [SearchResultsRow])
    case Error(title: String?, message: String?)

    var description: String {
        var desc = "<ViewState: "
        switch self {
        	case .EmptySearchField: desc += "EmptySearchField"
            case .EmptyResults: desc += "EmptyResults"
            case .LoadingNewParamaters: desc += "LoadingNewParamaters"
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
        case (.LoadingNewParamaters, .LoadingNewParamaters): return true
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

    weak var delegate: SearchViewDelegate?

    @IBOutlet weak var emptyResultsLabel: UILabel!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorTitleLabel: UILabel!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var searchField: SearchField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var earliestDateButton: TitleValueButton!
    @IBOutlet weak var latestDateButton: TitleValueButton!
    @IBOutlet weak var statesButton: TitleValueButton!

    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)

    var earliestDateTitle: String? {
        didSet {
            // Set button title
        }
    }

    var latestDateTitle: String? {
        didSet {
            // Set button title
        }
    }

    var statesTitle: String? {
        didSet {
            // Set button title
        }
    }

    var sectionTitle = ""

    private var rows: [SearchResultsRow] = []

    // MARK: Internal methods

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
        case .LoadingNewParamaters:
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
            if self.rows != rows {
                self.rows = rows
                tableView.reloadData()
            }
            tableView.tableFooterView?.alpha = 0
        case let .Ideal(title, rows):
            setLoadingIndicatorsVisible(false)
            emptyResultsLabel.alpha = 0
            errorView.alpha = 0
            sectionTitle = title
            if self.rows != rows {
                self.rows = rows
                tableView.reloadData()
            }
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

    func currentSearchTerm() -> String {
        return searchField?.text ?? ""
    }

    @IBAction func statesButtonTapped(sender: AnyObject) {
        delegate?.userDidTapUSStates()
    }

    @IBAction func earliestDateButtonTapped(sender: AnyObject) {
        delegate?.userDidTapEarliestDateButton()
    }

    @IBAction func latestDateButtonTapped(sender: AnyObject) {
        delegate?.userDidTapLatestDateButton()
    }

    func setEarliestDateString(str: String) {
        earliestDateButton.value = str
    }

    func setLatestDateString(str: String) {
        latestDateButton.value = str
    }

    func setStatesString(str: String) {
        statesButton.value = str
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
        headerView?.text = sectionTitle
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
        delegate?.userDidSelectSearchResult(row)
    }

    static let approachingCount = 5

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (rows.count > 0) && ((rows.count - indexPath.row) < SearchViewController.approachingCount) {
            delegate?.userIsApproachingLastRow(searchField.text, inCollection: rows)
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

            self?.delegate?.userDidChangeSearchToTerm(text)

            return true
        }

        searchField.shouldReturnHandler = { [weak self] in
            self?.delegate?.userDidTapReturn()
            return false
        }

        earliestDateButton.title = "Earliest Date"
        earliestDateButton.value = "--"

        latestDateButton.title = "Latest Date"
        latestDateButton.value = "--"

        statesButton.title = "States"
        statesButton.value = "(all states)"

        tableView.registerClass(TableHeaderView.self, forHeaderFooterViewReuseIdentifier: "Header")
        tableView.sectionHeaderHeight = 60.0
        tableView.rowHeight = 150.0

        view.addSubview(activityIndicator)

        activityIndicator.snp_makeConstraints { make in
            make.center.equalTo(view.snp_center)
        }

        delegate?.viewDidLoad()

        setViewState(.EmptySearchField)
    }

    // MARK: UIResponder overrides

    override func becomeFirstResponder() -> Bool {
        return searchField.becomeFirstResponder()
    }

    override func resignFirstResponder() -> Bool {
        return searchField.resignFirstResponder()
    }
}
