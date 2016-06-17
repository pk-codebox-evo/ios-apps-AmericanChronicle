// MARK: -
// MARK: SearchInteractorInterface

protocol SearchInteractorInterface {
    var delegate: SearchInteractorDelegate? { get set }

    func fetchNextPageOfResults(parameters: SearchParameters)
    func isSearchInProgress() -> Bool
    func cancelLastSearch()
}

// MARK: -
// MARK: SearchInteractorDelegate

protocol SearchInteractorDelegate: class {
    func search(parameters: SearchParameters, didFinishWithResults: SearchResults?, error: NSError?)
}

// MARK: -
// MARK: SearchInteractor class

// Responsibilities:
//  * Ensures that only one request is ongoing at a time.
final class SearchInteractor: SearchInteractorInterface {

    // MARK: Properties

    weak var delegate: SearchInteractorDelegate?

    private let searchFactory: DelayedSearchFactoryInterface
    private var activeSearch: DelayedSearchInterface?

    // MARK: Init methods

    init(searchFactory: DelayedSearchFactoryInterface = DelayedSearchFactory()) {
        self.searchFactory = searchFactory
    }

    // MARK: SearchInteractorInterface methods

    func fetchNextPageOfResults(parameters: SearchParameters) {
        if parameters == activeSearch?.parameters {
            if isSearchInProgress() {
                // There is already a search in progress for these parameters.
                let msg = "Tried to start a search that is already ongoing. Taking no action."
                let error = NSError(code: .DuplicateRequest,
                                    message: msg)
                self.delegate?.search(parameters, didFinishWithResults: nil, error: error)
                return
            }
        }
        // Calling cancel() on delayedSearch can sometimes trigger the completionHandler
        // synchronously, and the delegate might then call isSearchInProgress to see if
        // it can hide the progress indicator. Wait to start this chain of events until
        // the new delayedSearch has been created.
        let oldActiveSearch = activeSearch

        activeSearch = searchFactory.fetchMoreResults(parameters) { (results, error) in
            self.delegate?.search(parameters,
                                  didFinishWithResults: results,
                                  error: error as? NSError)
        }
        oldActiveSearch?.cancel()
    }

    func isSearchInProgress() -> Bool {
        return activeSearch?.isSearchInProgress() ?? false
    }

    func cancelLastSearch() {
        activeSearch?.cancel()
    }
}
