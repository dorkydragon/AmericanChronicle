@testable import AmericanChronicle
import XCTest

class SearchDataManagerTests: XCTestCase {

    var webService: FakeSearchPagesWebService!
    var cacheService: FakeSearchPagesCacheService!
    var subject: SearchDataManager!

    // mark: Setup and Teardown

    override func setUp() {
        super.setUp()
        webService = FakeSearchPagesWebService()
        cacheService = FakeSearchPagesCacheService()
        subject = SearchDataManager(webService: webService, cacheService: cacheService)
    }

    // mark: Tests

    func testThat_whenFetchMoreResultsIsCalled_itStartsAServiceSearch_withTheSameParameters() {

        // when

        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
            latestDayMonthYear: Search.latestPossibleDayMonthYear
        )
        subject.fetchMoreResults(params, completion: { _, _ in })

        // then

        XCTAssertEqual(webService.startSearch_wasCalled_withParameters, params)
    }

    func testThat_whenFetchMoreResultsIsCalled_andNoResultsHaveBeenCached_itStartsAServiceSearch_forTheFirstPage() {

        // given

        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
            latestDayMonthYear: Search.latestPossibleDayMonthYear
        )
        cacheService.resultsForParameters_stubbedReturnValue = nil

        // when

        subject.fetchMoreResults(params, completion: { _, _ in })

        // then

        XCTAssertEqual(webService.startSearch_wasCalled_withPage, 1)
    }

    func testThat_whenFetchMoreResultsIsCalled_andResultsHaveBeenCached_andMorePagesAreAvailable_itStartsAServiceSearch_forTheNextPage() {

        // given

        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
            latestDayMonthYear: Search.latestPossibleDayMonthYear
        )
        cacheService.resultsForParameters_stubbedReturnValue = searchResultsWithItemCount(40, totalItemCount: 50)

        // when

        subject.fetchMoreResults(params, completion: { _, _ in })

        // then

        XCTAssertEqual(webService.startSearch_wasCalled_withPage, 3)
    }

    func testThat_whenFetchMoreResultsIsCalled_andResultsHaveBeenCached_andNoMorePagesAreAvailable_itFailsImmediately_withAnInvalidParameterError() {

        // given

        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
            latestDayMonthYear: Search.latestPossibleDayMonthYear
        )
        cacheService.resultsForParameters_stubbedReturnValue = searchResultsWithItemCount(50, totalItemCount: 50)

        // when

        var returnedError: NSError?
        subject.fetchMoreResults(params, completion: { _, error in
            returnedError = error
        })

        // then

        XCTAssert(returnedError!.isAllItemsLoadedError())
    }



    func testThat_whenFetchMoreResultsIsCalled_andResultsHaveBeenCached_andNoMorePagesAreAvailable_itDoesNotMakeARequest() {
        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
            latestDayMonthYear: Search.latestPossibleDayMonthYear
        )
        cacheService.resultsForParameters_stubbedReturnValue = searchResultsWithItemCount(50, totalItemCount: 50)
        subject.fetchMoreResults(params, completion: { _, _ in })
        XCTAssertNil(webService.startSearch_wasCalled_withParameters)
    }

    func testThat_whenCancelFetchIsCalled_itCalls_cancelSearch_onTheWebService_withTheSameParameters() {
        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
            latestDayMonthYear: Search.latestPossibleDayMonthYear
        )
        subject.cancelFetch(params)
        XCTAssertEqual(webService.cancelSearch_wasCalled_withParameters, params)
    }

    func testThat_whenCancelFetchIsCalled_andNoResultsAreCached_itCancelsTheWebServiceRequest_forTheFirstPage() {
        cacheService.resultsForParameters_stubbedReturnValue = nil
        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
            latestDayMonthYear: Search.latestPossibleDayMonthYear
        )
        subject.cancelFetch(params)
        XCTAssertEqual(webService.cancelSearch_wasCalled_withPage, 1)
    }

    func testThat_whenCancelFetchIsCalled_andResultsAreCached_itCancelsTheWebServiceRequest_forTheNextPage() {
        cacheService.resultsForParameters_stubbedReturnValue = searchResultsWithItemCount(40, totalItemCount: 50)
        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
            latestDayMonthYear: Search.latestPossibleDayMonthYear
        )

        subject.cancelFetch(params)
        XCTAssertEqual(webService.cancelSearch_wasCalled_withPage, 3)
    }

    func testThat_whenIsFetchInProgressIsCalled_itCalls_isSearchInProgress_onTheService_withTheSameParameters() {
        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
            latestDayMonthYear: Search.latestPossibleDayMonthYear
        )
        _ = subject.isFetchInProgress(params)
        XCTAssertEqual(webService.isSearchInProgress_wasCalled_withParameters, params)
    }

    func testThat_whenIsFetchInProgressIsCalled_andNoResultsAreCached_itCalls_isSearchInProgress_onTheService_withTheFirstPage() {
        cacheService.resultsForParameters_stubbedReturnValue = nil
        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
            latestDayMonthYear: Search.latestPossibleDayMonthYear
        )
        _ = subject.isFetchInProgress(params)
        XCTAssertEqual(webService.isSearchInProgress_wasCalled_withPage, 1)
    }

    func testThat_whenIsFetchInProgressIsCalled_andResultsAreCached_itCalls_isSearchInProgress_onTheService_withTheNextPage() {
        cacheService.resultsForParameters_stubbedReturnValue = searchResultsWithItemCount(40, totalItemCount: 50)
        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
            latestDayMonthYear: Search.latestPossibleDayMonthYear
        )
        _ = subject.isFetchInProgress(params)
        XCTAssertEqual(webService.isSearchInProgress_wasCalled_withPage, 3)
    }

    func testThat_whenIsFetchInProgressIsCalled_itReturnsTheValueReturnedByCalling_isSearchInProgress_onTheService() {
        webService.isSearchInProgress_mock_returnValue = true
        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
            latestDayMonthYear: Search.latestPossibleDayMonthYear
        )
        XCTAssert(subject.isFetchInProgress(params))
    }

    func testThat_whenASearchSucceeds_itCallsTheAssociatedCompletionHandler_withTheSearchResults() {
        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
            latestDayMonthYear: Search.latestPossibleDayMonthYear
        )
        var searchResults: SearchResults?
        subject.fetchMoreResults(params, completion: { results, _ in
            searchResults = results
        })
        let mockResults = SearchResults()
        webService.startSearch_wasCalled_withCompletionHandler?(mockResults, nil)
        XCTAssertEqual(searchResults, mockResults)
    }

    func testThat_whenASearchFails_itCallsTheAssociatedCompletionHandler_withTheError() {
        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
            latestDayMonthYear: Search.latestPossibleDayMonthYear
        )
        var searchError: NSError?
        subject.fetchMoreResults(params, completion: { _, error in
            searchError = error
        })
        let mockError = NSError(domain: "", code: 0, userInfo: nil)
        webService.startSearch_wasCalled_withCompletionHandler?(nil, mockError)
        XCTAssertEqual(searchError, mockError)
    }

    // Helpers

    func searchResultsWithItemCount(_ itemCount: Int, totalItemCount: Int) -> SearchResults {
        let results = SearchResults()
        results.totalItems = totalItemCount
        results.itemsPerPage = 20
        results.items = (0..<itemCount).map { _ in SearchResult() }
        return results
    }
}
