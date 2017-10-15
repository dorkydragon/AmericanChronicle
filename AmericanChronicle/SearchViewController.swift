// MARK: -
// MARK: SearchUserInterface protocol

protocol SearchUserInterface: class {
    weak var delegate: SearchUserInterfaceDelegate? { get set }
    var searchTerm: String? { get set }
    var earliestDate: String? { get set }
    var latestDate: String? { get set }
    var usStateNames: String? { get set }

    func setViewState(_ state: SearchViewState)
    func setBottomContentInset(_ bottom: CGFloat)
    func resignFirstResponder() -> Bool
}

// MARK: -
// MARK: SearchUserInterfaceDelegate protocol

protocol SearchUserInterfaceDelegate: class {
    func userDidTapReturn()
    func userDidTapUSStates()
    func userDidTapEarliestDateButton()
    func userDidTapLatestDateButton()
    func userDidChangeSearch(to term: String?)
    func userIsApproachingLastRow(for term: String?, inCollection: [SearchResultsRow])
    func userDidSelectSearchResult(_ row: SearchResultsRow)
    func viewDidLoad()
}

// MARK: -
// MARK: SearchViewController class

final class SearchViewController: UIViewController,
        SearchUserInterface,
        UITableViewDelegate,
        UITableViewDataSource {

    // MARK: Properties

    weak var delegate: SearchUserInterfaceDelegate?

    var searchTerm: String? {
        get { return tableHeaderView.searchTerm }
        set { tableHeaderView.searchTerm = newValue }
    }

    var earliestDate: String? {
        get { return tableHeaderView.earliestDate }
        set { tableHeaderView.earliestDate = newValue }
    }

    var latestDate: String? {
        get { return tableHeaderView.latestDate }
        set { tableHeaderView.latestDate = newValue }
    }

    var usStateNames: String? {
        get { return tableHeaderView.usStateNames }
        set { tableHeaderView.usStateNames = newValue }
    }

    fileprivate static let approachingCount = 5

    fileprivate let emptyResultsView = EmptyResultsView()
    fileprivate let errorView = ErrorView()
    fileprivate let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    fileprivate let tableView = UITableView()
    fileprivate let tableHeaderView = SearchTableHeaderView()
    fileprivate let tableFooterView = UIView()
    fileprivate let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter
    }()

    fileprivate var totalRowCount = 0
    fileprivate var rows: [SearchResultsRow] = []

    // MARK: Init methods

    func commonInit() {
        navigationItem.title = NSLocalizedString("Search", comment: "Search")
        navigationItem.setLeftButtonTitle(NSLocalizedString("Info", comment: "General information about the app"),
                                          target: self,
                                          action: #selector(didTapInfoButton(_:)))
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // MARK: Internal methods

    @objc func didTapInfoButton(_ sender: UIBarButtonItem) {
        let vc = InfoViewController()
        vc.dismissHandler = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        let nvc = UINavigationController(rootViewController: vc)
        present(nvc, animated: true, completion: nil)
    }

    // MARK: SearchUserInterface conformance

    func setViewState(_ state: SearchViewState) {
        switch state {
        case .emptySearchField:
            setLoadingIndicatorsVisible(false)
            emptyResultsView.alpha = 0
            errorView.alpha = 0
            totalRowCount = 0
            rows = []
            tableView.reloadData()
            tableFooterView.alpha = 0
        case .emptyResults:
            setLoadingIndicatorsVisible(false)
            emptyResultsView.alpha = 1.0
            emptyResultsView.title = NSLocalizedString("No results", comment: "No results found for search")
            errorView.alpha = 0
            totalRowCount = 0
            rows = []
            tableView.reloadData()
            tableFooterView.alpha = 0
        case .loadingNewParamaters:
            setLoadingIndicatorsVisible(true)
            emptyResultsView.alpha = 0
            errorView.alpha = 0
            totalRowCount = 0
            rows = []
            tableView.reloadData()
            tableFooterView.alpha = 0
        case .loadingMoreRows:
            setLoadingIndicatorsVisible(false)
            emptyResultsView.alpha = 0
            errorView.alpha = 0
            tableFooterView.alpha = 1.0
        case let .partial(totalCount, rows):
            setLoadingIndicatorsVisible(false)
            emptyResultsView.alpha = 0
            errorView.alpha = 0
            totalRowCount = totalCount
            if self.rows != rows {
                self.rows = rows
                tableView.reloadData()
            }
            tableFooterView.alpha = 0
        case let .ideal(totalCount, rows):
            setLoadingIndicatorsVisible(false)
            emptyResultsView.alpha = 0
            errorView.alpha = 0
            totalRowCount = totalCount
            if self.rows != rows {
                self.rows = rows
                tableView.reloadData()
            }
            tableFooterView.alpha = 0
        case let .error(title, message):
            setLoadingIndicatorsVisible(false)
            emptyResultsView.alpha = 0
            errorView.alpha = 1.0
            totalRowCount = 0
            rows = []
            tableView.reloadData()
            errorView.title = title
            errorView.message = message
            tableFooterView.alpha = 0
        }
    }

    func setBottomContentInset(_ bottom: CGFloat) {
        if !isViewLoaded {
            return
        }
        var contentInset = tableView.contentInset
        contentInset.bottom = bottom
        tableView.contentInset = contentInset

        var indicatorInsets = tableView.scrollIndicatorInsets
        indicatorInsets.bottom = bottom
        tableView.scrollIndicatorInsets = indicatorInsets
    }

    // MARK: UITableViewDelegate & -DataSource conformance

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if rows.count == 0 { return nil }

        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: TableSectionHeaderView.self))
                                        as? TableSectionHeaderView
        headerView?.boldText = "\(totalRowCount)"
        headerView?.regularText = NSLocalizedString("results", comment: "Usage: '14 {{ results }} found'")
        return headerView
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return (rows.count > 0) ? 1 : 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchResultsPageCell.self),
                                                 for: indexPath)
        guard let pageCell = cell as? SearchResultsPageCell else {
            assert(false)
            return cell
        }
        let result = rows[(indexPath as NSIndexPath).row]
        if let date = result.date {
            pageCell.date = dateFormatter.string(from: date as Date)
        } else {
            pageCell.date = ""
        }
        pageCell.cityState = result.cityState
        pageCell.publicationTitle = result.publicationTitle
        pageCell.thumbnailURL = result.thumbnailURL
        return pageCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        _ = tableHeaderView.resignFirstResponder()
        delegate?.userDidSelectSearchResult(rows[(indexPath as NSIndexPath).row])
    }

    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        guard rows.count > 0 else { return }
        guard (rows.count - (indexPath as NSIndexPath).row) < SearchViewController.approachingCount else { return }

        delegate?.userIsApproachingLastRow(for: tableHeaderView.searchTerm, inCollection: rows)
    }

    // MARK: UIViewController overrides

    override func loadView() {
        view = UIView()
        view.backgroundColor = AMCColor.offWhite

        loadTableView()
        loadTableHeaderView()
        loadTableFooterView()
        loadErrorView()
        loadEmptyResultsView()
        loadActivityIndicator()

        setViewState(.emptySearchField)

        delegate?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.tableHeaderView = tableHeaderView
        tableView.tableFooterView = tableFooterView
    }

    // MARK: UIResponder overrides

    override func becomeFirstResponder() -> Bool {
        return tableHeaderView.becomeFirstResponder()
    }

    override func resignFirstResponder() -> Bool {
        return tableHeaderView.resignFirstResponder()
    }

    // MARK: Private methods

    fileprivate func loadTableView() {
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchResultsPageCell.self,
                                forCellReuseIdentifier: String(describing: SearchResultsPageCell.self))
        tableView.register(TableSectionHeaderView.self,
                                forHeaderFooterViewReuseIdentifier: String(describing: TableSectionHeaderView.self))
        tableView.sectionHeaderHeight = 34.0
        tableView.separatorColor = AMCColor.lightGray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.rowHeight = 120.0
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
    }

    fileprivate func loadTableHeaderView() {

        tableHeaderView.frame = CGRect(x: 0,
                                       y: 0,
                                       width: 0,
                                       height: tableHeaderView.intrinsicContentSize.height)

        tableHeaderView.shouldChangeCharactersHandler = {
            [weak self] original, range, replacement in
            var text = original
            if let range = original.rangeFromNSRange(range) {
                text.replaceSubrange(range, with: replacement)
            }

            self?.delegate?.userDidChangeSearch(to: text)

            return true
        }
        tableHeaderView.shouldReturnHandler = { [weak self] in
            self?.delegate?.userDidTapReturn()
            return false
        }
        tableHeaderView.shouldClearHandler = { [weak self] in
            self?.delegate?.userDidChangeSearch(to: "")
            return true
        }
        tableHeaderView.earliestDateButtonTapHandler = { [weak self] in
            self?.delegate?.userDidTapEarliestDateButton()
        }
        tableHeaderView.latestDateButtonTapHandler = { [weak self] in
            self?.delegate?.userDidTapLatestDateButton()
        }
        tableHeaderView.usStatesButtonTapHandler = { [weak self] in
            self?.delegate?.userDidTapUSStates()
        }
    }

    fileprivate func loadTableFooterView() {
        tableFooterView.frame = CGRect(x: 0, y: 0, width: 300, height: 48)

        let spinner = UIActivityIndicatorView()
        spinner.startAnimating()
        tableFooterView.addSubview(spinner)
        spinner.snp.makeConstraints { make in
            make.center.equalTo(0)
        }
    }

    fileprivate func loadErrorView() {
        view.addSubview(errorView)
        errorView.snp.makeConstraints { make in
            make.centerY.equalTo(self.view.snp.centerY)
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
        }
    }

    fileprivate func loadEmptyResultsView() {
        view.addSubview(emptyResultsView)
        emptyResultsView.snp.makeConstraints { make in
            make.center.equalTo(self.view.snp.center)
        }
    }

    fileprivate func loadActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(view.snp.center)
        }
    }

    fileprivate func setLoadingIndicatorsVisible(_ visible: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = visible
        if visible {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}
