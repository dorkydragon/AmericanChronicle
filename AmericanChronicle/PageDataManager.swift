// mark: -
// mark: PageDataManagerInterface protocol

/**
 Conforming types can be used as the Page module's data manager.
 */
protocol PageDataManagerInterface {
    func downloadPage(_ remoteURL: URL, completionHandler: @escaping (URL, URL?, NSError?) -> Void)
    func cancelDownload(_ remoteURL: URL)
    func isDownloadInProgress(_ remoteURL: URL) -> Bool
    func startOCRCoordinatesRequest(_ id: String,
                                    completionHandler: @escaping (OCRCoordinates?, NSError?) -> Void)
    func cancelOCRCoordinatesRequest(_ id: String)
    func isOCRCoordinatesRequestInProgress(_ id: String) -> Bool
}

// mark: -
// mark: PageDataManager class

/**
 Responsibilities:
    - Knows which service to use.
 */
final class PageDataManager: PageDataManagerInterface {


    // mark: Properties

    fileprivate let pageService: PageServiceInterface
    fileprivate let cachedPageService: CachedPageServiceInterface
    fileprivate let coordinatesService: OCRCoordinatesServiceInterface
    fileprivate var contextID: String { return "\(Unmanaged.passUnretained(self).toOpaque())" }

    // mark: Init methods

    /**
        - Parameters:
            - pageService: The service to use for API requests.
            - cachedPageService: The service to check before making API requests.
    */
    required init(pageService: PageServiceInterface = PageService(),
                  cachedPageService: CachedPageServiceInterface = CachedPageService(),
                  coordinatesService: OCRCoordinatesServiceInterface = OCRCoordinatesService()) {
        self.pageService = pageService
        self.cachedPageService = cachedPageService
        self.coordinatesService = coordinatesService
    }

    // mark: PageDataManagerInterface methods

    internal func downloadPage(_ remoteURL: URL, completionHandler: @escaping (URL, URL?, NSError?) -> Void) {
        if let fileURL = cachedPageService.fileURLForRemoteURL(remoteURL) {
            completionHandler(remoteURL, fileURL, nil)
            return
        }

        pageService.downloadPage(remoteURL, contextID: contextID) { fileURL, error in
            if let fileURL = fileURL, error == nil {
                self.cachedPageService.cacheFileURL(fileURL, forRemoteURL: remoteURL)
            }
            completionHandler(remoteURL, fileURL, error as? NSError)
        }
    }

    func cancelDownload(_ remoteURL: URL) {
        pageService.cancelDownload(remoteURL, contextID: contextID)
    }

    func isDownloadInProgress(_ remoteURL: URL) -> Bool {
        return pageService.isDownloadInProgress(remoteURL)
    }

    internal func startOCRCoordinatesRequest(_ id: String, completionHandler: @escaping (OCRCoordinates?, NSError?) -> Void) {
        coordinatesService.startRequest(id,
                                        contextID: contextID,
                                        completionHandler: { coordinates, err in
            completionHandler(coordinates, err as? NSError)
        })
    }

    func cancelOCRCoordinatesRequest(_ id: String) {
        coordinatesService.cancelRequest(id, contextID: contextID)
    }

    func isOCRCoordinatesRequestInProgress(_ id: String) -> Bool {
        return coordinatesService.isRequestInProgress(id, contextID: contextID)
    }
}
