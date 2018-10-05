import XCTest
@testable import AmericanChronicle
import ObjectMapper
import Alamofire

class OCRCoordinatesWebServiceTests: XCTestCase {

    var subject: OCRCoordinatesWebService!
    var manager: FakeSessionManager!

    // MARK: Setup and Teardown

    override func setUp() {
        super.setUp()
        manager = FakeSessionManager()
        subject = OCRCoordinatesWebService(manager: manager)
    }

    // MARK: Tests

    func testThat_whenStartRequestIsCalled_withAnEmptyLCCN_itImmediatelyReturnsAnInvalidParameterError() {

        // when

        var error: NSError?
        subject.startRequest("", contextID: "") { _, err in
            error = err! as NSError
        }

        // then

        XCTAssert(error?.isInvalidParameterError() ?? false)
    }

    func testThat_whenStartRequestIsCalled_withTheCorrectParameters_itStartsARequest_withTheCorrectURL() {

        // when

        let id = "lccn/sn83045487/1913-02-20/ed-1/seq-18/"
        subject.startRequest(id, contextID: "fake-context") { _, _ in }

        // then

        var resultString: String?
        do {
            resultString = try manager.beginRequest_wasCalled_withRequest?.asURLRequest().url?.absoluteString
        } catch {
            XCTFail("Error: \(error)")
        }

        let expected = "http://chroniclingamerica.loc.gov/lccn/sn83045487/1913-02-20/ed-1/seq-18/coordinates"
        XCTAssertEqual(resultString, expected)
    }

    func testThat_whenStartRequestIsCalled_withADuplicateRequest_itImmediatelyReturnsADuplicateRequestError() {

        // given

        let id = "lccn/sn83045487/1913-02-20/ed-1/seq-18/"
        let contextID = "fake-context"
        subject.startRequest(id, contextID: contextID) { _, _ in }

        // when

        var error: NSError?
        subject.startRequest(id, contextID: contextID) { _, err in
            error = err! as NSError
        }

        // then

        XCTAssert(error?.isDuplicateRequestError() ?? false)
    }

    func testThat_whenARequestSucceeds_itCallsTheCompletionHandler_withTheCoordinates() {

        // given

        var returnedCoordinates: OCRCoordinates?
        subject.startRequest("lccn/sn83045487/1913-02-20/ed-1/seq-18/", contextID: "fake-context") { coordinates, _ in
            returnedCoordinates = coordinates
        }
        let expectedCoordinates = OCRCoordinates(map: Map(mappingType: .fromJSON, JSON: [:]))
        let result: Result<OCRCoordinates> = .success(expectedCoordinates!)
        let response = Alamofire.DataResponse(request: nil, response: nil, data: nil, result: result)

        // when

        manager.stubbedReturnDataRequest.finishWithResponseObject(response)

        // then

        XCTAssertEqual(returnedCoordinates, expectedCoordinates)
    }

    func testThat_whenARequestFails_itCallsTheCompletionHandler_withTheError() {

        // given

        var returnedError: NSError?
        subject.startRequest("lccn/sn83045487/1913-02-20/ed-1/seq-18/", contextID: "fake-context") { _, err in
            returnedError = err! as NSError
        }
        let expectedError = NSError(code: .invalidParameter, message: nil)
        let result: Result<OCRCoordinates> = .failure(expectedError)
        let response = Alamofire.DataResponse(request: nil, response: nil, data: nil, result: result)

        // when

        manager.stubbedReturnDataRequest.finishWithResponseObject(response)

        // then

        XCTAssertEqual(returnedError, expectedError)
    }

    func testThat_byTheTimeTheCompletionHandlerIsCalled_theRequestIsNotConsideredToBeInProgress() {

        // given

        var isInProgress = true
        let request = FakeDataRequest()
        manager.stubbedReturnDataRequest = request
        subject.startRequest("", contextID: "") { _, _ in
            isInProgress = self.subject.isRequestInProgressWith(pageID: "", contextID: "")
        }
        let result: Result<OCRCoordinates> = .failure(NSError(code: .duplicateRequest, message: nil))
        let response = DataResponse(request: nil, response: nil, data: nil, result: result)

        // when

        request.finishWithResponseObject(response)

        // then

        XCTAssertFalse(isInProgress)
    }
}
