import Alamofire

// mark: -
// mark: OCRCoordinatesServiceInterface

protocol OCRCoordinatesWebServiceInterface {
    func startRequest(_ id: String,
                      contextID: String,
                      completion: @escaping ((OCRCoordinates?, Error?) -> Void))
    func isRequestInProgressWith(pageID: String, contextID: String) -> Bool
}

struct OCRCoordinatesRequester {
    let contextID: ContextID
    let completion: (OCRCoordinates?, Error?) -> Void
}

// mark: -
// mark: ActiveOCRCoordinatesRequest

struct ActiveOCRCoordinatesRequest {
    let request: DownloadRequestProtocol
    var requesters: [ContextID: PageDownloadRequester]
}

// mark: -
// mark: OCRCoordinatesWebService class

final class OCRCoordinatesWebService: OCRCoordinatesWebServiceInterface {

    fileprivate let manager: SessionManagerProtocol
    fileprivate var activeRequests: [String: DataRequestProtocol] = [:]
    fileprivate let queue = DispatchQueue(
                            label: "com.ryanipete.AmericanChronicle.OCRCoordinatesWebService",
                            attributes: [])

    init(manager: SessionManagerProtocol = SessionManager()) {
        self.manager = manager
    }

    internal func startRequest(_ pageID: String,
                               contextID: String,
                               completion: @escaping ((OCRCoordinates?, Error?) -> Void)) {
        if pageID.characters.isEmpty {
            let error = NSError(code: .invalidParameter,
                                message: NSLocalizedString("Tried to fetch highlights info using an empty lccn.",
                                                           comment:"Tried to fetch highlights info using an empty lccn."))
            completion(nil, error)
            return
        }

        if isRequestInProgressWith(pageID: pageID, contextID: contextID) {
            let error = NSError(code: .duplicateRequest,
                                message: NSLocalizedString("Tried to send a duplicate request.",
                                                           comment: "Tried to send a duplicate request."))
            completion(nil, error)
            return
        }

        let signature = requestSignature(pageID: pageID, contextID: contextID)
        let routerRequest = Router.ocrCoordinates(pageID: pageID)
        let request = manager.beginRequest(routerRequest).responseObj {
            [weak self] (response: Alamofire.DataResponse<OCRCoordinates>) in
            self?.queue.sync() {
                self?.activeRequests[signature] = nil
            }
            completion(response.result.value, response.result.error)
        }
        queue.sync {
            self.activeRequests[signature] = request
        }
    }

    func isRequestInProgressWith(pageID: String, contextID: String) -> Bool {
        return activeRequests[requestSignature(pageID: pageID, contextID: contextID)] != nil
    }

    fileprivate func requestSignature(pageID: String, contextID: String) -> String {
        return "\(pageID)-\(contextID)"
    }
}
