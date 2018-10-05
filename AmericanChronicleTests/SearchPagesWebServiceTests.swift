import XCTest
import Alamofire
@testable import AmericanChronicle

class SearchPagesWebServiceTests: XCTestCase {

    private var subject: SearchPagesWebService!
    private var manager: FakeSessionManager!

    // MARK: Setup and Teardown

    override func setUp() {
        super.setUp()
        manager = FakeSessionManager()
        subject = SearchPagesWebService(manager: manager)
    }

    // MARK: Tests

    func testThat_whenStartSearchIsCalled_withAnEmptyTerm_itImmediatelyReturnsAnInvalidParameterError() {

        // when

        let params = SearchParameters(term: "",
                                      states: ["Alabama", "Colorado"],
                                      earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                      latestDayMonthYear: Search.latestPossibleDayMonthYear)
        var error: NSError?
        subject.startSearch(with: params, page: 3, contextID: "context") { _, err in
            error = err! as NSError
        }

        // then

        XCTAssert(error?.isInvalidParameterError() ?? false)
    }

    func testThat_whenStartSearchIsCalled_withAPageBelowOne_itImmediatelyReturnsAnInvalidParameterError() {

        // when

        let params = SearchParameters(term: "Jibberish",
                                      states: ["Alabama", "Colorado"],
                                      earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                      latestDayMonthYear: Search.latestPossibleDayMonthYear)
        var error: NSError?
        subject.startSearch(with: params, page: 0, contextID: "context") { _, err in
            error = err! as NSError
        }

        // then

        XCTAssert(error?.isInvalidParameterError() ?? false)
    }

    func testThat_whenStartSearchIsCalled_withADuplicateRequest_itImmediatelyReturnsADuplicateRequestError() {

        // given

        let params = SearchParameters(term: "Jibberish",
                                      states: ["Alabama", "Colorado"],
                                      earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                      latestDayMonthYear: Search.latestPossibleDayMonthYear)
        subject.startSearch(with: params, page: 2, contextID: "context") { _, _ in }

        // when

        var error: NSError?
        subject.startSearch(with: params, page: 2, contextID: "context") { _, err in
            error = err! as NSError
        }

        // then

        XCTAssert(error?.isDuplicateRequestError() ?? false)
    }

    func testThat_whenStartSearchIsCalled_withValidParameters_itStartsARequest_withTheCorrectTerm() {

        // when

        let params = SearchParameters(term: "tsunami wave",
                                      states: ["Alabama", "Colorado"],
                                      earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                      latestDayMonthYear: Search.latestPossibleDayMonthYear)
        subject.startSearch(with: params, page: 4, contextID: "context") { _, _ in }

        // then

        var resultString: String?
        do {
            resultString = try manager.beginRequest_wasCalled_withRequest?.asURLRequest().url?.absoluteString
        } catch {
            XCTFail("Error: \(error)")
        }
        XCTAssert(resultString?.contains("proxtext=tsunami+wave") ?? false)
    }

    func testThat_whenStartSearchIsCalled_withValidParameters_itStartsARequest_withTheCorrectStates() {

        // when

        let params = SearchParameters(term: "tsunami",
                                      states: ["New York", "Colorado"],
                                      earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                      latestDayMonthYear: Search.latestPossibleDayMonthYear)
        subject.startSearch(with: params, page: 4, contextID: "context") { _, _ in }

        // then

        var resultString: String?
        do {
            resultString = try manager.beginRequest_wasCalled_withRequest?.asURLRequest().url?.absoluteString
        } catch {
            XCTFail("Error: \(error)")
        }
        XCTAssert(resultString?.contains("state=New+York&state=Colorado") ?? false)
    }

    func testThat_whenStartSearchIsCalled_withValidParameters_itStartsARequest_withTheCorrectPage() {

        // when

        let params = SearchParameters(term: "Jibberish",
                                      states: ["Alabama", "Colorado"],
                                      earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                      latestDayMonthYear: Search.latestPossibleDayMonthYear)
        subject.startSearch(with: params, page: 4, contextID: "context") { _, _ in }

        // then

        switch manager.beginRequest_wasCalled_withRequest! {
        case .pagesSearch(_, let page):
            XCTAssertEqual(page, 4)
        default:
            XCTFail("Unexpected request type: \(String(describing: manager.beginRequest_wasCalled_withRequest)).")
        }
    }

    func testThat_whenASearchSucceeds_itCallsTheCompletionHandler_withTheSearchResults() {

        // given

        var returnedResults: SearchResults?
        let params = SearchParameters(term: "Jibberish",
                                      states: ["Alabama", "Colorado"],
                                      earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                      latestDayMonthYear: Search.latestPossibleDayMonthYear)
        subject.startSearch(with: params, page: 2, contextID: "context") { results, _ in
            returnedResults = results
        }
        let expectedResults = SearchResults()
        let result: Result<SearchResults> = .success(expectedResults)
        let response = DataResponse(request: nil, response: nil, data: nil, result: result)

        // when

        manager.stubbedReturnDataRequest.finishWithResponseObject(response)

        // then

        XCTAssertEqual(returnedResults, expectedResults)
    }

