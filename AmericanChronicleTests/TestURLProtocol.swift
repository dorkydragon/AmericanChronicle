import UIKit

class TestURLProtocol: URLProtocol {

    static var instancesLoading: [String: TestURLProtocol] = [:]
    static var didStartLoadingCallbacks: [String: ((Void) -> ())] = [:]

    override init(request: URLRequest, cachedResponse: CachedURLResponse?, client: URLProtocolClient?) {
        super.init(request: request, cachedResponse: cachedResponse, client: client)
    }

    class func finishLoading(_ URL: String) {
        if let instance = instancesLoading[URL] {
            instance.client?.urlProtocolDidFinishLoading(instance)
        }
    }

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override func startLoading() {
        if let callback = TestURLProtocol.didStartLoadingCallbacks[request.url?.absoluteString ?? ""] {
            callback()
        }
        TestURLProtocol.instancesLoading[request.url?.absoluteString ?? ""] = self
    }

    override func stopLoading() {
        TestURLProtocol.instancesLoading[request.url?.absoluteString ?? ""] = nil
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

}
