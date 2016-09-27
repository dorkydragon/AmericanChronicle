// mark: -
// mark: PageInteractorInterface protocol

protocol PageInteractorInterface: class {
    var delegate: PageInteractorDelegate? { get set }

    func startDownloadWithRemoteURL(_ remoteURL: URL)
    func cancelDownloadWithRemoteURL(_ remoteURL: URL)
    func isDownloadWithRemoteURLInProgress(_ remoteURL: URL) -> Bool
    func startOCRCoordinatesRequestWithID(_ id: String)
}

// mark: -
// mark: PageInteractorDelegate protocol

protocol PageInteractorDelegate: class {
    func download(_ remoteURL: URL, didFinishWithFileURL fileURL: URL?, error: NSError?)
    func requestDidFinishWithOCRCoordinates(_ coordinates: OCRCoordinates?, error: NSError?)
}

// mark: -
// mark: PageInteractor class

final class PageInteractor: PageInteractorInterface {

    // mark: Properties

    weak var delegate: PageInteractorDelegate?
    fileprivate let dataManager: PageDataManagerInterface

    // mark: Init methods

    init(dataManager: PageDataManagerInterface = PageDataManager()) {
        self.dataManager = dataManager
    }

    // mark: PageInteractorInterface methods

    func startDownloadWithRemoteURL(_ remoteURL: URL) {
        dataManager.downloadPage(remoteURL, completionHandler: { remoteURL, fileURL, error in
            self.delegate?.download(remoteURL, didFinishWithFileURL: fileURL, error: error)
        })
    }

    func cancelDownloadWithRemoteURL(_ remoteURL: URL) {
        dataManager.cancelDownload(remoteURL)
    }

    func isDownloadWithRemoteURLInProgress(_ remoteURL: URL) -> Bool {
        return dataManager.isDownloadInProgress(remoteURL)
    }

    func startOCRCoordinatesRequestWithID(_ id: String) {
        dataManager.startOCRCoordinatesRequest(id) { coordinates, error in
            self.delegate?.requestDidFinishWithOCRCoordinates(coordinates, error: error)
        }
    }
}
