final class TableHeaderView: UITableViewHeaderFooterView {
    var boldText: String? {
        get {
            return boldTextLabel.text
        }
        set {
            boldTextLabel.text = newValue
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }

    var regularText: String? {
        get {
            return regularTextLabel.text
        }
        set {
            regularTextLabel.text = newValue
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }

    fileprivate let topShadowHeight = 0
    fileprivate let bottomShadowHeight = 1
    fileprivate let boldTextLabel = UILabel()
    fileprivate let regularTextLabel = UILabel()

    func commonInit() {

        contentView.backgroundColor = UIColor.white
        contentView.clipsToBounds = true

        contentView.addSubview(boldTextLabel)
        boldTextLabel.font = Fonts.smallBodyBold
        boldTextLabel.textColor = Colors.darkGray
        boldTextLabel.numberOfLines = 1
        boldTextLabel.snp.makeConstraints { make in
            make.leading.equalTo(Measurements.horizontalMargin)
            make.bottom.equalTo(-1.0)
            make.top.equalTo(1.0)
        }

        contentView.addSubview(regularTextLabel)
        regularTextLabel.font = Fonts.smallBody
        regularTextLabel.textColor = Colors.darkGray
        regularTextLabel.numberOfLines = 1
        regularTextLabel.snp.makeConstraints { make in
            make.leading.equalTo(boldTextLabel.snp.trailing).offset(2)
            make.bottom.equalTo(-1.0)
            make.top.equalTo(1.0)
        }

        let bottomShadowOverlay = UIView()
        bottomShadowOverlay.backgroundColor = UIColor.white
        bottomShadowOverlay.layer.shadowColor = UIColor.black.cgColor
        bottomShadowOverlay.layer.shadowOffset = CGSize(width: 0, height: -bottomShadowHeight)
        bottomShadowOverlay.layer.shadowRadius = 1
        bottomShadowOverlay.layer.shadowOpacity = 0.2
        contentView.addSubview(bottomShadowOverlay)
        bottomShadowOverlay.snp.makeConstraints { make in
            make.bottom.equalTo(bottomShadowHeight)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.height.equalTo(bottomShadowHeight)
        }
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}
