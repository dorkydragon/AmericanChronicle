final class EmptyResultsView: UIView {

    var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    // mark: Init methods

    func commonInit() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(Dimension.verticalMargin)
            make.leading.equalTo(Dimension.horizontalMargin)
            make.bottom.equalTo(-Dimension.verticalMargin)
            make.trailing.equalTo(-Dimension.horizontalMargin)

        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
}
