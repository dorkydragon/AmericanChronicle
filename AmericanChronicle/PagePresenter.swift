// MARK: -
// MARK: PagePresenterInterface protocol

protocol PagePresenterInterface: PageUserInterfaceDelegate, PageInteractorDelegate {
    var wireframe: PageWireframeInterface? { get set }
    func configure(userInterface: PageUserInterface,
                   withSearchTerm searchTerm: String?,
                   remoteDownloadURL: URL,
                   id: String)
}

// MARK: -
// MARK: PagePresenter class

final class PagePresenter: PagePresenterInterface {

    // MARK: Properties

    weak var wireframe: PageWireframeInterface?

    fileprivate let interactor: PageInteractorInterface
    fileprivate var searchTerm: String?
    fileprivate var remoteDownloadURL: URL?
    fileprivate var userInterface: PageUserInterface?

    // MARK: Init methods

    init(interactor: PageInteractorInterface = PageInteractor()) {
        self.interactor = interactor
        interactor.delegate = self
    }

    // MARK: PagePresenterInterface methods

    func configure(userInterface: PageUserInterface,
                   withSearchTerm searchTerm: String?,
                   remoteDownloadURL: URL,
                   id: String) {
        self.userInterface = userInterface
        self.userInterface?.showLoadingIndicator()

        self.searchTerm = searchTerm
        self.remoteDownloadURL = remoteDownloadURL

        interactor.startDownload(withRemoteURL: remoteDownloadURL)
        interactor.startOCRCoordinatesRequest(withID: id)
    }

    // MARK: PageUserInterfaceDelegate methods

    func userDidTapDone() {
        cancelDownloadAndFinish()
    }

    func userDidTapCancel() {
        cancelDownloadAndFinish()
    }

    func userDidTapShare(with image: UIImage) {
        wireframe?.showShareScreen(withImage: image)
    }

    // MARK: PageInteractorDelegate methods

    func downloadDidFinish(forRemoteURL: URL, withFileURL fileURL: URL?, error: NSError?) {
        DispatchQueue.main.async {
            if let error = error, !error.isCancelledRequestError() {
                self.userInterface?.showErrorWithTitle(NSLocalizedString("Trouble Downloading PDF", comment: "Trouble Downloading PDF"),

                                                       message: error.localizedDescription)
                self.userInterface?.hideLoadingIndicator()
            } else {
                if let fileURL = fileURL {
                    self.userInterface?.pdfPage = CGPDFDocument(fileURL as CFURL)?.page(at: 1)
                    self.userInterface?.hideLoadingIndicator()
                }
            }
            // NOTE: Only hiding loading indicator if content is being updated.
            // Prevents the page from flashing black if loading is cancelled.
        }
    }

    func requestDidFinish(withOCRCoordinates coordinates: OCRCoordinates?, error: NSError?) {
        guard let searchTerm = searchTerm else { return }
        var terms = [searchTerm]
        terms.append(contentsOf: searchTerm.components(separatedBy: " "))

        var matchingCoordinates: [String: [CGRect]] = [:]
        let wordsWithCoordinates = (coordinates?.wordCoordinates ?? [:]).keys
        for word in wordsWithCoordinates {
            for term in terms {
                if word.lowercased() == term.lowercased() {
                    matchingCoordinates[word] = coordinates?.wordCoordinates?[word]
                }
            }
        }

        coordinates?.wordCoordinates = matchingCoordinates
        userInterface?.highlights = coordinates
    }

    // MARK: Private methods

    fileprivate func cancelDownloadAndFinish() {
        if let url = remoteDownloadURL {
            interactor.cancelDownload(withRemoteURL: url)
        }
        wireframe?.dismiss()
    }
}
