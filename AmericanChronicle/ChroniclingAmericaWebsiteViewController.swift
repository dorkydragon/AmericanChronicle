import WebKit

final class ChroniclingAmericaWebsiteViewController: UIViewController {

    // mark: Properties

    var dismissHandler: ((Void) -> Void)?
    fileprivate let webView = WKWebView()

    // mark: Init methods

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

    // mark: Internal methods

    func didTapDismissButton(_ sender: UIBarButtonItem) {
        dismissHandler?()
    }

    // mark: UIViewController overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white

        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }

        let request = URLRequest(url: URL(string: "http://chroniclingamerica.loc.gov/")!)
        webView.load(request)
    }
}
