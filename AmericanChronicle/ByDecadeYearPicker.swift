final class ByDecadeYearPicker: UIView, UICollectionViewDataSource, UICollectionViewDelegate {

    // mark: Properties

    fileprivate static let decadeTransitionScrollArea: CGFloat = 100.0
    fileprivate static let headerReuseIdentifier = "Header"

    var earliestYear: Int? {
        didSet { updateYearsAndDecades() }
    }
    var latestYear: Int? {
        didSet { updateYearsAndDecades() }
    }
    var selectedYear: Int? {
        didSet {
            if let year = selectedYear {
                let decadeString = "\(year/10)0s"
                if let section = decades.index(of: decadeString),
                    let item = yearsByDecade[decadeString]?.index(of: "\(year)") {
                    let path = IndexPath(item: item, section: section)
                    yearCollectionView.selectItem(at: path,
                                                             animated: true,
                                                             scrollPosition: UICollectionViewScrollPosition())
                    return
                }
            }
            yearCollectionView.selectItem(at: nil, animated: false, scrollPosition: .top)
        }
    }
    var yearTapHandler: ((String) -> Void)?

    fileprivate let decadeStrip: VerticalStrip
    fileprivate let yearCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.white//AMCColor.lightBlueBrightTransparent
        view.bounces = false
        view.register(ByDecadeYearPickerCell.self,
                          forCellWithReuseIdentifier: NSStringFromClass(ByDecadeYearPickerCell.self))
        view.register(UICollectionReusableView.self,
                           forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                           withReuseIdentifier: "Header")
        return view
    }()
    fileprivate var yearsByDecade: [String: [String]] = [:]
    fileprivate var decades: [String] = []
    fileprivate var previousContentOffset: CGPoint = .zero
    fileprivate var shouldIgnoreOffsetChangesUntilNextRest = false
    fileprivate var currentDecadeTransitionMinY: CGFloat?
    fileprivate var currentDecadeTransitionMaxY: CGFloat?

    // mark: Init methods

    init(decadeStrip: VerticalStrip = VerticalStrip()) {
        self.decadeStrip = decadeStrip
        super.init(frame: .zero)
        backgroundColor = UIColor.white

        decadeStrip.userDidChangeValueHandler = { [weak self] index in
            self?.shouldIgnoreOffsetChangesUntilNextRest = true
            let indexPath = IndexPath(item: 0, section: index)
            self?.yearCollectionView.scrollToItem(at: indexPath,
                                                             at: .top,
                                                             animated: true)
        }
        addSubview(decadeStrip)
        decadeStrip.snp.makeConstraints { make in
            make.top.equalTo(1.0)
            make.leading.equalTo(1.0)
            make.bottom.equalTo(-1.0)
            make.width.equalTo(self.snp.width).multipliedBy(0.33)
        }

        let verticalBorder = UIImageView(image: UIImage.imageWithFillColor(UIColor.white))
        addSubview(verticalBorder)
        verticalBorder.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.leading.equalTo(decadeStrip.snp.trailing)
            make.width.equalTo(1.0/UIScreen.main.scale)
        }

        yearCollectionView.delegate = self
        yearCollectionView.dataSource = self
        yearCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        addSubview(yearCollectionView)
        yearCollectionView.snp.makeConstraints { make in
            make.top.equalTo(1.0)
            make.bottom.equalTo(-1.0)
            make.leading.equalTo(verticalBorder.snp.trailing).offset(1.0)
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

    @available(*, unavailable)
    init() {
        fatalError("init() has not been implemented")
    }

    // mark: Private methods

    fileprivate func updateYearsAndDecades() {
        yearsByDecade = [:]
        decades = []
        if let earliestYear = earliestYear, let latestYear = latestYear, earliestYear < latestYear {
            let earliestDecade = Int(Float(earliestYear) / 10.0) * 10
            let latestDecade = Int(Float(latestYear) / 10.0) * 10
            var decade = earliestDecade
            while decade <= latestDecade {
                decades.append("\(decade)s")
                let earliestDecadeYear = max(decade, earliestYear)
                let latestDecadeYear = min(decade + 9, latestYear)
                let yearsInDecade = (earliestDecadeYear...latestDecadeYear).map { "\($0)" }
                yearsByDecade["\(decade)s"] = yearsInDecade
                decade += 10
            }
            decadeStrip.items = decades
        }
        yearCollectionView.reloadData()
    }

    fileprivate func settle() {
        guard !shouldIgnoreOffsetChangesUntilNextRest else { return }

        guard let visibleHeaderPath = yearCollectionView.lastVisibleHeaderPath else { return }

        let header = yearCollectionView.headerAtIndexPath(visibleHeaderPath)
        let distanceFromTop = header.frame.origin.y - yearCollectionView.contentOffset.y
        let halfwayPoint = yearCollectionView.frame.size.height / 2.0
        var currentSection = (visibleHeaderPath as NSIndexPath).section
        if (distanceFromTop >= halfwayPoint) && (currentSection > 0) {
            currentSection -= 1
        }

        decadeStrip.jumpToItemAtIndex(currentSection)
    }

    fileprivate func updateCurrentDecadeTransitionMinY() {

        let topHeaderY = yearCollectionView.minVisibleHeaderY


        let visibleHalfwayY = yearCollectionView.frame.size.height / 2.0
        let typicalDecadeTransitionMinY = visibleHalfwayY -
                                            (ByDecadeYearPicker.decadeTransitionScrollArea / 2.0)
        let typicalDecadeTransitionMaxY = visibleHalfwayY +
                                            (ByDecadeYearPicker.decadeTransitionScrollArea / 2.0)



        // if the year collectionView is resting at a point where transition
        // between decades should happen, then treat this as the decade's "full"
        // position until the drag ends.
        if (topHeaderY! >= typicalDecadeTransitionMinY) &&
            (topHeaderY! <= typicalDecadeTransitionMaxY) {
            if topHeaderY! > visibleHalfwayY {
                currentDecadeTransitionMinY = (topHeaderY ?? 0) -
                                                ByDecadeYearPicker.decadeTransitionScrollArea
            } else {
                currentDecadeTransitionMinY = topHeaderY
            }
        } else {
            currentDecadeTransitionMinY = typicalDecadeTransitionMinY
        }
    }

    // mark: UICollectionViewDataSource methods

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return decades.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        let years = yearsByDecade[decades[section]]
        return years?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ByDecadeYearPickerCell = collectionView.dequeueCellForItemAtIndexPath(indexPath)
        let decade = decades[(indexPath as NSIndexPath).section]
        cell.text = yearsByDecade[decade]?[(indexPath as NSIndexPath).item]
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

    // mark: UICollectionViewDelegate methods

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        updateCurrentDecadeTransitionMinY()
        let decade = decades[(indexPath as NSIndexPath).section]
        if let year = yearsByDecade[decade]?[(indexPath as NSIndexPath).item] {
            yearTapHandler?(year)
        }
    }

    // mark: UICollectionViewDelegateFlowLayout methods

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 44)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return ByDecadeYearPicker.lineSpacing
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 320.0, height: ByDecadeYearPicker.lineSpacing)
    }

    // mark: UIScrollViewDelegate methods

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView.isDecelerating {
            // Ignore
            return
        }
        updateCurrentDecadeTransitionMinY()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !scrollView.isDecelerating {
            shouldIgnoreOffsetChangesUntilNextRest = false
        }
        settle()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if !scrollView.isDragging {
            shouldIgnoreOffsetChangesUntilNextRest = false
        }
        settle()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !shouldIgnoreOffsetChangesUntilNextRest else { return }

        guard let lowerSectionHeaderPath = yearCollectionView.lastVisibleHeaderPath else {
            return
        }

        // When the header's y origin is here, the lower section should be
        // shown at 100%.
        guard let fullLowerSectionYBoundary = currentDecadeTransitionMinY else { return }
        // When the header's y origin is here, the upper section should be
        // shown at 100%
        let fullUpperSectionYBoundary = fullLowerSectionYBoundary +
                                            ByDecadeYearPicker.decadeTransitionScrollArea

        let lowerSectionHeader = yearCollectionView.headerAtIndexPath(lowerSectionHeaderPath)

        // Position of the header's y origin to the user
        let perceivedLowerSectionY = lowerSectionHeader.frame.origin.y -
                                        yearCollectionView.contentOffset.y

        // The first visible header marks the beginning of the lower section.
        // VerticalStrip wants the upper section, so subtract 1 (unless 0)
        let upperSection = max((lowerSectionHeaderPath as NSIndexPath).section - 1, 0)

        if (perceivedLowerSectionY >= fullLowerSectionYBoundary) &&
            (perceivedLowerSectionY <= fullUpperSectionYBoundary) {
            // How much would the user need to scroll before upper section should be fully visible?
            let distanceFromFullUpper = fullUpperSectionYBoundary - perceivedLowerSectionY
            let fractionScrolled = distanceFromFullUpper /
                                        ByDecadeYearPicker.decadeTransitionScrollArea
            decadeStrip.showItemAtIndex(upperSection, withFractionScrolled: fractionScrolled)
        } else if perceivedLowerSectionY < fullLowerSectionYBoundary {
            decadeStrip.showItemAtIndex((lowerSectionHeaderPath as NSIndexPath).section, withFractionScrolled: 0)
        } else if perceivedLowerSectionY > fullUpperSectionYBoundary {
            decadeStrip.showItemAtIndex(upperSection, withFractionScrolled: 0)
        }
    }
}
