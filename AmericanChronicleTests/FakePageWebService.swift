@testable import AmericanChronicle
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class FakePageWebService: PageWebServiceInterface {

    // MARK: Test stuff

    var downloadPage_arguments_URL: URL?
    var cancelDownload_arguments_URL: URL?
    var stubbed_isDownloadInProgress = false
    fileprivate var downloadPage_arguments_completionHandler: ((URL?, Error?) -> Void)?

    func fakeSuccess(withURL url: URL) {
        downloadPage_arguments_completionHandler?(url, nil)
    }

    func fakeFailure(withError error: Error) {
        downloadPage_arguments_completionHandler?(nil, error)
    }

    // MARK: PageWebServiceInterface conformance

    func downloadPage(withRemoteURL remoteURL: URL,
                      contextID: String,
                      completion: @escaping (URL?, Error?) -> Void) {
        downloadPage_arguments_URL = remoteURL
        downloadPage_arguments_completionHandler = completion
    }

    func cancelDownload(withRemoteURL remoteURL: URL, contextID: String) {
        cancelDownload_arguments_URL = remoteURL
    }

    func isDownloadInProgress(withRemoteURL remoteURL: URL) -> Bool {
        return stubbed_isDownloadInProgress
    }
}
