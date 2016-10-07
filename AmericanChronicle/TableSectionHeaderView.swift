final class TableSectionHeaderView: UITableViewHeaderFooterView {
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
    fileprivate let textContainer = UIView()

    func commonInit() {

        backgroundColor = UIColor.clear
        contentView.backgroundColor = AMCColor.lightBackground
        contentView.clipsToBounds = false
        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentView.layer.shadowColor = AMCColor.darkGray.cgColor
        contentView.layer.shadowOpacity = 0.4
        contentView.layer.shadowRadius = 1

        let textContainerShadow = UIView()
        contentView.addSubview(textContainerShadow)
        textContainerShadow.layer.shadowRadius = 2
        textContainerShadow.layer.shadowColor = AMCColor.darkGray.cgColor
        textContainerShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
        textContainerShadow.snp.makeConstraints { make in
            make.top.equalTo(4)
            make.bottom.equalTo(-4)
            make.leading.equalTo(4)
        }

        contentView.addSubview(textContainer)
        textContainer.backgroundColor = AMCColor.lightBackground
        textContainer.clipsToBounds = true
        textContainer.layer.cornerRadius = 4
        textContainer.snp.makeConstraints { make in
            make.top.equalTo(textContainerShadow.snp.top)
            make.bottom.equalTo(textContainerShadow.snp.bottom)
            make.leading.equalTo(textContainerShadow.snp.leading)
            make.trailing.equalTo(textContainerShadow.snp.trailing)
        }

        textContainer.addSubview(boldTextLabel)
        boldTextLabel.font = AMCFont.verySmallBold
        boldTextLabel.textColor = AMCColor.darkGray
        boldTextLabel.numberOfLines = 1
        boldTextLabel.snp.makeConstraints { make in
            make.leading.equalTo(Measurements.horizontalMargin)
            make.bottom.equalTo(-1.0)
            make.top.equalTo(1.0)

        }

        textContainer.addSubview(regularTextLabel)
        regularTextLabel.font = AMCFont.verySmallRegular
        regularTextLabel.textColor = AMCColor.darkGray
        regularTextLabel.numberOfLines = 1
        regularTextLabel.snp.makeConstraints { make in
            make.leading.equalTo(boldTextLabel.snp.trailing).offset(2)
            make.bottom.equalTo(-1.0)
            make.top.equalTo(1.0)
            make.trailing.equalTo(-2)
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
