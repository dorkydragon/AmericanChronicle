// MARK: -
// MARK: SearchWireframeInterface protocol

protocol SearchWireframeInterface: class {
    func showSearchResult(atRow: SearchResultsRow, forTerm: String)
    func showUSStatesPicker(withSelectedStates: [String])
    func showDayMonthYearPicker(withCurrentDayMonthYear: DayMonthYear?, title: String?)
}

// MARK: -
// MARK: SearchWireframe class

final class SearchWireframe: SearchWireframeInterface,
    DatePickerWireframeDelegate,
    USStatePickerWireframeDelegate,
    PageWireframeDelegate {

    // MARK: Properties

    fileprivate let presenter: SearchPresenterInterface
    fileprivate var presentedViewController: UIViewController?
    fileprivate var statePickerWireframe: USStatePickerWireframe?
    fileprivate var datePickerWireframe: DatePickerWireframe?
    fileprivate var pageWireframe: PageWireframeInterface?

    // MARK: Init methods

    init(presenter: SearchPresenterInterface = SearchPresenter()) {
        self.presenter = presenter
        self.presenter.wireframe = self
    }

    // MARK: Internal methods

    func beginAsRootFromWindow(_ window: UIWindow?) {
        let vc = SearchViewController()
        vc.delegate = presenter
        presenter.configure(userInterface: vc)

        let nvc = UINavigationController(rootViewController: vc)
        window?.rootViewController = nvc

        presentedViewController = nvc
    }

    // MARK: SearchWireframeInterface conformance

    func showSearchResult(atRow row: SearchResultsRow, forTerm term: String) {
        if let remoteURL = row.pdfURL, let id = row.id {
            pageWireframe = PageWireframe(delegate: self)
            pageWireframe?.present(from: presentedViewController,
                                   withSearchTerm: term,
                                   remoteURL: remoteURL,
                                   id: id)
        }
    }

    func showUSStatesPicker(withSelectedStates selectedStates: [String]) {
        statePickerWireframe = USStatePickerWireframe(delegate: self)
        statePickerWireframe?.present(from: presentedViewController,
                                      withSelectedStateNames: selectedStates)
    }

    func showDayMonthYearPicker(withCurrentDayMonthYear dayMonthYear: DayMonthYear?, title: String?) {
        datePickerWireframe = DatePickerWireframe(delegate: self)
        datePickerWireframe?.present(from: presentedViewController,
                                     withDayMonthYear: dayMonthYear,
                                     title: title)
    }

    // MARK: DatePickerWireframeDelegate conformance

    func datePickerWireframe(_ wireframe: DatePickerWireframe,
                             didSaveWithDayMonthYear dayMonthYear: DayMonthYear) {
        presenter.userDidSaveDayMonthYear(dayMonthYear)
    }

    func datePickerWireframeDidFinish(_ wireframe: DatePickerWireframe) {
        datePickerWireframe = nil
    }

    // MARK: USStatePickerWireframeDelegate conformance

    func usStatePickerWireframe(_ wireframe: USStatePickerWireframe,
                                didSaveFilteredUSStateNames stateNames: [String]) {
        presenter.userDidSaveFilteredUSStateNames(stateNames)
    }

    func usStatePickerWireframeDidFinish(_ wireframe: USStatePickerWireframe) {
        statePickerWireframe = nil
    }

    // MARK: PageWireframeDelegate conformance

    func pageWireframeDidFinish(_ wireframe: PageWireframeInterface) {
        pageWireframe = nil
    }
}
