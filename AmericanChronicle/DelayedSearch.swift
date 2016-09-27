// mark: -
// mark: DelayedSearchInterface protocol

protocol DelayedSearchInterface {
    var parameters: SearchParameters { get }
    init(parameters: SearchParameters,
         dataManager: SearchDataManagerInterface,
         runLoop: RunLoopInterface,
         completionHandler: @escaping ((SearchResults?, Error?) -> ()))
    func cancel()
    func isSearchInProgress() -> Bool
}

// mark: -
// mark: DelayedSearch class

final class DelayedSearch: NSObject, DelayedSearchInterface {

    // mark: Properties

    let parameters: SearchParameters
    fileprivate let dataManager: SearchDataManagerInterface
    fileprivate let completionHandler: (SearchResults?, Error?) -> ()
    fileprivate var timer: Timer!

    // mark: Init methods

    internal init(parameters: SearchParameters,
                  dataManager: SearchDataManagerInterface,
                  runLoop: RunLoopInterface,
                  completionHandler: @escaping ((SearchResults?, Error?) -> ())) {
        self.parameters = parameters
        self.dataManager = dataManager
        self.completionHandler = completionHandler

        super.init()

        timer = Timer(timeInterval: 0.5,
                        target: self,
                        selector: #selector(timerDidFire(_:)),
                        userInfo: nil,
                        repeats: false)
        runLoop.add(timer!, forMode: RunLoopMode.defaultRunLoopMode)
    }

    // mark: Internal methods

    func timerDidFire(_ sender: Timer) {
        dataManager.fetchMoreResults(parameters, completionHandler: completionHandler)
    }

    // mark: DelayedSearchInterface methods

    func cancel() {
        if timer.isValid { // Request hasn't started yet
            timer.invalidate()
            let error = NSError(domain: "", code: -999, userInfo: nil)
            completionHandler(nil, error)
        } else { // Request has started already.
            dataManager.cancelFetch(parameters) // Cancelling will trigger the completionHandler.
        }
    }

    /**
        Returns the correct value by the time the completion handler is called.
    */
    func isSearchInProgress() -> Bool {
        if timer.isValid {
            return true
        }
        return dataManager.isFetchInProgress(parameters)
    }
}
