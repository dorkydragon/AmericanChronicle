struct PickerDecade {
    let years: [PickerYear]
}

struct PickerYear {
    let asInt: Int
    let enabled: Bool
}

final class ByDecadeYearPicker: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // MARK: Properties

    var earliestYear: Int? {
        didSet { updateYearsAndDecades() }
    }
    var latestYear: Int? {
        didSet { updateYearsAndDecades() }
    }
    var selectedYear: Int? {
        didSet {
            if let year = selectedYear, let earliestYear = earliestYear {
                let decadeInt = Int(Float(year) / 10.0) * 10
                let earliestDecadeInt = Int(Float(earliestYear) / 10.0) * 10
                let decadeIndex = Int((decadeInt - earliestDecadeInt) / 10)
                let yearInt = year - decadeInt
                let path = IndexPath(item: yearInt, section: decadeIndex)
                yearCollectionView.selectItem(at: path,
                                              animated: true,
                                              scrollPosition: UICollectionViewScrollPosition())
                return
            } else {
                yearCollectionView.selectItem(at: nil, animated: false, scrollPosition: .top)
            }
        }
    }
    var yearTapHandler: ((Int) -> Void)?

    private let yearCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.white
        view.bounces = false
        view.register(ByDecadeYearPickerCell.self,
                          forCellWithReuseIdentifier: NSStringFromClass(ByDecadeYearPickerCell.self))
        view.register(UICollectionReusableView.self,
                      forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                      withReuseIdentifier: "Header")
        return view
    }()
    private var decades: [PickerDecade] = []

    // MARK: Init methods

    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor.white

        yearCollectionView.delegate = self
        yearCollectionView.dataSource = self
        yearCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        yearCollectionView.remembersLastFocusedIndexPath = true
        addSubview(yearCollectionView)
        yearCollectionView.snp.makeConstraints { make in
            make.top.equalTo(1.0)
            make.bottom.equalTo(-1.0)
            make.leading.equalTo(1.0)
            make.trailing.equalTo(-1.0)
        }
    }

    @available(*, unavailable)
    override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private methods

    private func updateYearsAndDecades() {
        if let earliestYear = earliestYear, let latestYear = latestYear, earliestYear < latestYear {
            let earliestDecade = Int(Float(earliestYear) / 10.0) // Example: 1834 becomes 183
            let latestDecade = Int(Float(latestYear) / 10.0)

            decades = (earliestDecade...latestDecade).map {
                let decade = $0 * 10 // Example: 183 becomes 1830
                let years = (decade...(decade+9)).map { PickerYear(asInt: $0, enabled: ($0 >= earliestYear) && ($0 <= latestYear)) }
                return PickerDecade(years: years)
            }
        } else {
            decades = []
        }
        yearCollectionView.reloadData()
    }

    // MARK: UICollectionViewDataSource methods

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return decades.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return decades[section].years.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ByDecadeYearPickerCell = collectionView.dequeueCellForItemAtIndexPath(indexPath)
        let decade = decades[(indexPath as NSIndexPath).section]
        let year = decade.years[(indexPath as NSIndexPath).item]
        cell.text = "\(year.asInt)"
        cell.isEnabled = year.enabled
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueHeaderForIndexPath(indexPath)
        view.backgroundColor = UIColor.white
        return view
    }

    static let lineSpacing: CGFloat = 1.0

    // MARK: UICollectionViewDelegate methods

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let decade = decades[(indexPath as NSIndexPath).section]
        let year = decade.years[(indexPath as NSIndexPath).item]
        if year.enabled {
            yearTapHandler?(year.asInt)
        }
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let decade = decades[(indexPath as NSIndexPath).section]
        let year = decade.years[(indexPath as NSIndexPath).item]
        return year.enabled
    }

    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        print("[RP] \(String(describing: type(of: self))) | \(#function) | line \(#line)")
        return true
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("[RP] \(String(describing: type(of: self))) | \(#function) | line \(#line)")
    }

    // MARK: UICollectionViewDelegateFlowLayout methods

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 320.0, height: 0)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columnCount = 5
        let verticalSpaceCount = columnCount - 1
        let verticalSpaceWidth = CGFloat(verticalSpaceCount) * 0
        let columnWidth = (collectionView.bounds.size.width - verticalSpaceWidth) / CGFloat(columnCount)

        return CGSize(width: columnWidth, height: 44)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return ByDecadeYearPicker.lineSpacing
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    override func resignFirstResponder() -> Bool {
        let val = super.resignFirstResponder()
        print("[RP] val: \(val)")
        return val
    }
}
