@testable import AmericanChronicle
import Alamofire

class FakeDownloadRequest: DownloadRequestProtocol {

    // MARK: DownloadRequestProtocol conformance

    func response(queue: DispatchQueue?, completion: @escaping (DefaultDownloadResponse) -> Void) -> Self {
        response_callLog.append((queue, completion))
        return self
    }

    func cancel() {
        cancel_callCount += 1
    }

    // MARK: Test stuff

    var response_callLog: [(queue: DispatchQueue?,
                            completion: (DefaultDownloadResponse) -> Void)] = []

    var cancel_callCount = 0

    func finishWithRequest(_ request: URLRequest?,
                           response: HTTPURLResponse?,
                           destinationURL: URL?,
                           error: Error?) {
        let response = DefaultDownloadResponse(request: request,
                                               response: response,
                                               temporaryURL: nil,
                                               destinationURL: destinationURL,
                                               resumeData: nil,
                                               error: error)
        for call in response_callLog {
            call.completion(response)
        }
    }
}
