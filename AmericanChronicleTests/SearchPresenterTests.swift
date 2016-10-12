import XCTest
@testable import AmericanChronicle

class SearchPresenterTests: XCTestCase {

    var subject: SearchPresenter!

    var wireframe: SearchWireframe!
    var userInterface: FakeSearchView!
    var interactor: FakeSearchInteractor!

    override func setUp() {
        super.setUp()
        wireframe = SearchWireframe()
        userInterface = FakeSearchView()
        interactor = FakeSearchInteractor()

        subject = SearchPresenter(interactor: interactor)
        subject.wireframe = wireframe
        subject.configure(userInterface: userInterface)
    }

    func testThat_whenTheSearchTermChanges_andTheNewTermIsNotEmpty_itAsksTheViewToShowItsLoadingIndicator() {
        subject.userDidChangeSearch(to: "Blah")
        XCTAssertEqual(userInterface.setViewState_wasCalled_withState, SearchViewState.loadingNewParamaters)
    }

    func testThat_whenTheSearchTermChanges_andTheNewTermIsNotEmpty_itStartsANewSearch_withTheCorrectTerm() {
        subject.userDidChangeSearch(to: "Blah")
        XCTAssertEqual(interactor.fetchNextPageOfResults_wasCalled_withParameters?.term, "Blah")
    }

    func testThat_whenTheSearchTermChanges_andTheNewTermIsEmpty_itDoesNotStartASearch() {
        subject.userDidChangeSearch(to: "")
        XCTAssertNil(interactor.fetchNextPageOfResults_wasCalled_withParameters)
    }

    func testThat_whenTheSearchTermChanges_andTheNewTermIsEmpty_itAsksTheViewToShowEmptySearchField() {
        subject.userDidChangeSearch(to: "")
        XCTAssertEqual(userInterface.setViewState_wasCalled_withState, SearchViewState.emptySearchField)
    }

    func testThat_whenTheSearchTermChanges_andTheNewTermIsEmpty_itCancelsTheActiveSearch() {
        subject.userDidChangeSearch(to: "")
        XCTAssert(interactor.cancelLastSearch_wasCalled)
    }

    func testThat_whenASearchFinishes_andTheInteractorHasNoWork_itAsksTheViewToShowResults() {
        interactor.fake_isSearchInProgress = false
        subject.searchFor(SearchParameters(term: "",
            states: [],
            earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
            latestDayMonthYear: Search.latestPossibleDayMonthYear),
                       didFinishWithResults: nil,
                       error: nil)
        XCTAssertEqual(userInterface.setViewState_wasCalled_withState, SearchViewState.emptyResults)
    }

    func testThat_whenASearchSucceeds_andThereIsAtLeastOneResult_itAsksTheViewToShowTheResults() {
        let results = SearchResults()
        results.items = [SearchResult()]

        subject.searchFor(SearchParameters(term: "Blah",
            states: [],
            earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
            latestDayMonthYear: Search.latestPossibleDayMonthYear),
                       didFinishWithResults: results,
                       error: nil)

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
        let results = SearchResults()
        results.items = []
        let params = SearchParameters(term: "",
                                      states: [],
                                      earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                      latestDayMonthYear: Search.latestPossibleDayMonthYear)
        subject.searchFor(params, didFinishWithResults: results, error: nil)
        XCTAssertEqual(userInterface.setViewState_wasCalled_withState, SearchViewState.emptyResults)
    }

    func testThat_whenASearchFails_itAsksTheViewToShowAnErrorMessage() {
        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: ""])
        let params = SearchParameters(term: "",
                                      states: [],
                                      earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                      latestDayMonthYear: Search.latestPossibleDayMonthYear)
        subject.searchFor(params, didFinishWithResults: nil, error: error)
        XCTAssertEqual(userInterface.setViewState_wasCalled_withState, SearchViewState.error(title: "", message: nil))
    }

}
