@testable import AmericanChronicle
import Alamofire

class FakeSessionManager: SessionManagerProtocol {

    var beginRequest_wasCalled_withRequest: Router?
    var stubbedReturnDataRequest = FakeDataRequest()
    func beginRequest(_ request: URLRequestConvertible) -> DataRequestProtocol {
            beginRequest_wasCalled_withRequest = request as? Router
            return stubbedReturnDataRequest
    }

    var download_wasCalled_withURL: URLConvertible?
    var download_wasCalled_withParameters: [String: AnyObject]?
    var download_wasCalled_handler: (() -> Void)?
    var stubbedReturnDownloadRequest = FakeDownloadRequest()
    func download(_ url: URLConvertible, to destination: DownloadRequest.DownloadFileDestination?) -> DownloadRequestProtocol {
            download_wasCalled_withURL = url
            download_wasCalled_handler?()
            return stubbedReturnDownloadRequest
    }
}
