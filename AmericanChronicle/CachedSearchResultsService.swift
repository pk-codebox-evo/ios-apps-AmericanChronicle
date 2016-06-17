protocol CachedSearchResultsServiceInterface {
    func resultsForParameters(parameters: SearchParameters) -> SearchResults?
    func cacheResults(results: SearchResults, forParameters parameters: SearchParameters)
}

final class CachedSearchResultsService: CachedSearchResultsServiceInterface {
    private var cachedResults: [SearchParameters: SearchResults] = [:]
    func resultsForParameters(parameters: SearchParameters) -> SearchResults? {
        return cachedResults[parameters]
    }

    func cacheResults(results: SearchResults, forParameters parameters: SearchParameters) {
        cachedResults[parameters] = results
    }
}
