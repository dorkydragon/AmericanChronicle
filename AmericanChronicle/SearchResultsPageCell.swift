final class SearchResultsPageCell: UITableViewCell {

    // MARK: Properties

    var thumbnailURL: URL? {
        get { return thumbnailImageView.sd_imageURL() }
        set { thumbnailImageView.sd_setImage(with: newValue) }
    }
    var cityState: String? {
        get { return cityStateLabel.text }
        set { cityStateLabel.text = newValue }
    }
    var date: String? {
        get { return dateLabel.text }
        set { dateLabel.text = newValue }
    }
    var publicationTitle: String? {
        get { return publicationTitleLabel.text }
        set { publicationTitleLabel.text = newValue }
    }

    fileprivate let thumbnailImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = UIColor.white
        view.clipsToBounds = true
        return view
    }()
    fileprivate let cityStateLabel: UILabel = {
        let label = UILabel()
        label.textColor = AMCColor.darkGray
        label.numberOfLines = 0
        label.font = AMCFont.smallRegular
        return label
    }()
    fileprivate let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = AMCColor.darkGray
        label.numberOfLines = 0
        label.font = AMCFont.largeBold
        return label
    }()
    fileprivate let publicationTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = AMCColor.darkGray
        label.numberOfLines = 0
        label.font = AMCFont.smallBold
        return label
    }()

    // MARK: Init methods

    func commonInit() {

        contentView.backgroundColor = UIColor.white

        let thumbnailShadowView = UIView()
        thumbnailShadowView.layer.shadowOpacity = 1.0
        thumbnailShadowView.layer.shadowColor = AMCColor.darkGray.cgColor
        thumbnailShadowView.layer.shadowRadius = 2
        thumbnailShadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        thumbnailShadowView.backgroundColor = UIColor.white
        contentView.addSubview(thumbnailShadowView)

        thumbnailShadowView.snp.makeConstraints { make in
            make.top.equalTo(12)
            make.bottom.equalTo(-12)
            make.leading.equalTo(12)
            make.width.equalTo(snp.height).multipliedBy(0.6)
        }

        contentView.addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints { make in
            make.top.equalTo(thumbnailShadowView.snp.top)
            make.leading.equalTo(thumbnailShadowView.snp.leading)
            make.bottom.equalTo(thumbnailShadowView.snp.bottom)
            make.trailing.equalTo(thumbnailShadowView.snp.trailing)

        }

        let textContainer = UIView()
        contentView.addSubview(textContainer)
        textContainer.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.top.greaterThanOrEqualTo(Dimension.verticalMargin)
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
            make.bottom.lessThanOrEqualTo(-Dimension.verticalMargin)
            make.trailing.equalTo(-Dimension.horizontalMargin)
        }

        textContainer.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
        }

        textContainer.addSubview(publicationTitleLabel)
        publicationTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
        }

        textContainer.addSubview(cityStateLabel)
        cityStateLabel.snp.makeConstraints { make in
            make.top.equalTo(publicationTitleLabel.snp.bottom)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.bottom.equalTo(0)
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}
