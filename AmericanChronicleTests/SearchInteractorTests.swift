import XCTest
@testable import AmericanChronicle

class SearchInteractorTests: XCTestCase {

    var subject: SearchInteractor!
    var searchFactory: FakeDelayedSearchFactory!
    var delegate: FakeSearchInteractorDelegate!

    // MARK: Setup and Teardown

    override func setUp() {
        super.setUp()
        searchFactory = FakeDelayedSearchFactory()
        delegate = FakeSearchInteractorDelegate()
        subject = SearchInteractor(searchFactory: searchFactory)
        subject.delegate = delegate
    }

    // MARK: Tests

    // --- fetchNextPageOfResults(_:) --- //

    func testThat_whenFetchIsCalled_withNewParameters_itAsksTheDataManagerToStartASearchWithTheSameParameters() {

        // when

        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
            latestDayMonthYear: Search.latestPossibleDayMonthYear
        )
        subject.fetchNextPageOfResults(params)

        // then

        XCTAssertEqual(searchFactory.newSearch_wasCalled_withParameters, params)
    }

    func testThat_whenFetchIsCalled_withNewParameters_itCancelsTheLastSearch() {

        // given

        let firstParams = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
            latestDayMonthYear: Search.latestPossibleDayMonthYear
        )
        subject.fetchNextPageOfResults(firstParams)
        let firstSearch = searchFactory.newSearchForTerm_lastReturnedSearch

        // when

        let secondParams = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado", "New Mexico"],
            earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
            latestDayMonthYear: Search.latestPossibleDayMonthYear
        )
        subject.fetchNextPageOfResults(secondParams)

        // then

        XCTAssert(firstSearch?.cancel_wasCalled ?? false)
    }

    // * Duplicate parameters
    //    * First search still in progress

    func testThat_whenFetchIsCalled_withDuplicateParameters_andTheFirstSearchIsStillInProgress_itFailsImmediatelyWithADuplicateRequestError() {

        // given

        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
            latestDayMonthYear: Search.latestPossibleDayMonthYear
        )
        subject.fetchNextPageOfResults(params)
        let firstSearch = searchFactory.newSearchForTerm_lastReturnedSearch
        firstSearch?.isSearchInProgress_returnValue = true

        // when

        subject.fetchNextPageOfResults(params)

        // then

        XCTAssert(delegate.searchForTerm_didFinish_wasCalled_withError!.isDuplicateRequestError())
    }

    func testThat_whenFetchIsCalled_withDuplicateParameters_andTheFirstSearchIsStillInProgress_itDoesNotCancelTheLastSearch() {

        // given

        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
            latestDayMonthYear: Search.latestPossibleDayMonthYear
        )
        subject.fetchNextPageOfResults(params)
        let firstSearch = searchFactory.newSearchForTerm_lastReturnedSearch
        firstSearch?.isSearchInProgress_returnValue = true

        // when

        subject.fetchNextPageOfResults(params)

        // then

        XCTAssertFalse(firstSearch?.cancel_wasCalled ?? true)
    }

    // * Duplicate parameters
    //   * First search has already finished

    func testThat_whenFetchIsCalled_withDuplicateParameters_andTheFirstSearchHasFinished_itAsksTheDataManagerToStartASearchWithTheDuplicateTerm() {

        // given

        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
            latestDayMonthYear: Search.latestPossibleDayMonthYear
        )

        subject.fetchNextPageOfResults(params)
        let firstSearch = searchFactory.newSearchForTerm_lastReturnedSearch
        firstSearch?.cancel()
        searchFactory.newSearch_wasCalled_withParameters = nil

        // when

        subject.fetchNextPageOfResults(params)

        // then

        XCTAssertEqual(searchFactory.newSearch_wasCalled_withParameters, params)
    }

    // --- fetchNextPageOfResults(_:) -> (results, error) --- //

    func testThat_whenASearchSucceeds_itPassesTheResultsToItsDelegate() {

        // given

        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
            latestDayMonthYear: Search.latestPossibleDayMonthYear
        )

        subject.fetchNextPageOfResults(params)
        let results = SearchResults()

        // when

        searchFactory.newSearchForTerm_lastReturnedSearch?.finishRequestWithSearchResults(results, error: nil)

        // then

        XCTAssertEqual(delegate.searchForTerm_didFinish_wasCalled_withResults, results)
    }

    func testThat_whenASearchFails_itPassesTheErrorToItsDelegate() {

        // given

        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
            latestDayMonthYear: Search.latestPossibleDayMonthYear
        )

        subject.fetchNextPageOfResults(params)
        let error = NSError(code: .invalidParameter, message: nil)

        // when

        searchFactory.newSearchForTerm_lastReturnedSearch?.finishRequestWithSearchResults(nil, error: error)

        // then

        XCTAssertEqual(delegate.searchForTerm_didFinish_wasCalled_withError, error)
    }

    // --- isSearchInProgress() --- //

    func testThat_whenAskedWhetherASearchIsInProgress_itAsksTheActiveSearch() {

        // given

        let params = SearchParameters(term: "Jibberish",
                                      states: ["Alabama", "Colorado"],
                                      earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                      latestDayMonthYear: Search.latestPossibleDayMonthYear)
        subject.fetchNextPageOfResults(params)
        let search = searchFactory.newSearchForTerm_lastReturnedSearch

        // when

        _ = subject.isSearchInProgress()

        // then

        XCTAssert(search?.isSearchInProgress_wasCalled ?? false)
    }

    // --- cancelLastSearch() --- //

    func testThat_whenCancelLastSearchIsCalled_itCancelsTheActiveSearch() {

        // given

        let params = SearchParameters(term: "Jibberish",
                                      states: ["Alabama", "Colorado"],
                                      earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                      latestDayMonthYear: Search.latestPossibleDayMonthYear)
        subject.fetchNextPageOfResults(params)
        let search = searchFactory.newSearchForTerm_lastReturnedSearch

        // when

        subject.cancelLastSearch()

        // then

        XCTAssert(search?.cancel_wasCalled ?? false)
    }
}
