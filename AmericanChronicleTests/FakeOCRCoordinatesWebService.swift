@testable import AmericanChronicle

class FakeOCRCoordinatesWebService: OCRCoordinatesWebServiceInterface {
    var startRequest_wasCalled_withID: String?
    var startRequest_wasCalled_withContextID: String?
    var startRequest_wasCalled_withCompletionHandler: ((OCRCoordinates?, Error?) -> Void)?

    func startRequest(_ id: String,
                      contextID: String,
                      completion: @escaping ((OCRCoordinates?, Error?) -> Void)) {
        startRequest_wasCalled_withID = id
        startRequest_wasCalled_withContextID = contextID
        startRequest_wasCalled_withCompletionHandler = completion
    }

    var stubbed_isRequestInProgress = false
    func isRequestInProgressWith(pageID: String, contextID: String) -> Bool {
        return stubbed_isRequestInProgress
    }
}
