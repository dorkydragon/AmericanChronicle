// MARK: -
// MARK: SearchPresenterInterface protocol

protocol SearchPresenterInterface: SearchUserInterfaceDelegate, SearchInteractorDelegate {
    var wireframe: SearchWireframeInterface? { get set }
    func configure(userInterface: SearchUserInterface)
    func userDidSaveFilteredUSStateNames(_ stateNames: [String])
    func userDidSaveDayMonthYear(_ dayMonthYear: DayMonthYear)
}

// MARK: -
// MARK: SearchPresenter class

final class SearchPresenter: NSObject, SearchPresenterInterface {

    // MARK: Types

    fileprivate enum DateType {
        case earliest
        case latest
        case none
    }

    // MARK: Properties

    weak var wireframe: SearchWireframeInterface?

    fileprivate let interactor: SearchInteractorInterface
    fileprivate let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter
    }()
    fileprivate var userInterface: SearchUserInterface?
    fileprivate var term: String?
    fileprivate var usStateNames: [String] = []
    fileprivate var earliestDayMonthYear = Search.earliestPossibleDayMonthYear
    fileprivate var latestDayMonthYear = Search.latestPossibleDayMonthYear
    fileprivate var typeBeingEdited = DateType.none

    // MARK: Init methods

    init(interactor: SearchInteractorInterface = SearchInteractor()) {
        self.interactor = interactor
        super.init()
        self.interactor.delegate = self
        KeyboardService.sharedInstance.addFrameChangeHandler(id: "\(Unmanaged.passUnretained(self).toOpaque())") { [weak self] rect in
            self?.updateViewForKeyboardFrame(rect)
        }
    }

    // MARK: SearchPresenterInterface conformance

    func configure(userInterface: SearchUserInterface) {
        self.userInterface = userInterface
        updateViewForKeyboardFrame(KeyboardService.sharedInstance.keyboardFrame)
        userInterface.earliestDate = earliestDayMonthYear.userVisibleString
        userInterface.latestDate = latestDayMonthYear.userVisibleString
    }

    func userDidSaveFilteredUSStateNames(_ stateNames: [String]) {
        usStateNames = stateNames.sorted()
        let str: String
        if usStateNames.isEmpty {
            str = NSLocalizedString("All US states", comment: "All US states")
        } else if usStateNames.count <= 3 {
            str = usStateNames.joined(separator: ", ")
        } else {
            let andLocalized = NSLocalizedString("and", comment: "Usage: 'Arkansas ({{ and }} 3 more states) selected'")
            let moreLocalized = NSLocalizedString("more", comment: "Usage: 'Arkansas (and 3 {{ more }} states) selected'")
            str = "\(usStateNames[0..<3].joined(separator: ", ")) (\(andLocalized) \(usStateNames.count - 3) \(moreLocalized))"
        }
        userInterface?.usStateNames = str
        searchIfReady()
    }

    func userDidSaveDayMonthYear(_ dayMonthYear: DayMonthYear) {
        switch typeBeingEdited {
        case .earliest:
            earliestDayMonthYear = dayMonthYear
            userInterface?.earliestDate = earliestDayMonthYear.userVisibleString
            searchIfReady()
        case .latest:
            latestDayMonthYear = dayMonthYear
            userInterface?.latestDate = latestDayMonthYear.userVisibleString
            searchIfReady()
        case .none:
            break
        }
    }

    // MARK: SearchUserInterfaceDelegate conformance

    func userDidTapReturn() {
        _ = userInterface?.resignFirstResponder()
    }

    func userDidTapUSStates() {
        wireframe?.showUSStatesPicker(withSelectedStates: usStateNames)
    }

    func userDidTapEarliestDateButton() {
        typeBeingEdited = .earliest
        wireframe?.showDayMonthYearPicker(withCurrentDayMonthYear: earliestDayMonthYear,
                                          title: NSLocalizedString("Earliest Date", comment: "Earliest Date"))
    }

    func userDidTapLatestDateButton() {
        typeBeingEdited = .latest
        wireframe?.showDayMonthYearPicker(withCurrentDayMonthYear: latestDayMonthYear,
                                          title: NSLocalizedString("Latest Date", comment: "Latest Date"))
    }

    func userDidChangeSearch(to term: String?) {
        self.term = term
        if term?.characters.count == 0 {
            userInterface?.setViewState(.emptySearchField)
            interactor.cancelLastSearch()
            return
        }
        searchIfReady()
    }

    func userIsApproachingLastRow(for term: String?, inCollection collection: [SearchResultsRow]) {
        guard (term?.characters.count ?? 0) > 0 else { return }
        searchIfReady(.loadingMoreRows)
    }

    func userDidSelectSearchResult(_ row: SearchResultsRow) {
        wireframe?.showSearchResult(atRow: row, forTerm: userInterface?.searchTerm ?? "")
    }

    func viewDidLoad() {
        updateViewForKeyboardFrame(KeyboardService.sharedInstance.keyboardFrame)
    }

    // MARK: SearchInteractorDelegate conformance

    func search(for parameters: SearchParameters,
                didFinishWithResults results: SearchResults?,
                error: NSError?) {
        if let results = results, let items = results.items {
            let rows = rowsForSearchResultItems(items)
            if rows.count > 0 {
                let totalCount = results.totalItems ?? 0
                userInterface?.setViewState(.ideal(totalCount: totalCount, rows: rows))
            } else {
                userInterface?.setViewState(.emptyResults)
            }
        } else if let err = error {
            guard !err.isCancelledRequestError() else { return }
            guard !err.isDuplicateRequestError() else { return }
            guard !err.isAllItemsLoadedError() else { return }
            userInterface?.setViewState(.error(title: err.localizedDescription,
                                               message: err.localizedRecoverySuggestion))
        } else {
            userInterface?.setViewState(.emptyResults)
        }
    }

    // MARK: Private methods

    fileprivate func updateViewForKeyboardFrame(_ rect: CGRect?) {
        userInterface?.setBottomContentInset(rect?.size.height ?? 0)
    }

    fileprivate func rowsForSearchResultItems(_ items: [SearchResult]) -> [SearchResultsRow] {
        var rows: [SearchResultsRow] = []

        for result in items {
            let date = result.date
            var cityStateComponents: [String] = []

            if let city = result.city?.first {
                cityStateComponents.append(city)
            }
            if let state = result.state?.first {
                cityStateComponents.append(state)
            }

            var pubTitle = result.titleNormal ?? ""
            pubTitle = pubTitle.capitalized
            pubTitle = pubTitle.replacingOccurrences(of: ".", with: "")
            let row = SearchResultsRow(
                id: result.id,
                date: date,
                cityState: cityStateComponents.joined(separator: ", "),
                publicationTitle: pubTitle,
                thumbnailURL: result.thumbnailURL,
                pdfURL: result.pdfURL,
                lccn: result.lccn,
                edition: result.edition,
                sequence: result.sequence)
            rows.append(row)
        }

        return rows
    }

    fileprivate func searchIfReady(_ loadingViewState: SearchViewState = .loadingNewParamaters) {
        if let term = term {
            userInterface?.setViewState(loadingViewState)
            let params = SearchParameters(term: term,
                                          states: usStateNames,
                                          earliestDayMonthYear: earliestDayMonthYear,
                                          latestDayMonthYear: latestDayMonthYear)
            interactor.fetchNextPageOfResults(params)
        }
    }

    // MARK: Deinit method

    deinit {
        KeyboardService.sharedInstance.removeFrameChangeHandler(id: "\(Unmanaged.passUnretained(self).toOpaque())")
    }
}
