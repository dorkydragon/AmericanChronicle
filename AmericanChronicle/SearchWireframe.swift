// mark: -
// mark: SearchWireframeInterface protocol

protocol SearchWireframeInterface: class {
    func showSearchResult(_ row: SearchResultsRow, forTerm: String)
    func showUSStatesPicker(_ activeStates: [String])
    func showDayMonthYearPickerWithCurrentDayMonthYear(_ dayMonthYear: DayMonthYear?, title: String?)
}

// mark: -
// mark: SearchWireframe class

final class SearchWireframe: SearchWireframeInterface,
    DatePickerWireframeDelegate,
    USStatePickerWireframeDelegate,
    PageWireframeDelegate {

    // mark: Properties

    fileprivate let presenter: SearchPresenterInterface
    fileprivate var presentedViewController: UIViewController?
    fileprivate var statePickerWireframe: USStatePickerWireframe?
    fileprivate var datePickerWireframe: DatePickerWireframe?
    fileprivate var pageWireframe: PageWireframe?

    // mark: Init methods

    init(presenter: SearchPresenterInterface = SearchPresenter()) {
        self.presenter = presenter
        self.presenter.wireframe = self
    }

    // mark: Internal methods

    func beginAsRootFromWindow(_ window: UIWindow?) {
        let vc = SearchViewController()
        vc.delegate = presenter
        presenter.configureUserInterfaceForPresentation(vc)

        let nvc = UINavigationController(rootViewController: vc)
        window?.rootViewController = nvc

        presentedViewController = nvc
    }

    // mark: SearchWireframeInterface methods

    func showSearchResult(_ row: SearchResultsRow, forTerm term: String) {
        if let remoteURL = row.pdfURL, let id = row.id {
            pageWireframe = PageWireframe(delegate: self)
            pageWireframe?.presentFromViewController(presentedViewController,
                                                     withSearchTerm: term,
                                                     remoteURL: remoteURL,
                                                     id: id)
        }
    }

    func showUSStatesPicker(_ selectedStates: [String]) {
        statePickerWireframe = USStatePickerWireframe(delegate: self)
        statePickerWireframe?.presentFromViewController(presentedViewController,
                                                        withSelectedStateNames: selectedStates)
    }

    func showDayMonthYearPickerWithCurrentDayMonthYear(_ dayMonthYear: DayMonthYear?,
                                                       title: String?) {
        datePickerWireframe = DatePickerWireframe(delegate: self)
        datePickerWireframe?.presentFromViewController(presentedViewController,
                                                       withDayMonthYear: dayMonthYear,
                                                       title: title)
    }

    // mark: DatePickerWireframeDelegate methods

    func datePickerWireframe(_ wireframe: DatePickerWireframe,
                             didSaveWithDayMonthYear dayMonthYear: DayMonthYear) {
        presenter.userDidSaveDayMonthYear(dayMonthYear)
    }

    func datePickerWireframeDidFinish(_ wireframe: DatePickerWireframe) {
        datePickerWireframe = nil
    }

    // mark: USStatePickerWireframeDelegate methods

    func usStatePickerWireframe(_ wireframe: USStatePickerWireframe,
                                didSaveFilteredUSStateNames stateNames: [String]) {
        presenter.userDidSaveFilteredUSStateNames(stateNames)
    }

    func usStatePickerWireframeDidFinish(_ wireframe: USStatePickerWireframe) {
        statePickerWireframe = nil
    }

    // mark: PageWireframeDelegate methods

    func pageWireframeDidFinish(_ wireframe: PageWireframe) {
        pageWireframe = nil
    }
}
