// mark: -
// mark: PageUserInterfaceDelegate protocol

protocol PageUserInterfaceDelegate: class {
    func userDidTapDone()
    func userDidTapCancel()
    func userDidTapShare(with image: UIImage)
}

// mark: -
// mark: PageUserInterface protocol

protocol PageUserInterface {
    var pdfPage: CGPDFPage? { get set }
    var highlights: OCRCoordinates? { get set }
    var delegate: PageUserInterfaceDelegate? { get set }

    func showLoadingIndicator()
    func hideLoadingIndicator()
    func setDownloadProgress(_ progress: Float)
    func showErrorWithTitle(_ title: String?, message: String?)
}

// mark: -
// mark: PageViewController class

final class PageViewController: UIViewController, PageUserInterface, UIScrollViewDelegate {

    // mark: Properties

    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var bottomBarBG: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorTitleLabel: UILabel!
    @IBOutlet weak var errorMessageLabel: UILabel!

    lazy var pageView: PDFPageView = PDFPageView()

    fileprivate let toastButton = UIButton()
    fileprivate var presentingViewNavBar: UIView?
    fileprivate var presentingView: UIView?
    fileprivate var hidesStatusBar: Bool = true

    // mark: Internal methods

    @IBAction func shareButtonTapped(_ sender: AnyObject) {

        guard let pdfRect = pageView.pdfPage?.getBoxRect(.mediaBox) else { return }
        UIGraphicsBeginImageContext(pdfRect.size)
        if let ctx = UIGraphicsGetCurrentContext() {
            pageView.pdfPage?.drawInContext(ctx,
                                            boundingRect: pdfRect,
                                            withHighlights: pageView.highlights)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        delegate?.userDidTapShare(with: image!)
    }

    @IBAction func doneButtonTapped(_ sender: AnyObject) {
        delegate?.userDidTapDone()
    }

    @IBAction func didTapCancelButton(_ sender: AnyObject) {
        delegate?.userDidTapCancel()
    }

    @IBAction func didRecognizeTap(_ sender: AnyObject) {
        bottomBarBG.isHidden = !bottomBarBG.isHidden
    }

    @IBAction func errorOKButtonTapped(_ sender: AnyObject) {
        delegate?.userDidTapDone()
    }

    // mark: PageUserInterface conformance

    weak var delegate: PageUserInterfaceDelegate?

    var pdfPage: CGPDFPage? {
        get {
            return pageView.pdfPage
        }
        set {
            pageView.pdfPage = newValue
            pageView.frame = pageView.pdfPage?.mediaBoxRect ?? .zero
            view.setNeedsLayout()
        }
    }

    var highlights: OCRCoordinates? {
        get {
            return pageView.highlights
        }
        set {
            pageView.highlights = newValue
            view.setNeedsLayout()
        }
    }

    func showLoadingIndicator() {
        if isViewLoaded {
            loadingView.alpha = 1.0
            activityIndicator.startAnimating()
        }
    }

    func hideLoadingIndicator() {
        loadingView.alpha = 0
        activityIndicator.stopAnimating()
    }

    func setDownloadProgress(_ progress: Float) {
        progressView.progress = progress
    }

    func showErrorWithTitle(_ title: String?, message: String?) {
        errorTitleLabel.text = title
        errorMessageLabel.text = message
        errorView.isHidden = false
    }

    // mark: UIScrollViewDelegate conformance

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return pageView
    }

    // mark: UIViewController overrides

    override var modalPresentationStyle: UIModalPresentationStyle {
        get { return .overCurrentContext }
        set { }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.addSubview(pageView)

        doneButton.setBackgroundImage(nil, for: UIControlState())
        doneButton.setTitleColor(UIColor.lightText, for: UIControlState())
        doneButton.setTitle(nil, for: UIControlState())
        doneButton.tintColor = UIColor.white
        let doneImage = UIImage(named: "UIAccessoryButtonX")
        doneButton.setImage(doneImage?.withRenderingMode(.alwaysTemplate), for: UIControlState())

        shareButton.setBackgroundImage(nil, for: UIControlState())
        shareButton.setTitleColor(UIColor.lightText, for: UIControlState())
        shareButton.setTitle(nil, for: UIControlState())
        shareButton.tintColor = UIColor.white
        let actionImage = UIImage(named: "UIButtonBarAction")
        shareButton.setImage(actionImage?.withRenderingMode(.alwaysTemplate),
                             for: UIControlState())

        toastButton.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        toastButton.setTitleColor(UIColor.darkGray, for: UIControlState())
        toastButton.layer.shadowColor = UIColor.black.cgColor
        toastButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        toastButton.layer.shadowRadius = 1.0
        toastButton.layer.shadowOpacity = 1.0
        view.addSubview(toastButton)

        hideError()

        showLoadingIndicator()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    override func viewDidLayoutSubviews() {
        let scrollViewWidthOverPageWidth: CGFloat
        if let pageWidth = pageView.pdfPage?.mediaBoxRect.size.width, pageWidth > 0 {
            scrollViewWidthOverPageWidth = scrollView.bounds.size.width/pageWidth
        } else {
            scrollViewWidthOverPageWidth = 1.0
        }
        scrollView.minimumZoomScale = scrollViewWidthOverPageWidth
        scrollView.zoomScale = scrollView.minimumZoomScale
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    // mark: Private methods

    fileprivate func hideError() {
        errorView.isHidden = true
    }
}
