@testable import AmericanChronicle

class FakePageDataManager: PageDataManagerInterface {

    var downloadPage_wasCalled_withRemoteURL: URL?
    var downloadPage_wasCalled_withCompletionHandler: ((URL, URL?, NSError?) -> Void)?
    func downloadPage(_ remoteURL: URL, completionHandler: @escaping (URL, URL?, NSError?) -> Void) {
        downloadPage_wasCalled_withRemoteURL = remoteURL
        downloadPage_wasCalled_withCompletionHandler = completionHandler
    }

    var cancelDownload_wasCalled_withRemoteURL: URL?
    func cancelDownload(_ remoteURL: URL) {
        cancelDownload_wasCalled_withRemoteURL = remoteURL
    }

    func isDownloadInProgress(_ remoteURL: URL) -> Bool {
        return false
    }

    func startOCRCoordinatesRequest(_ id: String,
                                    completionHandler: @escaping (OCRCoordinates?, NSError?) -> Void) {

    }

    func cancelOCRCoordinatesRequest(_ id: String) {

    }

    func isOCRCoordinatesRequestInProgress(_ id: String) -> Bool {
        return false
    }
}
