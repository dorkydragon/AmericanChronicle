import MessageUI

final class InfoViewController: UIViewController {

    // MARK: Properties

    var dismissHandler: ((Void) -> Void)?

    fileprivate let bodyLabel: UILabel = {
        let label = UILabel()
        label.textColor = AMCColor.darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = AMCFont.mediumRegular
        var text = NSLocalizedString("Chronicling America Blurb",
                                     comment: "Description of the Chronicling America service")
        //"American Chronicle gets its data from the 'Chronicling America' website.\n"
        //text += "\n'Chronicling America' is a project funded by the National Endowment"
        //text += " for the Humanities and maintained by the Library of Congress."
        label.text = text
        return label
    }()
    fileprivate let websiteButton = TitleButton(title: NSLocalizedString("Visit chroniclingamerica.gov.loc",
                                                                         comment: "Visit the Chronicling America website"))
    fileprivate let separator = UIImageView(image: UIImage.imageWithFillColor(AMCColor.brightBlue))
    fileprivate let suggestionsLabel: UILabel = {
        let label = UILabel()
        label.textColor = AMCColor.darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = AMCFont.mediumRegular
        label.text = NSLocalizedString("Do you have a question, suggestion or complaint about the app?",
                                       comment: "Do you have any feedback?")
        return label
    }()
    fileprivate let suggestionsButton = TitleButton(title: NSLocalizedString("Send us a message",
                                                                             comment: "Send an email"))

    // MARK: Init methods

    func commonInit() {
        navigationItem.title = NSLocalizedString("About this app", comment: "About this app")
        navigationItem.setLeftButtonTitle(NSLocalizedString("Dismiss", comment: "Dismiss the screen"),
                                          target: self,
                                          action: #selector(didTapDismissButton(_:)))
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // MARK: Internal methods

    func didTapDismissButton(_ sender: UIBarButtonItem) {
        dismissHandler?()
    }

    func didTapSuggestionsButton(_ sender: UIButton) {
        let vc = MFMailComposeViewController()
        vc.setSubject("AmericanChronicle")
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

    // MARK: UIViewController overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = AMCColor.offWhite

        view.addSubview(bodyLabel)
        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(Dimension.verticalMargin)
            make.leading.equalTo(Dimension.horizontalMargin)
            make.trailing.equalTo(-Dimension.horizontalMargin)
        }

        websiteButton.addTarget(self,
                                action: #selector(didTapWebsiteButton(_:)),
                                for: .touchUpInside)
        view.addSubview(websiteButton)
        websiteButton.snp.makeConstraints { make in
            make.top.equalTo(bodyLabel.snp.bottom).offset(Dimension.verticalSiblingSpacing * 2)
            make.leading.equalTo(Dimension.horizontalMargin)
            make.trailing.equalTo(-Dimension.horizontalMargin)
            make.height.equalTo(Dimension.buttonHeight)
        }

        view.addSubview(separator)
        separator.snp.makeConstraints { make in
            make.top.equalTo(websiteButton.snp.bottom).offset(Dimension.verticalMargin * 2)
            make.leading.equalTo(Dimension.horizontalMargin * 2)
            make.trailing.equalTo(-Dimension.horizontalMargin * 2)
            make.height.equalTo(1.0/UIScreen.main.nativeScale)
        }

        view.addSubview(suggestionsLabel)
        suggestionsLabel.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom).offset(Dimension.verticalMargin)
            make.leading.equalTo(Dimension.horizontalMargin)
            make.trailing.equalTo(-Dimension.horizontalMargin)
        }

        suggestionsButton.addTarget(self,
                                    action: #selector(didTapSuggestionsButton(_:)),
                                    for: .touchUpInside)
        view.addSubview(suggestionsButton)
        suggestionsButton.snp.makeConstraints { make in
            make.top.equalTo(suggestionsLabel.snp.bottom)
                .offset(Dimension.verticalSiblingSpacing * 2)
            make.leading.equalTo(Dimension.horizontalMargin)
            make.trailing.equalTo(-Dimension.horizontalMargin)
            make.height.equalTo(Dimension.buttonHeight)
        }
    }
}
