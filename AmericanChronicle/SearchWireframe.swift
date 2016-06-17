// MARK: -
// MARK: SearchWireframeInterface protocol

protocol SearchWireframeInterface: class {
    func showSearchResult(row: SearchResultsRow, forTerm: String)
    func showUSStatesPicker(activeStates: [String])
    func showDayMonthYearPickerWithCurrentDayMonthYear(dayMonthYear: DayMonthYear?, title: String?)
}

// MARK: -
// MARK: SearchWireframe class

final class SearchWireframe: SearchWireframeInterface,
    DatePickerWireframeDelegate,
    USStatePickerWireframeDelegate,
    PageWireframeDelegate {

    // MARK: Properties

    private let presenter: SearchPresenterInterface
    private var presentedViewController: UIViewController?
    private var statePickerWireframe: USStatePickerWireframe?
    private var datePickerWireframe: DatePickerWireframe?
    private var pageWireframe: PageWireframe?

    // MARK: Init methods

    init(presenter: SearchPresenterInterface = SearchPresenter()) {
        self.presenter = presenter
        self.presenter.wireframe = self
    }

    // MARK: Internal methods

    func beginAsRootFromWindow(window: UIWindow?) {
        let vc = SearchViewController()
        vc.delegate = presenter
        presenter.configureUserInterfaceForPresentation(vc)

        let nvc = UINavigationController(rootViewController: vc)
        window?.rootViewController = nvc

        presentedViewController = nvc
    }

    // MARK: SearchWireframeInterface methods

    func showSearchResult(row: SearchResultsRow, forTerm term: String) {
        if let remoteURL = row.pdfURL, id = row.id {
            pageWireframe = PageWireframe(delegate: self)
            pageWireframe?.presentFromViewController(presentedViewController,
                                                     withSearchTerm: term,
                                                     remoteURL: remoteURL,
                                                     id: id)
        }
    }

    func showUSStatesPicker(selectedStates: [String]) {
        statePickerWireframe = USStatePickerWireframe(delegate: self)
        statePickerWireframe?.presentFromViewController(presentedViewController,
                                                        withSelectedStateNames: selectedStates)
    }

    func showDayMonthYearPickerWithCurrentDayMonthYear(dayMonthYear: DayMonthYear?,
                                                       title: String?) {
        datePickerWireframe = DatePickerWireframe(delegate: self)
        datePickerWireframe?.presentFromViewController(presentedViewController,
                                                       withDayMonthYear: dayMonthYear,
                                                       title: title)
    }

    // MARK: DatePickerWireframeDelegate methods

    func datePickerWireframe(wireframe: DatePickerWireframe,
                             didSaveWithDayMonthYear dayMonthYear: DayMonthYear) {
        presenter.userDidSaveDayMonthYear(dayMonthYear)
    }

    func datePickerWireframeDidFinish(wireframe: DatePickerWireframe) {
        datePickerWireframe = nil
    }

    // MARK: USStatePickerWireframeDelegate methods

    func usStatePickerWireframe(wireframe: USStatePickerWireframe,
                                didSaveFilteredUSStateNames stateNames: [String]) {
        presenter.userDidSaveFilteredUSStateNames(stateNames)
    }

    func usStatePickerWireframeDidFinish(wireframe: USStatePickerWireframe) {
        statePickerWireframe = nil
    }

    // MARK: PageWireframeDelegate methods

    func pageWireframeDidFinish(wireframe: PageWireframe) {
        pageWireframe = nil
    }
}
