@testable import AmericanChronicle
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class FakeDataRequest: DataRequestProtocol {

    var task: URLSessionTask? = URLSessionTask()

    fileprivate var responseObjectWasCalled_withCallback: Any?
    fileprivate var responseWasCalled_withCallback: ((NSURLRequest?, HTTPURLResponse?, NSData?, Error?) -> Void)?

    func responseObj<T: BaseMappable>(completion: @escaping (DataResponse<T>) -> Void) -> Self {
        responseObjectWasCalled_withCallback = completion
        return self
    }

    func response(queue: DispatchQueue?, completion: @escaping (DefaultDataResponse) -> Void) -> Self {
        return self
    }

    var cancel_wasCalled = false
    func cancel() {
        cancel_wasCalled = true
    }

    func finishWithResponseObject<T: Mappable>(_ responseObject: DataResponse<T>) {
        let handler = responseObjectWasCalled_withCallback as? ((DataResponse<T>) -> Void)
        handler?(responseObject)
    }

    func finishWithRequest(_ request: NSURLRequest?,
                           response: HTTPURLResponse?,
                           data: NSData?,
                           error: NSError?) {
        responseWasCalled_withCallback?(request, response, data, error)
    }
}
