import Alamofire

// mark: -
// mark: OCRCoordinatesServiceInterface

protocol OCRCoordinatesServiceInterface {
    func startRequest(_ id: String,
                      contextID: String,
                      completionHandler: @escaping ((OCRCoordinates?, Error?) -> Void))
    func isRequestInProgress(_ id: String, contextID: String) -> Bool
    func cancelRequest(_ id: String, contextID: String)
}

// mark: -
// mark: OCRCoordinatesService class

final class OCRCoordinatesService: OCRCoordinatesServiceInterface {


    fileprivate let manager: ManagerProtocol
    fileprivate var activeRequests: [String: DataRequestProtocol] = [:]
    fileprivate let queue = DispatchQueue(
                            label: "com.ryanipete.AmericanChronicle.OCRCoordinatesService",
                            attributes: [])

    init(manager: ManagerProtocol = SessionManager()) {
        self.manager = manager
    }

    internal func startRequest(_ id: String,
                               contextID: String,
                               completionHandler: @escaping ((OCRCoordinates?, Error?) -> Void)) {
        if id.characters.isEmpty {
            let error = NSError(code: .invalidParameter,
                                message: "Tried to fetch OCR info using an empty lccn.")
            completionHandler(nil, error)
            return
        }

        if isRequestInProgress(id, contextID: contextID) {
            let error = NSError(code: .duplicateRequest,
                                message: "Message tried to send a duplicate request.")
            completionHandler(nil, error)
            return
        }

        let URLString = URLStringForID(id)

        let request = self.manager.request(URLString, method: .get, parameters: nil).responseObj {
            (response: Alamofire.DataResponse<OCRCoordinates>) in
            self.queue.sync() {
                self.activeRequests[URLString] = nil
            }
            completionHandler(response.result.value, response.result.error)
        }

        (queue).sync {
            self.activeRequests[URLString] = request
        }
    }

    fileprivate func URLStringForID(_ id: String) -> String {
        return "\(ChroniclingAmericaEndpoint.baseURLString)\(id)coordinates"
    }

    func isRequestInProgress(_ id: String, contextID: String) -> Bool {
        return activeRequests[URLStringForID(id)] != nil
    }

    func cancelRequest(_ id: String, contextID: String) {

    }
}
