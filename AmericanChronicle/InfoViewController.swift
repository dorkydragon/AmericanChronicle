import MessageUI

final class InfoViewController: UIViewController {

    // mark: Properties

    var dismissHandler: ((Void) -> Void)?

    fileprivate let bodyLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = Fonts.mediumRegular
        var text = "American Chronicle gets its data from the 'Chronicling America' website.\n"
        text += "\n'Chronicling America' is a project funded by the National Endowment"
        text += " for the Humanities and maintained by the Library of Congress."
        label.text = text
        return label
    }()
    fileprivate let websiteButton = TitleButton(title: "Visit chroniclingamerica.gov.loc")
    fileprivate let separator = UIImageView(image: UIImage.imageWithFillColor(Colors.lightBlueBright))
    fileprivate let suggestionsLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = Fonts.mediumRegular
        label.text = "Do you have a question, suggestion or complaint about the app?"
        return label
    }()
    fileprivate let suggestionsButton = TitleButton(title: "Send us a message")

    // mark: Init methods

    func commonInit() {
        navigationItem.title = "About this app"
        navigationItem.setLeftButtonTitle("Dismiss", target: self, action: #selector(didTapDismissButton(_:)))
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // mark: Internal methods

    func didTapDismissButton(_ sender: UIBarButtonItem) {
        dismissHandler?()
    }

    func didTapSuggestionsButton(_ sender: UIButton) {
        let vc = MFMailComposeViewController()
        vc.setSubject("American Chronicle")
        guard let supportEmail = ProcessInfo.processInfo.environment["SUPPORT_EMAIL"] else { return }
        vc.setToRecipients([supportEmail])
        let body = "Version \(Bundle.main.versionNumber), Build \(Bundle.main.buildNumber)"
        vc.setMessageBody(body, isHTML: false)
        present(vc, animated: true, completion: nil)
    }

    func didTapWebsiteButton(_ sender: UIBarButtonItem) {
        let vc = ChroniclingAmericaWebsiteViewController()
        vc.dismissHandler = {
            self.dismiss(animated: true, completion: nil)
        }
        let nvc = UINavigationController(rootViewController: vc)
        present(nvc, animated: true, completion: nil)
    }

    // mark: UIViewController overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.lightBackground

        view.addSubview(bodyLabel)
        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(Measurements.verticalMargin)
            make.leading.equalTo(Measurements.horizontalMargin)
            make.trailing.equalTo(-Measurements.horizontalMargin)
        }

        websiteButton.addTarget(self,
                                action: #selector(didTapWebsiteButton(_:)),
                                for: .touchUpInside)
        view.addSubview(websiteButton)
        websiteButton.snp.makeConstraints { make in
            make.top.equalTo(bodyLabel.snp.bottom).offset(Measurements.verticalSiblingSpacing * 2)
            make.leading.equalTo(Measurements.horizontalMargin)
            make.trailing.equalTo(-Measurements.horizontalMargin)
            make.height.equalTo(Measurements.buttonHeight)
        }

        view.addSubview(separator)
        separator.snp.makeConstraints { make in
            make.top.equalTo(websiteButton.snp.bottom).offset(Measurements.verticalMargin * 2)
            make.leading.equalTo(Measurements.horizontalMargin * 2)
            make.trailing.equalTo(-Measurements.horizontalMargin * 2)
            make.height.equalTo(1.0/UIScreen.main.nativeScale)
        }

        view.addSubview(suggestionsLabel)
        suggestionsLabel.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom).offset(Measurements.verticalMargin)
            make.leading.equalTo(Measurements.horizontalMargin)
            make.trailing.equalTo(-Measurements.horizontalMargin)
        }

        suggestionsButton.addTarget(self,
                                    action: #selector(didTapSuggestionsButton(_:)),
                                    for: .touchUpInside)
        view.addSubview(suggestionsButton)
        suggestionsButton.snp.makeConstraints { make in
            make.top.equalTo(suggestionsLabel.snp.bottom)
                .offset(Measurements.verticalSiblingSpacing * 2)
            make.leading.equalTo(Measurements.horizontalMargin)
            make.trailing.equalTo(-Measurements.horizontalMargin)
            make.height.equalTo(Measurements.buttonHeight)
        }
    }
}
