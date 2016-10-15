@testable import AmericanChronicle

class FakeDelayedSearchFactory: DelayedSearchFactoryInterface {

    var newSearch_wasCalled_withParameters: SearchParameters?

    fileprivate(set) var newSearchForTerm_lastReturnedSearch: FakeDelayedSearch?

    func fetchMoreResults(_ parameters: SearchParameters,
                          completion: @escaping ((SearchResults?, Error?) -> ())) -> DelayedSearchInterface? {
        newSearch_wasCalled_withParameters = parameters
        newSearchForTerm_lastReturnedSearch = FakeDelayedSearch(parameters: parameters,
                                                                dataManager: FakeSearchDataManager(),
                                                                runLoop: FakeRunLoop(),
                                                                completion: completion)
        return newSearchForTerm_lastReturnedSearch
    }

    init() {}
}
