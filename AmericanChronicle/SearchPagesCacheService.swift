protocol SearchPagesCacheServiceInterface {
    func resultsForParameters(_ parameters: SearchParameters) -> SearchResults?
    func cacheResults(_ results: SearchResults, forParameters parameters: SearchParameters)
}

final class SearchPagesCacheService: SearchPagesCacheServiceInterface {
    fileprivate var cachedResults: [SearchParameters: SearchResults] = [:]
    func resultsForParameters(_ parameters: SearchParameters) -> SearchResults? {
        return cachedResults[parameters]
    }

    func cacheResults(_ results: SearchResults, forParameters parameters: SearchParameters) {
        cachedResults[parameters] = results
    }
}
