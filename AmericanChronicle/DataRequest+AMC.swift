import Alamofire
import ObjectMapper
import AlamofireObjectMapper

protocol DataRequestProtocol {
    var task: URLSessionTask? { get }
    func responseObj<T: BaseMappable>(completion: @escaping (DataResponse<T>) -> Void) -> Self
    func response(queue: DispatchQueue?, completion: @escaping (DefaultDataResponse) -> Void) -> Self
    func cancel()
}

extension DataRequest: DataRequestProtocol {
    func responseObj<T: BaseMappable>(completion: @escaping (DataResponse<T>) -> Void) -> Self {
        return responseObject(queue: nil,
                              keyPath: nil,
                              mapToObject: nil,
                              context: nil,
                              completionHandler: completion)
    }

    func response(queue: DispatchQueue?, completion: @escaping (DefaultDataResponse) -> Void) -> Self {
        return response(queue: queue, completionHandler: completion)
    }
}
