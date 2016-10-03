@testable import AmericanChronicle
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class FakeDataRequest: DataRequestProtocol {

    var task: URLSessionTask? = URLSessionTask()

    fileprivate var responseObjectWasCalled_withCompletionHandler: Any?
    fileprivate var responseWasCalled_withCompletionHandler: ((NSURLRequest?, HTTPURLResponse?, NSData?, Error?) -> Void)?

    func responseObj<T: BaseMappable>(completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        responseObjectWasCalled_withCompletionHandler = completionHandler
        return self
    }

    func response(queue: DispatchQueue?, completionHandler: @escaping (DefaultDataResponse) -> Void) -> Self {
        return self
    }

    var cancel_wasCalled = false
    func cancel() {
        cancel_wasCalled = true
    }

    func finishWithResponseObject<T: Mappable>(_ responseObject: DataResponse<T>) {
        let handler = responseObjectWasCalled_withCompletionHandler as? ((DataResponse<T>) -> Void)
        handler?(responseObject)
    }

    func finishWithRequest(_ request: NSURLRequest?, response: HTTPURLResponse?, data: NSData?, error: NSError?) {
        responseWasCalled_withCompletionHandler?(request, response, data, error)
    }
}
