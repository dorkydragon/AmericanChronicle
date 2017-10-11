import XCTest
@testable import AmericanChronicle

class DelayedSearchTests: XCTestCase {
    var subject: DelayedSearch!
    var runLoop: FakeRunLoop!
    var dataManager: FakeSearchDataManager!
    var completionHandlerExpectation: XCTestExpectation?
    var results: SearchResults?
    var error: NSError?

    // MARK: Setup and Teardown

    override func setUp() {
        super.setUp()
        runLoop = FakeRunLoop()
        dataManager = FakeSearchDataManager()

        let params = SearchParameters(term: "Jibberish",
                                      states: ["Alabama", "Colorado"],
                                      earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                      latestDayMonthYear: Search.latestPossibleDayMonthYear)
        subject = DelayedSearch(parameters: params, dataManager: dataManager, runLoop: runLoop, completion: { results, error in
            self.results = results
            self.error = error! as NSError
            self.completionHandlerExpectation?.fulfill()
        })
    }

    // MARK: Tests

    func testThat_itStartsItsTimerImmediately() {
        XCTAssert(runLoop.addTimer_wasCalled_withTimer?.isValid ?? false)
    }

    func testThat_beforeTheTimerHasFired_cancel_invalidatesTheTimer() {

        // when

        subject.cancel()

        // then

        XCTAssertFalse(runLoop.addTimer_wasCalled_withTimer?.isValid ?? true)
    }

    func testThat_beforeTheTimerHasFired_cancel_triggersTheCompletionHandler_withACancelledError() {

        // when

        subject.cancel()

        // then

        XCTAssertEqual(error?.code, -999)
    }

    func testThat_afterTheTimerHasFired_cancel_callsCancelOnTheDataManager() {

        // given

        runLoop.addTimer_wasCalled_withTimer?.fire()

        // when

        subject.cancel()

        // then

        XCTAssert(dataManager.cancelSearch_wasCalled)
    }

    func testThat_beforeTheTimerHasFired_isSearchInProgress_returnsTrue() {
        XCTAssert(subject.isSearchInProgress())
    }

    func testThat_afterTheTimerHasFired_isSearchInProgress_returnsTheValueReturnedByTheDataManager() {

        // given

        runLoop.addTimer_wasCalled_withTimer?.fire()

        // when

        dataManager.isSearchInProgress_stubbedReturnValue = true

        // then

        XCTAssert(subject.isSearchInProgress())

        // when

        dataManager.isSearchInProgress_stubbedReturnValue = false

        // then

        XCTAssertFalse(subject.isSearchInProgress())
    }

    func testThat_whenTheTimerFires_itStartsSearchOnTheDataManager_withTheCorrectParameters() {

        // when

        runLoop.addTimer_wasCalled_withTimer?.fire()
        let expectedParameters = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
            latestDayMonthYear: Search.latestPossibleDayMonthYear
        )

        // then

        XCTAssertEqual(dataManager.fetchMoreResults_wasCalled_withParameters, expectedParameters)
    }
}
