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
    var searchTerm: String? { get set }
    var earliestDate: String? { get set }
    var latestDate: String? { get set }
    var USStates: String? { get set }

    func setViewState(state: ViewState)
    func setBottomContentInset(bottom: CGFloat)
    func resignFirstResponder() -> Bool
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

    var searchTerm: String? {
        get {
            return tableHeaderView.searchTerm
        }
        set {
            tableHeaderView.searchTerm = newValue
        }
    }

    var earliestDate: String? {
        get {
            return tableHeaderView.earliestDate
        }
        set {
            tableHeaderView.earliestDate = newValue
        }
    }

    var latestDate: String? {
        get {
            return tableHeaderView.latestDate
        }
        set {
            tableHeaderView.latestDate = newValue
        }
    }

    var USStates: String? {
        get { return tableHeaderView.USStates }
        set { tableHeaderView.USStates = newValue }
    }

    private static let approachingCount = 5

    private let emptyResultsView = EmptyResultsView()
    private let errorView = ErrorView()
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)

    private let tableView = UITableView()
    private var tableHeaderView = SearchTableHeaderView()
    private let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter
    }()

    private var sectionTitle = ""
    private var rows: [SearchResultsRow] = []

    // MARK: UIViewController Init methods

    @available(*, unavailable) required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not supported. Use designated initializer instead")
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Info", style: .Plain, target: self, action: "infoButtonTapped:")
    }

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
            emptyResultsView.alpha = 0
            errorView.alpha = 0
            sectionTitle = ""
            rows = []
            tableView.reloadData()
            tableView.tableFooterView?.alpha = 0
        case .EmptyResults:
            setLoadingIndicatorsVisible(false)
            emptyResultsView.alpha = 1.0
            emptyResultsView.title = "No results"
            errorView.alpha = 0
            sectionTitle = ""
            rows = []
            tableView.reloadData()
            tableView.tableFooterView?.alpha = 0
        case .LoadingNewParamaters:
            setLoadingIndicatorsVisible(true)
            emptyResultsView.alpha = 0
            errorView.alpha = 0
            sectionTitle = ""
            rows = []
            tableView.reloadData()
            tableView.tableFooterView?.alpha = 0
        case .LoadingMoreRows:
            setLoadingIndicatorsVisible(false)
            emptyResultsView.alpha = 0
            errorView.alpha = 0
            tableView.tableFooterView?.alpha = 1.0
        case let .Partial(title, rows):
            setLoadingIndicatorsVisible(false)
            emptyResultsView.alpha = 0
            errorView.alpha = 0
            sectionTitle = title
            if self.rows != rows {
                self.rows = rows
                tableView.reloadData()
            }
            tableView.tableFooterView?.alpha = 0
        case let .Ideal(title, rows):
            setLoadingIndicatorsVisible(false)
            emptyResultsView.alpha = 0
            errorView.alpha = 0
            sectionTitle = title
            if self.rows != rows {
                self.rows = rows
                tableView.reloadData()
            }
            tableView.tableFooterView?.alpha = 0
        case let .Error(title, message):
            setLoadingIndicatorsVisible(false)
            emptyResultsView.alpha = 0
            errorView.alpha = 1.0
            sectionTitle = ""
            rows = []
            tableView.reloadData()
            errorView.title = title
            errorView.message = message
            tableView.tableFooterView?.alpha = 0
        }
    }

    func infoButtonTapped(sender: UIBarButtonItem) {
        let vc = InfoViewController()
        vc.userDidDismiss = { [weak self] in
            self?.dismissViewControllerAnimated(true, completion: nil)
        }
        let nvc = UINavigationController(rootViewController: vc)
        presentViewController(nvc, animated: true, completion: nil)
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
        let pageCell = tableView.dequeueReusableCellWithIdentifier(_stdlib_getDemangledTypeName(SearchResultsPageCell)) as! SearchResultsPageCell
        let result = rows[indexPath.row]
        if let date = result.date {
            pageCell.date = dateFormatter.stringFromDate(date)
        } else {
            pageCell.date = ""
        }
        pageCell.cityState = result.cityState ?? ""
        pageCell.publicationTitle = result.publicationTitle ?? ""
        pageCell.thumbnailURL = result.thumbnailURL
        return pageCell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        tableHeaderView.resignFirstResponder()
        delegate?.userDidSelectSearchResult(rows[indexPath.row])
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard (rows.count > 0) else { return }
        guard ((rows.count - indexPath.row) < SearchViewController.approachingCount) else { return }

        delegate?.userIsApproachingLastRow(tableHeaderView.searchTerm, inCollection: rows)
    }

    // MARK: UIViewController overrides

    override func loadView() {
        view = UIView()

        loadTableView()
        loadTableHeaderView()
        loadErrorView()
        loadEmptyResultsView()
        loadActivityIndicator()

        setViewState(.EmptySearchField)

        delegate?.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBarHidden = false
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.tableHeaderView = tableHeaderView
    }

    // MARK: UIResponder overrides

    override func becomeFirstResponder() -> Bool {
        return tableHeaderView.becomeFirstResponder() ?? false
    }

    override func resignFirstResponder() -> Bool {
        return tableHeaderView.resignFirstResponder() ?? false
    }

    // MARK: Private methods

    private func loadTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(SearchResultsPageCell.self, forCellReuseIdentifier:  _stdlib_getDemangledTypeName(SearchResultsPageCell))
        tableView.registerClass(TableHeaderView.self, forHeaderFooterViewReuseIdentifier: "Header")
        tableView.sectionHeaderHeight = 24.0
        tableView.rowHeight = 150.0
        view.addSubview(tableView)
        tableView.snp_makeConstraints { make in
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
        }
    }

    private func loadTableHeaderView() {

        tableHeaderView.frame = CGRect(x: 0, y: 0, width: 0, height: tableHeaderView.intrinsicContentSize().height)

        tableHeaderView.shouldChangeCharactersHandler = { [weak self] original, range, replacement in
            var text = original
            if let range = original.rangeFromNSRange(range) {
                text.replaceRange(range, with: replacement)
            }

            self?.delegate?.userDidChangeSearchToTerm(text)

            return true
        }
        tableHeaderView.shouldReturnHandler = { [weak self] in
            self?.delegate?.userDidTapReturn()
            return false
        }
        tableHeaderView.earliestDateButtonTapHandler = { [weak self] _ in
            self?.delegate?.userDidTapEarliestDateButton()
        }
        tableHeaderView.latestDateButtonTapHandler = { [weak self] _ in
            self?.delegate?.userDidTapLatestDateButton()
        }
        tableHeaderView.USStatesButtonTapHandler = { [weak self] _ in
            self?.delegate?.userDidTapUSStates()
        }
    }

    private func loadErrorView() {
        view.addSubview(errorView)
        errorView.snp_makeConstraints { make in
            make.center.equalTo(self.view.snp_center)
        }
    }

    private func loadEmptyResultsView() {
        view.addSubview(emptyResultsView)
        emptyResultsView.snp_makeConstraints { make in
            make.center.equalTo(self.view.snp_center)
        }
    }

    private func loadActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.snp_makeConstraints { make in
            make.center.equalTo(view.snp_center).offset(CGPoint(x: 0, y: 90))
        }
    }

    private func setLoadingIndicatorsVisible(visible: Bool) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = visible
        if visible {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}
