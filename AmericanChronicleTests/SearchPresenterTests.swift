import XCTest
@testable import AmericanChronicle

class SearchPresenterTests: XCTestCase {

    var subject: SearchPresenter!

    var wireframe: SearchWireframe!
    var userInterface: FakeSearchView!
    var interactor: FakeSearchInteractor!

    override func setUp() {
        super.setUp()
        wireframe = SearchWireframe()
        userInterface = FakeSearchView()
        interactor = FakeSearchInteractor()

        subject = SearchPresenter(interactor: interactor)
        subject.wireframe = wireframe
        subject.configureUserInterfaceForPresentation(userInterface)
    }

    func testThat_whenTheSearchTermChanges_andTheNewTermIsNotEmpty_itAsksTheViewToShowItsLoadingIndicator() {
        subject.userDidChangeSearchToTerm("Blah")
        XCTAssertEqual(userInterface.setViewState_wasCalled_withState, SearchViewState.LoadingNewParamaters)
    }

    func testThat_whenTheSearchTermChanges_andTheNewTermIsNotEmpty_itStartsANewSearch_withTheCorrectTerm() {
        subject.userDidChangeSearchToTerm("Blah")
        XCTAssertEqual(interactor.fetchNextPageOfResults_wasCalled_withParameters?.term, "Blah")
    }

    func testThat_whenTheSearchTermChanges_andTheNewTermIsEmpty_itDoesNotStartASearch() {
        subject.userDidChangeSearchToTerm("")
        XCTAssertNil(interactor.fetchNextPageOfResults_wasCalled_withParameters)
    }

    func testThat_whenTheSearchTermChanges_andTheNewTermIsEmpty_itAsksTheViewToShowEmptySearchField() {
        subject.userDidChangeSearchToTerm("")
        XCTAssertEqual(userInterface.setViewState_wasCalled_withState, SearchViewState.EmptySearchField)
    }

    func testThat_whenTheSearchTermChanges_andTheNewTermIsEmpty_itCancelsTheActiveSearch() {
        subject.userDidChangeSearchToTerm("")
        XCTAssert(interactor.cancelLastSearch_wasCalled)
    }

    func testThat_whenASearchFinishes_andTheInteractorHasNoWork_itAsksTheViewToShowResults() {
        interactor.fake_isSearchInProgress = false
        subject.search(SearchParameters(term: "",
            states: [],
            earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
            latestDayMonthYear: Search.latestPossibleDayMonthYear),
                       didFinishWithResults: nil,
                       error: nil)
        XCTAssertEqual(userInterface.setViewState_wasCalled_withState, SearchViewState.EmptyResults)
    }

    func testThat_whenASearchSucceeds_andThereIsAtLeastOneResult_itAsksTheViewToShowTheResults() {
        let results = SearchResults()
        results.items = [SearchResult()]

        subject.search(SearchParameters(term: "Blah",
            states: [],
            earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
            latestDayMonthYear: Search.latestPossibleDayMonthYear),
                       didFinishWithResults: results,
                       error: nil)

        let row = SearchResultsRow(id: "",
                                   date: nil,
                                   cityState: "",
                                   publicationTitle: "",
                                   thumbnailURL: nil,
                                   pdfURL: nil,
                                   lccn: "",
                                   edition: 1,
                                   sequence: 18)

        XCTAssertEqual(userInterface.setViewState_wasCalled_withState, SearchViewState.Ideal(title: "0 matches", rows: [row]))
    }

    func testThat_whenASearchSucceeds_andThereAreNoResults_itAsksTheViewToShowItsEmptyResultsMessage() {
        let results = SearchResults()
        results.items = []
        let params = SearchParameters(term: "",
                                      states: [],
                                      earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                      latestDayMonthYear: Search.latestPossibleDayMonthYear)
        subject.search(params, didFinishWithResults: results, error: nil)
        XCTAssertEqual(userInterface.setViewState_wasCalled_withState, SearchViewState.EmptyResults)
    }

    func testThat_whenASearchFails_itAsksTheViewToShowAnErrorMessage() {
        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: ""])
        let params = SearchParameters(term: "",
                                      states: [],
                                      earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                      latestDayMonthYear: Search.latestPossibleDayMonthYear)
        subject.search(params, didFinishWithResults: nil, error: error)
        XCTAssertEqual(userInterface.setViewState_wasCalled_withState, SearchViewState.Error(title: "", message: nil))
    }

}
