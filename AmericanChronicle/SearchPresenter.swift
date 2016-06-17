// MARK: -
// MARK: SearchPresenterInterface protocol

protocol SearchPresenterInterface: SearchUserInterfaceDelegate, SearchInteractorDelegate {
    var wireframe: SearchWireframeInterface? { get set }

    func configureUserInterfaceForPresentation(userInterface: SearchUserInterface)
    func userDidSaveFilteredUSStateNames(stateNames: [String])
    func userDidSaveDayMonthYear(dayMonthYear: DayMonthYear)
}

// MARK: -
// MARK: SearchPresenter class

final class SearchPresenter: NSObject, SearchPresenterInterface {

    // MARK: Types

    private enum DateType {
        case Earliest
        case Latest
        case None
    }

    // MARK: Properties

    weak var wireframe: SearchWireframeInterface?

    private let interactor: SearchInteractorInterface
    private let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter
    }()
    private var userInterface: SearchUserInterface?
    private var term: String?
    private var usStateNames: [String] = []
    private var earliestDayMonthYear = Search.earliestPossibleDayMonthYear
    private var latestDayMonthYear = Search.latestPossibleDayMonthYear
    private var typeBeingEdited = DateType.None

    // MARK: Init methods

    init(interactor: SearchInteractorInterface = SearchInteractor()) {
        self.interactor = interactor
        super.init()
        self.interactor.delegate = self
        KeyboardService.sharedInstance.addFrameChangeHandler("\(unsafeAddressOf(self))") {
            [weak self] rect in
            self?.updateViewForKeyboardFrame(rect)
        }
    }

    // MARK: SearchPresenterInterface methods

    func configureUserInterfaceForPresentation(userInterface: SearchUserInterface) {
        self.userInterface = userInterface
        updateViewForKeyboardFrame(KeyboardService.sharedInstance.keyboardFrame)
        userInterface.earliestDate = earliestDayMonthYear.userVisibleString
        userInterface.latestDate = latestDayMonthYear.userVisibleString
    }

    func userDidSaveFilteredUSStateNames(stateNames: [String]) {
        usStateNames = stateNames.sort()
        let str: String
        if usStateNames.isEmpty {
            str = "All US states"
        } else if usStateNames.count <= 3 {
            str = usStateNames.joinWithSeparator(", ")
        } else {
            str = "\(usStateNames[0..<3].joinWithSeparator(", ")) (and \(usStateNames.count - 3) more)"
        }
        userInterface?.usStateNames = str
        searchIfReady()
    }

    func userDidSaveDayMonthYear(dayMonthYear: DayMonthYear) {
        switch typeBeingEdited {
        case .Earliest:
            earliestDayMonthYear = dayMonthYear
            userInterface?.earliestDate = earliestDayMonthYear.userVisibleString
            searchIfReady()
        case .Latest:
            latestDayMonthYear = dayMonthYear
            userInterface?.latestDate = latestDayMonthYear.userVisibleString
            searchIfReady()
        case .None:
            break
        }
    }

    // MARK: SearchUserInterfaceDelegate methods

    func userDidTapReturn() {
        userInterface?.resignFirstResponder()
    }

    func userDidTapUSStates() {
        wireframe?.showUSStatesPicker(usStateNames)
    }

    func userDidTapEarliestDateButton() {
        typeBeingEdited = .Earliest
        wireframe?.showDayMonthYearPickerWithCurrentDayMonthYear(earliestDayMonthYear,
                                                                 title: "Earliest Date")
    }

    func userDidTapLatestDateButton() {
        typeBeingEdited = .Latest
        wireframe?.showDayMonthYearPickerWithCurrentDayMonthYear(latestDayMonthYear,
                                                                 title: "Latest Date")
    }

    func userDidChangeSearchToTerm(term: String?) {
        self.term = term
        if term?.characters.count == 0 {
            userInterface?.setViewState(.EmptySearchField)
            interactor.cancelLastSearch()
            return
        }
        searchIfReady()
    }

    func userIsApproachingLastRow(term: String?, inCollection collection: [SearchResultsRow]) {
        guard term?.characters.count > 0 else { return }
        searchIfReady(.LoadingMoreRows)
    }

    func userDidSelectSearchResult(row: SearchResultsRow) {
        wireframe?.showSearchResult(row, forTerm: userInterface?.searchTerm ?? "")
    }

    func viewDidLoad() {
        updateViewForKeyboardFrame(KeyboardService.sharedInstance.keyboardFrame)
    }

    // MARK: SearchInteractorDelegate methods

    func search(parameters: SearchParameters,
                didFinishWithResults results: SearchResults?,
                error: NSError?) {
        if let results = results, items = results.items {
            let rows = rowsForSearchResultItems(items)
            if rows.count > 0 {
                let title = "\(results.totalItems ?? 0) matches"
                userInterface?.setViewState(.Ideal(title: title, rows: rows))
            } else {
                userInterface?.setViewState(.EmptyResults)
            }
        } else if let err = error {
            guard !err.isCancelledRequestError() else { return }
            guard !err.isDuplicateRequestError() else { return }
            guard !err.isAllItemsLoadedError() else { return }
            userInterface?.setViewState(.Error(title: err.localizedDescription,
                                               message: err.localizedRecoverySuggestion))
        } else {
            userInterface?.setViewState(.EmptyResults)
        }
    }

    // MARK: Private methods

    private func updateViewForKeyboardFrame(rect: CGRect?) {
        userInterface?.setBottomContentInset(rect?.size.height ?? 0)
    }

    private func rowsForSearchResultItems(items: [SearchResult]) -> [SearchResultsRow] {
        var rows: [SearchResultsRow] = []

        for result in items {
            let date = result.date
            var cityStateComponents: [String] = []

            if let city = result.city?.first {
                cityStateComponents.append(city)
            }
            if let state = result.state?.first {
                cityStateComponents.append(state)
            }

            var pubTitle = result.titleNormal ?? ""
            pubTitle = pubTitle.capitalizedString
            pubTitle = pubTitle.stringByReplacingOccurrencesOfString(".", withString: "")
            let row = SearchResultsRow(
                id: result.id,
                date: date,
                cityState: cityStateComponents.joinWithSeparator(", "),
                publicationTitle: pubTitle,
                thumbnailURL: result.thumbnailURL,
                pdfURL: result.pdfURL,
                lccn: result.lccn,
                edition: result.edition,
                sequence: result.sequence)
            rows.append(row)
        }

        return rows
    }

    private func searchIfReady(loadingViewState: SearchViewState = .LoadingNewParamaters) {
        if let term = term {
            userInterface?.setViewState(loadingViewState)
            let params = SearchParameters(term: term,
                                          states: usStateNames,
                                          earliestDayMonthYear: earliestDayMonthYear,
                                          latestDayMonthYear: latestDayMonthYear)
            interactor.fetchNextPageOfResults(params)
        }
    }

    // MARK: Deinit method

    deinit {
        KeyboardService.sharedInstance.removeFrameChangeHandler("\(unsafeAddressOf(self))")
    }
}
