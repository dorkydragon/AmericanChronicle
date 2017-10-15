// MARK: -
// MARK: SearchDataManagerInterface

protocol SearchDataManagerInterface {
    func fetchMoreResults(_ parameters: SearchParameters,
                          completion: @escaping ((SearchResults?, NSError?) -> Void))
    func cancelFetch(_ parameters: SearchParameters)
    func isFetchInProgress(_ parameters: SearchParameters) -> Bool
}

// MARK: -
// MARK: SearchDataManager

final class SearchDataManager: SearchDataManagerInterface {

    // MARK: Properties

    let webService: SearchPagesWebServiceInterface
    let cacheService: SearchPagesCacheServiceInterface

    fileprivate var contextID: String { return "\(Unmanaged.passUnretained(self).toOpaque())" }

    // MARK: Init methods

    init(webService: SearchPagesWebServiceInterface = SearchPagesWebService(),
         cacheService: SearchPagesCacheServiceInterface = SearchPagesCacheService()) {
        self.webService = webService
        self.cacheService = cacheService
    }

    // MARK: SearchDataManagerInterface methods

    internal func fetchMoreResults(_ parameters: SearchParameters, completion: @escaping ((SearchResults?, NSError?) -> Void)) {
        let page: Int
        if let cachedResults = cacheService.resultsForParameters(parameters) {
            guard !cachedResults.allItemsLoaded else {
                completion(nil, NSError(code: .allItemsLoaded, message: nil))
                return
            }
            page = cachedResults.numLoadedPages + 1
        } else {
            page = 1
        }

        webService.startSearch(with: parameters,
                               page: page,
                               contextID: contextID,
                               completion: { results, error in
            let allResults: SearchResults?
            if let freshResults = results {
                let resultsToCache: SearchResults
                if let cachedResults = self.cacheService.resultsForParameters(parameters) {
                    cachedResults.items?.append(contentsOf: freshResults.items ?? [])
                    resultsToCache = cachedResults
                } else {
                    resultsToCache = freshResults
                }
                allResults = resultsToCache
                self.cacheService.cacheResults(resultsToCache, forParameters: parameters)
            } else {
                allResults = nil
            }
            completion(allResults, error as NSError?)
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
