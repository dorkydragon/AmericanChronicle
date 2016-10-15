@testable import AmericanChronicle

class FakeDelayedSearch: DelayedSearchInterface {

    // mark: Properties

    var parameters: SearchParameters
    fileprivate let completion: ((SearchResults?, Error?) -> ())

    // mark: DelayedSearchInterface methods

    required init(parameters: SearchParameters,
                  dataManager: SearchDataManagerInterface,
                  runLoop: RunLoopInterface,
                  completion: @escaping ((SearchResults?, Error?) -> ())) {
        self.parameters = parameters
        self.completion = completion
    }

    var cancel_wasCalled = false
    func cancel() {
        cancel_wasCalled = true
    }

    var isSearchInProgress_wasCalled = false
    var isSearchInProgress_returnValue = false
    func isSearchInProgress() -> Bool {
        isSearchInProgress_wasCalled = true
        return isSearchInProgress_returnValue
    }

    func finishRequestWithSearchResults(_ results: SearchResults?, error: Error?) {
        completion(results, error)
    }
}