    func testThat_whenASearchFails_itCallsTheCompletionHandler_withTheError() {

        // given

        let params = SearchParameters(term: "Jibberish",
                                      states: ["Alabama", "Colorado"],
                                      earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                      latestDayMonthYear: Search.latestPossibleDayMonthYear)
        var returnedError: NSError?
        let request = FakeDataRequest()
        manager.stubbedReturnDataRequest = request
        subject.startSearch(with: params, page: 2, contextID: "context") { _, error in
            returnedError = error! as NSError
        }
        let expectedError = NSError(code: .invalidParameter, message: nil)
        let result: Result<SearchResults> = .failure(expectedError)
        let response = DataResponse(request: nil, response: nil, data: nil, result: result)

        // when

        request.finishWithResponseObject(response)

        // then

        XCTAssertEqual(returnedError, expectedError)
    }

    func testThat_byTheTimeTheCompletionHandlerIsCalled_theRequestIsNotInProgress() {

        // given

        var isInProgress = true
        let request = FakeDataRequest()
        let params = SearchParameters(term: "Jibberish",
                                      states: ["Alabama", "Colorado"],
                                      earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                      latestDayMonthYear: Search.latestPossibleDayMonthYear)
        manager.stubbedReturnDataRequest = request
        subject.startSearch(with: params, page: 2, contextID: "context") { _, _ in
            isInProgress = self.subject.isSearchInProgress(params, page: 2, contextID: "context")
        }
        let result: Result<SearchResults> = .failure(NSError(code: .duplicateRequest, message: nil))
        let response = DataResponse(request: nil, response: nil, data: nil, result: result)

        // when

        request.finishWithResponseObject(response)

        // then

        XCTAssertFalse(isInProgress)
    }

    func testThat_whenCancelSearchIsCalled_withParametersOfAnActiveRequest_itCancelsTheRequest() {

        // given

        let params = SearchParameters(term: "Jibberish",
                                      states: ["Alabama", "Colorado"],
                                      earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                      latestDayMonthYear: Search.latestPossibleDayMonthYear)
        subject.startSearch(with: params, page: 2, contextID: "context") { _, _ in }

        // when

        subject.cancelSearch(params, page: 2, contextID: "context")

        // then

        XCTAssert(manager.stubbedReturnDataRequest.cancel_wasCalled)
    }

    func testThat_whenCancelSearchIsCalled_withParametersThatDoNotMatchAnActiveRequest_itDoesNotCancelsTheActiveRequest() {

        // given

        let activeParams = SearchParameters(term: "Jibberish",
                                            states: ["Alabama", "Colorado"],
                                            earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                            latestDayMonthYear: Search.latestPossibleDayMonthYear)
        subject.startSearch(with: activeParams, page: 2, contextID: "context") { _, _ in }

        // when

        let inactiveParams = SearchParameters(term: "Jabberish",
                                              states: ["Alabama", "Colorado"],
                                              earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                              latestDayMonthYear: Search.latestPossibleDayMonthYear)
        subject.cancelSearch(inactiveParams, page: 2, contextID: "context")

        // then

        XCTAssertFalse(manager.stubbedReturnDataRequest.cancel_wasCalled)
    }

    func testThat_whenTheSpecifiedSearchIsActive_isSearchInProgress_returnsTrue() {

        // given

        let activeParams = SearchParameters(term: "Jibberish",
                                            states: ["Alabama", "Colorado"],
                                            earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                            latestDayMonthYear: Search.latestPossibleDayMonthYear)
        subject.startSearch(with: activeParams, page: 2, contextID: "context") { _, _ in }

        // then

        XCTAssert(subject.isSearchInProgress(activeParams, page: 2, contextID: "context"))
    }

    func testThat_whenTheSpecifiedSearchIsNotActive_isSearchInProgress_returnsFalse() {

        // given

        let activeParams = SearchParameters(term: "Jibberish",
                                            states: ["Alabama", "Colorado"],
                                            earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                            latestDayMonthYear: Search.latestPossibleDayMonthYear)
        subject.startSearch(with: activeParams, page: 2, contextID: "context") { _, _ in }
        let inactiveParams = SearchParameters(term: "Jibberish",
                                              states: ["Alabama"],
                                              earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                              latestDayMonthYear: Search.latestPossibleDayMonthYear)

        // then

        XCTAssertFalse(subject.isSearchInProgress(inactiveParams, page: 2, contextID: "context"))
    }
}
