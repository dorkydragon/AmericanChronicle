// MARK: -
// MARK: USStatePickerUserInterface protocol

protocol USStatePickerUserInterface {
    var delegate: USStatePickerUserInterfaceDelegate? { get set }
    var stateNames: [String] { get set }
    func setSelectedStateNames(_ selectedStates: [String])
}

// MARK: -
// MARK: USStatePickerUserInterfaceDelegate protocol

protocol USStatePickerUserInterfaceDelegate: class {
    func userDidTapSave(with selectedStateNames: [String])
    func userDidTapCancel()
}

// MARK: -
// MARK: USStatePickerViewController class

final class USStatePickerViewController: UICollectionViewController, USStatePickerUserInterface {

    // MARK: Properties

    weak var delegate: USStatePickerUserInterfaceDelegate?
    var stateNames: [String] = []

    // MARK: Init methods

    func commonInit() {
        navigationItem.title = NSLocalizedString("U.S. States", comment: "U.S. States")
        navigationItem.setLeftButtonTitle(NSLocalizedString("Cancel", comment: "Cancel input"),
                                          target: self,
                                          action: #selector(didTapCancelButton(_:)))
        navigationItem.setRightButtonTitle(NSLocalizedString("Save", comment: "Save input"),
                                           target: self,
                                           action: #selector(didTapSaveButton(_:)))
    }

    convenience init() {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // MARK: Internal methods

    func setSelectedStateNames(_ selectedStates: [String]) {
        for selectedState in selectedStates {
            if let idx = stateNames.index(of: selectedState) {
                collectionView?.selectItem(
                    at: IndexPath(item: idx, section: 0),
                    animated: false,
                    scrollPosition: UICollectionViewScrollPosition())
            }

        }
    }

    @objc func didTapCancelButton(_ sender: UIButton) {
        delegate?.userDidTapCancel()
    }

    @objc func didTapSaveButton(_ sender: UIButton) {
        let selectedIndexPaths = collectionView?.indexPathsForSelectedItems ?? []
        let selectedStateNames = selectedIndexPaths.map { self.stateNames[($0 as NSIndexPath).item] }
        delegate?.userDidTapSave(with: selectedStateNames)
    }

    // MARK: UICollectionViewDelegateFlowLayout methods

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {

        let columnCount = 1

        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        let left = flowLayout?.sectionInset.left ?? 0
        let right = flowLayout?.sectionInset.right ?? 0
        let totalInteritemSpacing = (flowLayout?.minimumInteritemSpacing ?? 0) * CGFloat(columnCount - 1)
        let availableWidth = collectionView.bounds.width - (left + totalInteritemSpacing + right)
        let columnWidth = availableWidth/CGFloat(columnCount)
        return CGSize(width: columnWidth, height: Dimension.buttonHeight)
    }

    // MARK: UICollectionViewController overrides

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return stateNames.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: USStateCell = collectionView.dequeueCellForItemAtIndexPath(indexPath)
        cell.label.text = stateNames[(indexPath as NSIndexPath).row]
        return cell
    }

    // MARK: UIViewController overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.register(USStateCell.self,
                                      forCellWithReuseIdentifier: NSStringFromClass(USStateCell.self))
        collectionView?.allowsMultipleSelection = true
        collectionView?.backgroundColor = AMCColor.offWhite.withAlphaComponent(0.8)
        let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionInset = UIEdgeInsets(top: Dimension.verticalMargin,
                                            left: Dimension.horizontalMargin,
                                            bottom: Dimension.verticalMargin,
                                            right: Dimension.horizontalMargin)
        layout?.minimumInteritemSpacing = 1.0
        layout?.minimumLineSpacing = 1.0
    }
}
