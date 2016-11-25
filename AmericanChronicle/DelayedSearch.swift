// MARK: -
// MARK: DelayedSearchInterface protocol

protocol DelayedSearchInterface {
    var parameters: SearchParameters { get }
    init(parameters: SearchParameters,
         dataManager: SearchDataManagerInterface,
         runLoop: RunLoopInterface,
         completion: @escaping ((SearchResults?, Error?) -> ()))
    func cancel()
    func isSearchInProgress() -> Bool
}

// MARK: -
// MARK: DelayedSearch class

final class DelayedSearch: NSObject, DelayedSearchInterface {

    // MARK: Properties

    let parameters: SearchParameters
    fileprivate let dataManager: SearchDataManagerInterface
    fileprivate let completion: (SearchResults?, Error?) -> ()
    fileprivate var timer: Timer!

    // MARK: Init methods

    internal init(parameters: SearchParameters,
                  dataManager: SearchDataManagerInterface,
                  runLoop: RunLoopInterface,
                  completion: @escaping ((SearchResults?, Error?) -> ())) {
        self.parameters = parameters
        self.dataManager = dataManager
        self.completion = completion

        super.init()

        timer = Timer(timeInterval: 0.5,
                        target: self,
                        selector: #selector(timerDidFire(_:)),
                        userInfo: nil,
                        repeats: false)
        runLoop.add(timer!, forMode: RunLoopMode.defaultRunLoopMode)
    }

    // MARK: Internal methods

    func timerDidFire(_ sender: Timer) {
        dataManager.fetchMoreResults(parameters, completion: completion)
    }

    // MARK: DelayedSearchInterface methods

    func cancel() {
        if timer.isValid { // Request hasn't started yet
            timer.invalidate()
            let error = NSError(domain: "", code: -999, userInfo: nil)
            completion(nil, error)
        } else { // Request has started already.
            dataManager.cancelFetch(parameters) // Cancelling will trigger the completion.
        }
    }


    /// Returns the correct value by the time the completion handler is called.
    func isSearchInProgress() -> Bool {
        if timer.isValid {
            return true
        }
        return dataManager.isFetchInProgress(parameters)
    }
}
