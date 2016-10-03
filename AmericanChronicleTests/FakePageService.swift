@testable import AmericanChronicle
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class FakePageService: PageServiceInterface {

    var downloadPage_wasCalled_withURL: URL?
    var downloadPage_wasCalled_withCompletionHandler: ((URL?, Error?) -> ())?
    func downloadPage(_ remoteURL: URL,
                      contextID: String,
                      completionHandler: @escaping (URL?, Error?) -> Void) {
        downloadPage_wasCalled_withURL = remoteURL
        downloadPage_wasCalled_withCompletionHandler = completionHandler
    }

    var cancelDownload_wasCalled_withURL: URL?
    func cancelDownload(_ remoteURL: URL, contextID: String) {
        cancelDownload_wasCalled_withURL = remoteURL
    }

    var stubbed_isDownloadInProgress = false
    func isDownloadInProgress(_ remoteURL: URL) -> Bool {
        return stubbed_isDownloadInProgress
    }
}
