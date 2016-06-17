// MARK: -
// MARK: DelayedSearchFactoryInterface protocol

protocol DelayedSearchFactoryInterface {
    func fetchMoreResults(parameters: SearchParameters,
                          callback: ((SearchResults?, ErrorType?) -> ())) -> DelayedSearchInterface?
}

// MARK: -
// MARK: DelayedSearchFactory class

struct DelayedSearchFactory: DelayedSearchFactoryInterface {

    let dataManager: SearchDataManagerInterface
    init(dataManager: SearchDataManagerInterface = SearchDataManager()) {
        self.dataManager = dataManager
    }

    func fetchMoreResults(parameters: SearchParameters,
                          callback: ((SearchResults?, ErrorType?) -> ()))
        -> DelayedSearchInterface? {
            return DelayedSearch(parameters: parameters,
                                 dataManager: dataManager,
                                 completionHandler: callback)
    }
}
