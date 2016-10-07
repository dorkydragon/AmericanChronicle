import Alamofire

// mark: -
// mark: SearchPagesWebServiceProtocol

protocol SearchPagesServiceInterface {
    func startSearch(_ parameters: SearchParameters,
                     page: Int,
                     contextID: String,
                     completionHandler: @escaping ((SearchResults?, Error?) -> Void))
    func isSearchInProgress(_ parameters: SearchParameters, page: Int, contextID: String) -> Bool
    func cancelSearch(_ parameters: SearchParameters, page: Int, contextID: String)
}

// mark: -
// mark: SearchPagesService

final class SearchPagesService: SearchPagesServiceInterface {


    // mark: Properties

    fileprivate let manager: ManagerProtocol
    fileprivate var activeRequests: [String: DataRequestProtocol] = [:]
    fileprivate let queue = DispatchQueue(label: "com.ryanipete.AmericanChronicle.SearchPagesService",
                              attributes: [])

    // mark: Init methods

    init(manager: ManagerProtocol = SessionManager()) {
        self.manager = manager
    }

    // mark: SearchPagesServiceInterface methods

    /**
        contextID allows cancels without worrying about cancelling another object's outstanding
        request for the same info.

        If a request for the same term/page/contextID combo is already active, the completionHandler
        is called immediately with an InvalidParameter error and no additional request is made.

        - Parameters:
            - term: must have a non-zero character count
            - page: must be 1 or greater
    */
    func startSearch(_ parameters: SearchParameters, page: Int, contextID: String, completionHandler: @escaping ((SearchResults?, Error?) -> Void)) {
        guard !parameters.term.characters.isEmpty else {
            let error = NSError(code: .invalidParameter,
                                message: "Tried to search for an empty term.")
            completionHandler(nil, error)
            return
        }

        guard page > 0 else {
            let error = NSError(code: .invalidParameter,
                                message: "Tried to search for an invalid page.")
            completionHandler(nil, error)
            return
        }

        guard !isSearchInProgress(parameters, page: page, contextID: contextID) else {
            let error = NSError(code: .duplicateRequest,
                                message: "Message tried to send a duplicate request.")
            completionHandler(nil, error)
            return
        }

        let earliestMonth = "\(parameters.earliestDayMonthYear.month)"
        let earliestDay = "\(parameters.earliestDayMonthYear.day)"
        let earliestYear = "\(parameters.earliestDayMonthYear.year)"
        let date1 = "\(earliestMonth)/\(earliestDay)/\(earliestYear)"

        let latestMonth = "\(parameters.latestDayMonthYear.month)"
        let latestDay = "\(parameters.latestDayMonthYear.day)"
        let latestYear = "\(parameters.latestDayMonthYear.year)"
        let date2 = "\(latestMonth)/\(latestDay)/\(latestYear)"

        let params: [String: AnyObject] = [
            "format": "json" as AnyObject,
            "rows": 20 as AnyObject,
            "page": page as AnyObject,
            "dateFilterType": "range" as AnyObject,
            "date1": date1 as AnyObject,
            "date2": date2 as AnyObject
        ]

        var URLString = ChroniclingAmericaEndpoint.PagesSearch.fullURLString ?? ""
        let term = parameters.term.replacingOccurrences(of: " ", with: "+")
        URLString.append("?proxtext=\(term)")
        if !parameters.states.isEmpty {
            let statesString = parameters.states.map { state in
                let formatted = state.replacingOccurrences(of: " ", with: "+")
                return "state=\(formatted)"
            }.joined(separator: "&")
            URLString.append("&\(statesString)")
        }

        let request = self.manager.request(URLString, method: .get, parameters: params)
            .responseObj {
                (response: DataResponse<SearchResults>) in
                self.queue.sync {
                    let key = self.key(forParameters: parameters, page: page, contextID: contextID)
                    self.activeRequests[key] = nil
                }
            completionHandler(response.result.value, response.result.error)
        }

        queue.sync {
            let key = self.key(forParameters: parameters, page: page, contextID: contextID)
            self.activeRequests[key] = request
        }
    }

    func cancelSearch(_ parameters: SearchParameters, page: Int, contextID: String) {
        var request: DataRequestProtocol? = nil
        queue.sync {
            let key = self.key(forParameters: parameters, page: page, contextID: contextID)
            request = self.activeRequests[key]
        }
        request?.cancel()
    }

    func isSearchInProgress(_ parameters: SearchParameters, page: Int, contextID: String) -> Bool {
        var isInProgress = false
        queue.sync {
            let key = self.key(forParameters: parameters, page: page, contextID: contextID)
            isInProgress = self.activeRequests[key] != nil
        }
        return isInProgress
    }

    // mark: Private methods

    fileprivate func key(forParameters parameters: SearchParameters,
                         page: Int,
                         contextID: String) -> String {
        var key = parameters.term
        key += "-"
        key += parameters.states.joined(separator: ".")
        key += "-"
        key += "\(page)"
        key += "-"
        key += contextID
        return key
    }
}
