// mark: -
// mark: SearchDataManagerInterface

protocol SearchDataManagerInterface {
    func fetchMoreResults(_ parameters: SearchParameters,
                          completionHandler: @escaping ((SearchResults?, NSError?) -> Void))
    func cancelFetch(_ parameters: SearchParameters)
    func isFetchInProgress(_ parameters: SearchParameters) -> Bool
}

// mark: -
// mark: SearchDataManager

final class SearchDataManager: SearchDataManagerInterface {


    // mark: Properties

    let webService: SearchPagesServiceInterface
    let cacheService: CachedSearchResultsServiceInterface

    fileprivate var contextID: String { return "\(Unmanaged.passUnretained(self).toOpaque())" }

    // mark: Init methods

    init(webService: SearchPagesServiceInterface = SearchPagesService(),
         cacheService: CachedSearchResultsServiceInterface = CachedSearchResultsService()) {
        self.webService = webService
        self.cacheService = cacheService
    }

    // mark: SearchDataManagerInterface methods

    internal func fetchMoreResults(_ parameters: SearchParameters, completionHandler: @escaping ((SearchResults?, NSError?) -> Void)) {
        let page: Int
        if let cachedResults = cacheService.resultsForParameters(parameters) {
            guard !cachedResults.allItemsLoaded else {
                completionHandler(nil, NSError(code: .allItemsLoaded, message: nil))
                return
            }
            page = cachedResults.numLoadedPages + 1
        } else {
            page = 1
        }

        webService.startSearch(parameters,
                               page: page,
                               contextID: contextID,
                               completionHandler: { results, error in
            let allResults: SearchResults?
            if let results = results {
                if let cachedResults = self.cacheService.resultsForParameters(parameters) {
                    cachedResults.items?.append(contentsOf: results.items ?? [])
                    allResults = cachedResults
                } else {
                    allResults = results
                }
                self.cacheService.cacheResults(allResults!, forParameters: parameters)
            } else {
                allResults = nil
            }
            completionHandler(allResults, error as? NSError)
        })
    }

    func cancelFetch(_ parameters: SearchParameters) {
        let page: Int
        if let cachedResults = cacheService.resultsForParameters(parameters) {
            page = cachedResults.numLoadedPages + 1
        } else {
            page = 1
        }
        webService.cancelSearch(parameters, page: page, contextID: contextID)
    }

    func isFetchInProgress(_ parameters: SearchParameters) -> Bool {
        let page: Int
        if let cachedResults = cacheService.resultsForParameters(parameters) {
            page = cachedResults.numLoadedPages + 1
        } else {
            page = 1
        }
        return webService.isSearchInProgress(parameters, page: page, contextID: contextID)
    }
}
