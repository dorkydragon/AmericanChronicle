@testable import AmericanChronicle

class FakeOCRCoordinatesService: OCRCoordinatesServiceInterface {
    var startRequest_wasCalled_withID: String?
    var startRequest_wasCalled_withContextID: String?
    var startRequest_wasCalled_withCompletionHandler: ((OCRCoordinates?, Error?) -> Void)?

    func startRequest(_ id: String,
                      contextID: String,
                      completionHandler: @escaping ((OCRCoordinates?, Error?) -> Void)) {
        startRequest_wasCalled_withID = id
        startRequest_wasCalled_withContextID = contextID
        startRequest_wasCalled_withCompletionHandler = completionHandler
    }

    var cancelRequest_wasCalled_withID: String?
    var cancelRequest_wasCalled_withContextID: String?
    func cancelRequest(_ id: String, contextID: String) {
        cancelRequest_wasCalled_withID = id
        cancelRequest_wasCalled_withContextID = contextID
    }

    var stubbed_isRequestInProgress = false
    func isRequestInProgress(_ id: String, contextID: String) -> Bool {
        return stubbed_isRequestInProgress
    }
}
