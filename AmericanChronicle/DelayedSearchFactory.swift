// mark: -
// mark: DelayedSearchFactoryInterface protocol

protocol DelayedSearchFactoryInterface {
    func fetchMoreResults(_ parameters: SearchParameters,
                          callback: @escaping ((SearchResults?, Error?) -> ())) -> DelayedSearchInterface?
}

// mark: -
// mark: DelayedSearchFactory class

struct DelayedSearchFactory: DelayedSearchFactoryInterface {

    let dataManager: SearchDataManagerInterface
    init(dataManager: SearchDataManagerInterface = SearchDataManager()) {
        self.dataManager = dataManager
    }

    func fetchMoreResults(_ parameters: SearchParameters,
                          callback: @escaping ((SearchResults?, Error?) -> ()))
        -> DelayedSearchInterface? {
            return DelayedSearch(parameters: parameters,
                                 dataManager: dataManager,
                                 runLoop: RunLoop.main,
                                 completionHandler: callback)
    }
}
