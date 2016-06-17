@testable import AmericanChronicle

class FakeCachedSearchResultsService: CachedSearchResultsServiceInterface {
    var resultsForParameters_stubbedReturnValue: SearchResults?
    func resultsForParameters(parameters: SearchParameters) -> SearchResults? {
        return resultsForParameters_stubbedReturnValue
    }
    func cacheResults(results: SearchResults, forParameters parameters: SearchParameters) {

    }
}
