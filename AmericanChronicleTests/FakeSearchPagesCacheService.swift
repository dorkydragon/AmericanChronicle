@testable import AmericanChronicle

class FakeSearchPagesCacheService: SearchPagesCacheServiceInterface {
    var resultsForParameters_stubbedReturnValue: SearchResults?
    func resultsForParameters(_ parameters: SearchParameters) -> SearchResults? {
        return resultsForParameters_stubbedReturnValue
    }
    func cacheResults(_ results: SearchResults, forParameters parameters: SearchParameters) {

    }
}
