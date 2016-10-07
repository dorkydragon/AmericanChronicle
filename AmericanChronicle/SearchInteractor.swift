// mark: -
// mark: SearchInteractorInterface

protocol SearchInteractorInterface {
    var delegate: SearchInteractorDelegate? { get set }

    func fetchNextPageOfResults(_ parameters: SearchParameters)
    func isSearchInProgress() -> Bool
    func cancelLastSearch()
}

// mark: -
// mark: SearchInteractorDelegate

protocol SearchInteractorDelegate: class {
    func search(_ parameters: SearchParameters, didFinishWithResults: SearchResults?, error: NSError?)
}

// mark: -
// mark: SearchInteractor class

/// Responsibilities:
///  * Ensures that only one request is ongoing at a time.
final class SearchInteractor: SearchInteractorInterface {

    // mark: Properties

    weak var delegate: SearchInteractorDelegate?

    fileprivate let searchFactory: DelayedSearchFactoryInterface
    fileprivate var activeSearch: DelayedSearchInterface?

    // mark: Init methods

    init(searchFactory: DelayedSearchFactoryInterface = DelayedSearchFactory()) {
        self.searchFactory = searchFactory
    }

    // mark: SearchInteractorInterface methods

    func fetchNextPageOfResults(_ parameters: SearchParameters) {
        if parameters == activeSearch?.parameters {
            if isSearchInProgress() {
                // There is already a search in progress for these parameters.
                let msg = "Tried to start a search that is already ongoing. Taking no action."
                let error = NSError(code: .duplicateRequest,
                                    message: msg)
                self.delegate?.search(parameters, didFinishWithResults: nil, error: error)
                return
            }
        }
        // Calling cancel() on delayedSearch can sometimes trigger the completionHandler
        // synchronously, and the delegate might then call isSearchInProgress to see if
        // it can hide the progress indicator. Wait to start this chain of events until
        // the new delayedSearch has been created.
        let oldActiveSearch = activeSearch

        activeSearch = searchFactory.fetchMoreResults(parameters) { (results, error) in
            self.delegate?.search(parameters,
                                  didFinishWithResults: results,
                                  error: error as? NSError)
        }
        oldActiveSearch?.cancel()
    }

    func isSearchInProgress() -> Bool {
        return activeSearch?.isSearchInProgress() ?? false
    }

    func cancelLastSearch() {
        activeSearch?.cancel()
    }
}
