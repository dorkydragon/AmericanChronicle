// mark: -
// mark: PageInteractorInterface protocol

protocol PageInteractorInterface: class {
    var delegate: PageInteractorDelegate? { get set }

    func startDownload(withRemoteURL: URL)
    func cancelDownload(withRemoteURL: URL)
    func isDownloadInProgress(withRemoteURL: URL) -> Bool
    func startOCRCoordinatesRequest(withID: String)
}

// mark: -
// mark: PageInteractorDelegate protocol

protocol PageInteractorDelegate: class {
    func downloadDidFinish(forRemoteURL: URL, withFileURL: URL?, error: NSError?)
    func requestDidFinish(withOCRCoordinates: OCRCoordinates?, error: NSError?)
}

// mark: -
// mark: PageInteractor class

final class PageInteractor: PageInteractorInterface {

    // mark: Properties

    weak var delegate: PageInteractorDelegate?
    fileprivate let pageService: PageWebServiceInterface
    fileprivate let cachedPageService: PageCacheServiceInterface
    fileprivate let coordinatesService: OCRCoordinatesWebServiceInterface
    fileprivate var contextID: String { return "\(Unmanaged.passUnretained(self).toOpaque())" }

    // mark: Init methods

    init(pageService: PageWebServiceInterface = PageWebService(),
         cachedPageService: PageCacheServiceInterface = PageCacheService(),
         coordinatesService: OCRCoordinatesWebServiceInterface = OCRCoordinatesWebService()) {
        self.pageService = pageService
        self.cachedPageService = cachedPageService
        self.coordinatesService = coordinatesService
    }

    // mark: PageInteractorInterface methods

    func startDownload(withRemoteURL remoteURL: URL) {
        if let fileURL = cachedPageService.fileURLForRemoteURL(remoteURL) {
            delegate?.downloadDidFinish(forRemoteURL: remoteURL, withFileURL: fileURL, error: nil)
            return
        }

        pageService.downloadPage(withRemoteURL: remoteURL, contextID: contextID) { [weak self] fileURL, error in
            if let fileURL = fileURL, error == nil {
                self?.cachedPageService.cacheFileURL(fileURL, forRemoteURL: remoteURL)
            }
            self?.delegate?.downloadDidFinish(forRemoteURL: remoteURL, withFileURL: fileURL, error: error as? NSError)
        }
    }

    func cancelDownload(withRemoteURL remoteURL: URL) {
        pageService.cancelDownload(withRemoteURL: remoteURL, contextID: contextID)
    }

    func isDownloadInProgress(withRemoteURL remoteURL: URL) -> Bool {
        return pageService.isDownloadInProgress(withRemoteURL: remoteURL)
    }

    func startOCRCoordinatesRequest(withID id: String) {
        coordinatesService.startRequest(id, contextID: contextID, completion: {
            [weak self] coordinates, err in
            self?.delegate?.requestDidFinish(withOCRCoordinates: coordinates, error: err as? NSError)
        })
    }
}
