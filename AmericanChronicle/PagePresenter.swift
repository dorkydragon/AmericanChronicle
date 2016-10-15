// mark: -
// mark: PagePresenterInterface protocol

protocol PagePresenterInterface: PageUserInterfaceDelegate, PageInteractorDelegate {
    var wireframe: PageWireframeInterface? { get set }
    func configure(userInterface: PageUserInterface,
                   withSearchTerm searchTerm: String?,
                   remoteDownloadURL: URL,
                   id: String)
}

// mark: -
// mark: PagePresenter class

final class PagePresenter: PagePresenterInterface {

    // mark: Properties

    weak var wireframe: PageWireframeInterface?

    fileprivate let interactor: PageInteractorInterface
    fileprivate var searchTerm: String?
    fileprivate var remoteDownloadURL: URL?
    fileprivate var userInterface: PageUserInterface?

    // mark: Init methods

    init(interactor: PageInteractorInterface = PageInteractor()) {
        self.interactor = interactor
        interactor.delegate = self
    }

    // mark: PagePresenterInterface methods

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

    // mark: PageUserInterfaceDelegate methods

    func userDidTapDone() {
        cancelDownloadAndFinish()
    }

    func userDidTapCancel() {
        cancelDownloadAndFinish()
    }

    func userDidTapShare(with image: UIImage) {
        wireframe?.showShareScreen(withImage: image)
    }

    // mark: PageInteractorDelegate methods

    func downloadDidFinish(forRemoteURL: URL, withFileURL fileURL: URL?, error: NSError?) {
        if let error = error {
            userInterface?.showErrorWithTitle(NSLocalizedString("Trouble Downloading PDF", comment: "Trouble Downloading PDF"),
                                              message: error.localizedDescription)
        } else {
            if let fileURL = fileURL {
                userInterface?.pdfPage = CGPDFDocument(fileURL as CFURL)?.page(at: 1)
            }
        }
        userInterface?.hideLoadingIndicator()
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

    // mark: Private methods

    fileprivate func cancelDownloadAndFinish() {
        if let url = remoteDownloadURL {
            interactor.cancelDownload(withRemoteURL: url)
        }
        wireframe?.dismiss()
    }
}
