import Alamofire

// mark: -
// mark: SearchPagesWebServiceProtocol

protocol SearchPagesWebServiceInterface {
    func startSearch(with parameters: SearchParameters,
                     page: Int,
                     contextID: String,
                     completion: @escaping ((SearchResults?, Error?) -> Void))
    func isSearchInProgress(_ parameters: SearchParameters, page: Int, contextID: String) -> Bool
    func cancelSearch(_ parameters: SearchParameters, page: Int, contextID: String)
}

// mark: -
// mark: SearchPagesWebService

final class SearchPagesWebService: SearchPagesWebServiceInterface {

    // mark: Properties

    fileprivate let manager: SessionManagerProtocol
    fileprivate var activeRequests: [String: DataRequestProtocol] = [:]
    fileprivate let queue = DispatchQueue(label: "com.ryanipete.AmericanChronicle.SearchPagesWebService",
                              attributes: [])

    // mark: Init methods

    init(manager: SessionManagerProtocol = SessionManager()) {
        self.manager = manager
    }

    // mark: SearchPagesWebServiceInterface methods

    /// contextID allows cancels without worrying about cancelling another object's outstanding
    /// request for the same info.
    ///
    /// If a request for the same term/page/contextID combo is already active, the completion
    /// is called immediately with an InvalidParameter error and no additional request is made.
    ///
    /// - Parameters:
    ///     - term: must have a non-zero character count
    ///     - page: must be 1 or greater
    func startSearch(with parameters: SearchParameters, page: Int, contextID: String, completion: @escaping ((SearchResults?, Error?) -> Void)) {
        guard !parameters.term.characters.isEmpty else {
            let error = NSError(code: .invalidParameter,
                                message: NSLocalizedString("Tried to search for an empty term.",
                                                           comment: "Tried to search for an empty term."))
            completion(nil, error)
            return
        }

        guard page > 0 else {
            let error = NSError(code: .invalidParameter,
                                message: NSLocalizedString("Tried to search for an invalid page.",
                                                           comment: "Tried to search for an invalid page."))
            completion(nil, error)
            return
        }

        guard !isSearchInProgress(parameters, page: page, contextID: contextID) else {
            let error = NSError(code: .duplicateRequest,
                                message: NSLocalizedString("Tried to send a duplicate request.",
                                                           comment: "Tried to send a duplicate request."))
            completion(nil, error)
            return
        }

        let routerRequest = Router.pagesSearch(params: parameters, page: page)
        let request = manager.beginRequest(routerRequest).responseObj {
            [weak self] (response: DataResponse<SearchResults>) in
            self?.queue.sync {
                guard let key = self?.key(forParameters: parameters, page: page) else { return }
                self?.activeRequests[key] = nil
            }
            completion(response.result.value, response.result.error)
        }

        queue.sync {
            let key = self.key(forParameters: parameters, page: page)
            self.activeRequests[key] = request
        }
    }

    func cancelSearch(_ parameters: SearchParameters, page: Int, contextID: String) {
        var request: DataRequestProtocol? = nil
        queue.sync {
            let key = self.key(forParameters: parameters, page: page)
            request = self.activeRequests[key]
        }
        request?.cancel()
    }

    func isSearchInProgress(_ parameters: SearchParameters, page: Int, contextID: String) -> Bool {
        var isInProgress = false
        queue.sync {
            let key = self.key(forParameters: parameters, page: page)
            isInProgress = self.activeRequests[key] != nil
        }
        return isInProgress
    }

    // mark: Private methods

    fileprivate func key(forParameters parameters: SearchParameters, page: Int) -> String {
        var key = parameters.term
        key += "-"
        key += parameters.states.joined(separator: ".")
        key += "-"
        key += "\(page)"
        return key
    }
}
