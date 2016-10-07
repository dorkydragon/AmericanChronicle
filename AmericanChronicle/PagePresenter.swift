// mark: -
// mark: PagePresenterInterface protocol

protocol PagePresenterInterface: PageUserInterfaceDelegate, PageInteractorDelegate {
    var wireframe: PageWireframeProtocol? { get set }
    func configureUserInterfaceForPresentation(_ userInterface: PageUserInterface,
                                               withSearchTerm searchTerm: String?,
                                                              remoteDownloadURL: URL,
                                                              id: String)
}

// mark: -
// mark: PagePresenter class

final class PagePresenter: PagePresenterInterface {

    // mark: Properties

    weak var wireframe: PageWireframeProtocol?

    fileprivate let interactor: PageInteractorInterface
    fileprivate var searchTerm: String?
    fileprivate var remoteDownloadURL: URL?
    fileprivate var userInterface: PageUserInterface?

    // mark: Init methods

    init(interactor: PageInteractorInterface = PageInteractor()) {
        self.interactor = interactor
        interactor.delegate = self
    }

    // mark: Private methods

    fileprivate func cancelDownloadAndFinish() {
        if let url = remoteDownloadURL {
            interactor.cancelDownloadWithRemoteURL(url)
        }
        wireframe?.dismissPageScreen()
    }

    // mark: PagePresenterInterface methods

    func configureUserInterfaceForPresentation(_ userInterface: PageUserInterface,
                                               withSearchTerm searchTerm: String?,
                                                              remoteDownloadURL: URL,
                                                              id: String) {
        self.userInterface = userInterface
        self.userInterface?.showLoadingIndicator()

        self.searchTerm = searchTerm
        self.remoteDownloadURL = remoteDownloadURL

        interactor.startDownloadWithRemoteURL(remoteDownloadURL)
        interactor.startOCRCoordinatesRequestWithID(id)
    }

    // mark: PageUserInterfaceDelegate methods

    func userDidTapDone() {
        cancelDownloadAndFinish()
    }

    func userDidTapCancel() {
        cancelDownloadAndFinish()
    }

    func userDidTapShare(_ image: UIImage) {
        wireframe?.showShareScreen(withImage: image)
    }

    // mark: PageInteractorDelegate methods

    func download(_ remoteURL: URL, didFinishWithFileURL fileURL: URL?, error: NSError?) {
        if let error = error {
            userInterface?.showErrorWithTitle("Trouble Downloading PDF", message: error.localizedDescription)
        } else {
            if let fileURL = fileURL {
                userInterface?.pdfPage = CGPDFDocument(fileURL as CFURL)?.page(at: 1)
            }
        }
        userInterface?.hideLoadingIndicator()
    }

    func requestDidFinishWithOCRCoordinates(_ coordinates: OCRCoordinates?, error: NSError?) {
        guard let searchTerm = searchTerm else { return }
        var terms = [searchTerm]
        terms.append(contentsOf: searchTerm.components(separatedBy: " "))

        var matchingCoordinates: [String: [CGRect]] = [:]
        if let wordsWithCoordinates = coordinates?.wordCoordinates?.keys {
            for word in wordsWithCoordinates {
                for term in terms {
                    if word.lowercased() == term.lowercased() {
                        matchingCoordinates[word] = coordinates?.wordCoordinates?[word]
                        continue
                    }
                }
            }
        }

        coordinates?.wordCoordinates = matchingCoordinates
        userInterface?.highlights = coordinates
    }
}
