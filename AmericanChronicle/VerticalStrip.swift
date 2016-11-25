final class VerticalStrip: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    var userDidChangeValueHandler: ((Int) -> Void)?
    var items: [String] = [] { didSet { collectionView.reloadData() } }
    var selectedIndex: Int {
        let val = collectionView.contentOffset.y / collectionView.frame.height
        let rounded = round(val)
        let roundedInt = Int(rounded)
        return roundedInt
    }
    var itemHeight: CGFloat {
        return collectionView.frame.height
    }
    var yOffset: CGFloat {
        return collectionView.contentOffset.y
    }

    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.bounces = false
        view.register(VerticalStripCell.self, forCellWithReuseIdentifier: "Cell")
        view.backgroundColor = UIColor.white
        view.isPagingEnabled = true
        view.showsVerticalScrollIndicator = false
        return view
    }()

    fileprivate static func newButtonWithImage(_ image: UIImage, accessibilityLabel: String) -> UIButton {
        let button = UIButton()
        button.accessibilityLabel = accessibilityLabel
        button.layer.cornerRadius = 0
        button.clipsToBounds = true
        button.setImage(image, for: UIControlState())
        button.setImage(image, for: .highlighted)
        button.setBackgroundImage(UIImage.imageWithFillColor(UIColor.clear), for: UIControlState())
        button.setBackgroundImage(UIImage.imageWithFillColor(UIColor.clear), for: .highlighted)
        return button
    }

    fileprivate let upButton: UIButton = {
        let arrowImage = UIImage.upArrowWithFillColor(AMCColor.brightBlue)
        let button = VerticalStrip.newButtonWithImage(arrowImage, accessibilityLabel: NSLocalizedString("Up one page", comment: "Up one page"))
        return button
    }()

    fileprivate static let separatorColor = UIColor.white

    fileprivate let upButtonSeparator: UIImageView = {
        let v = UIImageView(image: UIImage.imageWithFillColor(VerticalStrip.separatorColor))
        return v
    }()

    fileprivate let downButton: UIButton = {
        let arrowImage = UIImage.downArrowWithFillColor(AMCColor.brightBlue)
        let button = VerticalStrip.newButtonWithImage(arrowImage, accessibilityLabel: NSLocalizedString("Down one page", comment: "Down one page"))
        return button
    }()

    fileprivate let downButtonSeparator: UIImageView = {
        let v = UIImageView(image: UIImage.imageWithFillColor(VerticalStrip.separatorColor))
        return v
    }()

    // MARK: Init methods

    func commonInit() {

        backgroundColor = UIColor.white
        let buttonHeight = 44

        upButton.addTarget(self, action: #selector(didTapUpButton(_:)), for: .touchUpInside)
        addSubview(upButton)
        upButton.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.height.equalTo(buttonHeight)
        }

        insertSubview(upButtonSeparator, belowSubview: upButton)
        upButtonSeparator.snp.makeConstraints { make in
            make.bottom.equalTo(upButton.snp.bottom)
            make.leading.equalTo(12.0)
            make.trailing.equalTo(-12.0)
            make.height.equalTo(1.0)
        }

        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(upButton.snp.bottom)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
        }

        downButton.addTarget(self, action: #selector(didTapDownButton(_:)), for: .touchUpInside)
        addSubview(downButton)
        downButton.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.bottom.equalTo(0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.height.equalTo(buttonHeight)
        }

        insertSubview(downButtonSeparator, belowSubview: downButton)
        downButtonSeparator.snp.makeConstraints { make in
            make.top.equalTo(downButton.snp.top)
            make.leading.equalTo(upButtonSeparator.snp.leading)
            make.trailing.equalTo(upButtonSeparator.snp.trailing)
            make.height.equalTo(upButtonSeparator.snp.height)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    // MARK: Internal methods

    func showItemAtIndex(_ index: Int, withFractionScrolled fractionScrolled: CGFloat, animated: Bool = false) {
        let fullyVisibleY = CGFloat(index) * collectionView.frame.height
        var newOffset = collectionView.contentOffset
        newOffset.y = fullyVisibleY + (fractionScrolled * collectionView.frame.height)
        if newOffset.y < 0 {
            newOffset.y = 0
        } else if newOffset.y > (collectionView.contentSize.height - collectionView.frame.height) {
            newOffset.y = (collectionView.contentSize.height - collectionView.frame.height)
        }

        collectionView.setContentOffset(newOffset, animated: animated)
    }

    func jumpToItemAtIndex(_ index: Int) {
        guard index >= 0 else { return }
        guard index < items.count else { return }

        showItemAtIndex(index, withFractionScrolled: 0, animated: true)
    }

    func didTapUpButton(_ button: UIButton) {
        let currentItemIndex = Int(collectionView.contentOffset.y / collectionView.frame.height)
        let nextItemIndex = currentItemIndex + 1
        if nextItemIndex < items.count {
            jumpToItemAtIndex(nextItemIndex)
            reportUserInitiatedChangeToIndex(nextItemIndex)
        }
    }

    func didTapDownButton(_ button: UIButton) {
        let currentItemIndex = Int(collectionView.contentOffset.y / collectionView.frame.height)
        let previousItemIndex = currentItemIndex - 1
        if previousItemIndex >= 0 {
            jumpToItemAtIndex(previousItemIndex)
            reportUserInitiatedChangeToIndex(previousItemIndex)
        }
    }

    // MARK: Private methods

    fileprivate func reportUserInitiatedChangeToIndex(_ index: Int) {
        userDidChangeValueHandler?(index)
    }

    // MARK: UICollectionViewDataSource methods

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! VerticalStripCell
        cell.text = items[(indexPath as NSIndexPath).item]
        return cell
    }

    // MARK: UICollectionViewDelegateFlowLayout methods

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
            return collectionView.frame.size
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
            return 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
            return 0
    }

    // MARK: UIScrollViewDelegate methods

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate else { return } // Only act if the scrollViewDidEndDecelerating method won't be called.
        let mostVisibleItem = Int(round(collectionView.contentOffset.y / collectionView.frame.height))
        jumpToItemAtIndex(mostVisibleItem)
        reportUserInitiatedChangeToIndex(mostVisibleItem)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) { // called when scroll view grinds to a halt
        let mostVisibleItem = Int(round(collectionView.contentOffset.y / collectionView.frame.height))
        jumpToItemAtIndex(mostVisibleItem)
        reportUserInitiatedChangeToIndex(mostVisibleItem)
    }
}
