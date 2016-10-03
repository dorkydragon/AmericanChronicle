@testable import AmericanChronicle

class FakeCachedSearchResultsService: CachedSearchResultsServiceInterface {
    var resultsForParameters_stubbedReturnValue: SearchResults?
    func resultsForParameters(_ parameters: SearchParameters) -> SearchResults? {
        return resultsForParameters_stubbedReturnValue
    }
    func cacheResults(_ results: SearchResults, forParameters parameters: SearchParameters) {

    }
}
