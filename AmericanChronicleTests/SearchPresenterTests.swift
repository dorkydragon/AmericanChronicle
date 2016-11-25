import XCTest
@testable import AmericanChronicle

class SearchPresenterTests: XCTestCase {

    var subject: SearchPresenter!

    var wireframe: SearchWireframe!
    var userInterface: FakeSearchView!
    var interactor: FakeSearchInteractor!

    // MARK: Setup and Teardown

    override func setUp() {
        super.setUp()
        wireframe = SearchWireframe()
        userInterface = FakeSearchView()
        interactor = FakeSearchInteractor()

        subject = SearchPresenter(interactor: interactor)
        subject.wireframe = wireframe
        subject.configure(userInterface: userInterface)
    }

    // MARK: Tests

    func testThat_whenTheSearchTermChanges_andTheNewTermIsNotEmpty_itAsksTheViewToShowItsLoadingIndicator() {

        // when

        subject.userDidChangeSearch(to: "Blah")

        // then

        XCTAssertEqual(userInterface.setViewState_wasCalled_withState, SearchViewState.loadingNewParamaters)
    }

    func testThat_whenTheSearchTermChanges_andTheNewTermIsNotEmpty_itStartsANewSearch_withTheCorrectTerm() {

        // when

        subject.userDidChangeSearch(to: "Blah")

        // then

        XCTAssertEqual(interactor.fetchNextPageOfResults_wasCalled_withParameters?.term, "Blah")
    }

    func testThat_whenTheSearchTermChanges_andTheNewTermIsEmpty_itDoesNotStartASearch() {

        // when

        subject.userDidChangeSearch(to: "")

        // then

        XCTAssertNil(interactor.fetchNextPageOfResults_wasCalled_withParameters)
    }

    func testThat_whenTheSearchTermChanges_andTheNewTermIsEmpty_itAsksTheViewToShowEmptySearchField() {

        // when

        subject.userDidChangeSearch(to: "")

        // then

        XCTAssertEqual(userInterface.setViewState_wasCalled_withState, SearchViewState.emptySearchField)
    }

    func testThat_whenTheSearchTermChanges_andTheNewTermIsEmpty_itCancelsTheActiveSearch() {

        // when

        subject.userDidChangeSearch(to: "")

        // then

        XCTAssert(interactor.cancelLastSearch_wasCalled)
    }

    func testThat_whenASearchFinishes_andTheInteractorHasNoWork_itAsksTheViewToShowResults() {

        // given

        interactor.fake_isSearchInProgress = false

        // when

        subject.search(for: SearchParameters(term: "",
            states: [],
            earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
            latestDayMonthYear: Search.latestPossibleDayMonthYear),
                       didFinishWithResults: nil,
                       error: nil)

        // then

        XCTAssertEqual(userInterface.setViewState_wasCalled_withState, SearchViewState.emptyResults)
    }

    func testThat_whenASearchSucceeds_andThereIsAtLeastOneResult_itAsksTheViewToShowTheResults() {

        // given

        let results = SearchResults()
        results.items = [SearchResult()]

        // when

        subject.search(for: SearchParameters(term: "Blah",
            states: [],
            earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
            latestDayMonthYear: Search.latestPossibleDayMonthYear),
                       didFinishWithResults: results,
                       error: nil)

        // then

        let row = SearchResultsRow(id: "",
                                   date: nil,
                                   cityState: "",
                                   publicationTitle: "",
                                   thumbnailURL: nil,
                                   pdfURL: nil,
                                   lccn: "",
                                   edition: 1,
                                   sequence: 18)

        XCTAssertEqual(userInterface.setViewState_wasCalled_withState, SearchViewState.ideal(totalCount: 0, rows: [row]))
    }

    func testThat_whenASearchSucceeds_andThereAreNoResults_itAsksTheViewToShowItsEmptyResultsMessage() {

        // given

        let results = SearchResults()
        results.items = []
        let params = SearchParameters(term: "",
                                      states: [],
                                      earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                      latestDayMonthYear: Search.latestPossibleDayMonthYear)

        // when

        subject.search(for: params, didFinishWithResults: results, error: nil)

        // then

        XCTAssertEqual(userInterface.setViewState_wasCalled_withState, SearchViewState.emptyResults)
    }

    func testThat_whenASearchFails_itAsksTheViewToShowAnErrorMessage() {

        // given

        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: ""])
        let params = SearchParameters(term: "",
                                      states: [],
                                      earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                      latestDayMonthYear: Search.latestPossibleDayMonthYear)

        // when

        subject.search(for: params, didFinishWithResults: nil, error: error)

        // then

        XCTAssertEqual(userInterface.setViewState_wasCalled_withState, SearchViewState.error(title: "", message: nil))
    }

}
