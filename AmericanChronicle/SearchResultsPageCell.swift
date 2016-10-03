final class SearchResultsPageCell: UITableViewCell {

    // mark: Properties

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
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2.0
        view.clipsToBounds = true
        return view
    }()
    fileprivate let cityStateLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.darkGray
        label.numberOfLines = 0
        label.textAlignment = .right
        label.font = Fonts.mediumBody
        return label
    }()
    fileprivate let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.darkGray
        label.numberOfLines = 0
        label.textAlignment = .right
        label.font = Fonts.largeBodyBold
        return label
    }()
    fileprivate let publicationTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.darkGray
        label.numberOfLines = 0
        label.textAlignment = .right
        label.font = Fonts.mediumBody
        return label
    }()

    // mark: Init methods

    func commonInit() {

        contentView.backgroundColor = UIColor.white

        addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints { make in
            make.top.equalTo(Measurements.verticalMargin)
            make.leading.equalTo(Measurements.horizontalMargin)
            make.bottom.equalTo(-Measurements.verticalMargin)
            make.width.equalTo(snp.height).multipliedBy(0.6)
        }

        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(Measurements.verticalMargin)
            make.leading.equalTo(thumbnailImageView.snp.trailing)
                        .offset(Measurements.horizontalSiblingSpacing)
            make.trailing.equalTo(-Measurements.horizontalMargin)
        }

        addSubview(cityStateLabel)
        cityStateLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(Measurements.verticalSiblingSpacing)
            make.leading.equalTo(thumbnailImageView.snp.trailing)
                        .offset(Measurements.horizontalSiblingSpacing)
            make.trailing.equalTo(-Measurements.horizontalMargin)
        }

        addSubview(publicationTitleLabel)
        publicationTitleLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(cityStateLabel.snp.bottom)
                        .offset(Measurements.verticalSiblingSpacing)
            make.leading.equalTo(thumbnailImageView.snp.trailing)
                        .offset(Measurements.horizontalSiblingSpacing)
            make.bottom.equalTo(-Measurements.verticalMargin)
            make.trailing.equalTo(-Measurements.horizontalMargin)
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
