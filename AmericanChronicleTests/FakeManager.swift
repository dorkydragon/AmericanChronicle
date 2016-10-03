@testable import AmericanChronicle
import Alamofire

class FakeManager: ManagerProtocol {

    var request_wasCalled_withURL: URLConvertible?
    var request_wasCalled_withParameters: Parameters?
    var stubbedReturnDataRequest = FakeDataRequest()
    func request(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters?) -> DataRequestProtocol {
            request_wasCalled_withURL = url
            request_wasCalled_withParameters = parameters
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
