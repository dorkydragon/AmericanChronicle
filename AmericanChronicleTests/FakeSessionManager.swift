@testable import AmericanChronicle
import Alamofire

class FakeSessionManager: SessionManagerProtocol {

    // MARK: SessionManagerProtocol conformance

    func beginRequest(_ request: URLRequestConvertible) -> DataRequestProtocol {
            beginRequest_wasCalled_withRequest = request as? Router
            return stubbedReturnDataRequest
    }

    func download(_ url: URLConvertible,
                  to destination: DownloadRequest.DownloadFileDestination?) -> DownloadRequestProtocol {
        download_callLog.append((url, destination))
        let fileURL = URL(fileURLWithPath: "")
        let remoteURL: URL
        do {
            remoteURL = try url.asURL()
        } catch {
            fatalError()
        }
        let response = HTTPURLResponse(url: remoteURL,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)!
        _ = destination?(fileURL, response)
        download_wasCalled_handler?()
        return stubbedReturnDownloadRequest
    }

    // MARK: Test stuff

    var beginRequest_wasCalled_withRequest: Router?
    var stubbedReturnDataRequest = FakeDataRequest()

    var download_callLog: [(url: URLConvertible,
                            destination: DownloadRequest.DownloadFileDestination?)] = []
    var download_wasCalled_handler: (() -> Void)?
    var stubbedReturnDownloadRequest = FakeDownloadRequest()

}
