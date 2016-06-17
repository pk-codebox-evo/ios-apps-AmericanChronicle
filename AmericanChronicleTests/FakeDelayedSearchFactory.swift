@testable import AmericanChronicle

class FakeDelayedSearchFactory: DelayedSearchFactoryInterface {

    var newSearch_wasCalled_withParameters: SearchParameters?

    private(set) var newSearchForTerm_lastReturnedSearch: FakeDelayedSearch?

    func fetchMoreResults(parameters: SearchParameters, callback: ((SearchResults?, ErrorType?) -> ())) -> DelayedSearchInterface? {
        newSearch_wasCalled_withParameters = parameters
        newSearchForTerm_lastReturnedSearch = FakeDelayedSearch(parameters: parameters,
                                                                dataManager: FakeSearchDataManager(),
                                                                runLoop: FakeRunLoop(),
                                                                completionHandler: callback)
        return newSearchForTerm_lastReturnedSearch
    }

    init() {}
}
