// MARK: -
// MARK: DelayedSearchFactoryInterface protocol

protocol DelayedSearchFactoryInterface {
    func fetchMoreResults(_ parameters: SearchParameters,
                          completion: @escaping ((SearchResults?, Error?) -> Void)) -> DelayedSearchInterface?
}

// MARK: -
// MARK: DelayedSearchFactory class

struct DelayedSearchFactory: DelayedSearchFactoryInterface {

    let dataManager: SearchDataManagerInterface
    init(dataManager: SearchDataManagerInterface = SearchDataManager()) {
        self.dataManager = dataManager
    }

    func fetchMoreResults(_ parameters: SearchParameters,
                          completion: @escaping ((SearchResults?, Error?) -> Void))
        -> DelayedSearchInterface? {
            return DelayedSearch(parameters: parameters,
                                 dataManager: dataManager,
                                 runLoop: RunLoop.main,
                                 completion: completion)
    }
}
