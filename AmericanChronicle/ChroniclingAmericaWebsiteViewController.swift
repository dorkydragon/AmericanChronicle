import WebKit

final class ChroniclingAmericaWebsiteViewController: UIViewController {

    // MARK: Properties

    var dismissHandler: (() -> Void)?
    fileprivate let webView = WKWebView()

    // MARK: Init methods

    func commonInit() {
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

    @objc func didTapDismissButton(_ sender: UIBarButtonItem) {
        dismissHandler?()
    }

    // MARK: UIViewController overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white

        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }

        guard let url = URL(string: "http://chroniclingamerica.loc.gov/") else {
            assert(false)
            return
        }

        webView.load(URLRequest(url: url))
    }
}
