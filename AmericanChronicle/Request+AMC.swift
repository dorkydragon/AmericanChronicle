import Alamofire
import ObjectMapper
import AlamofireObjectMapper

protocol DataRequestProtocol {
    var task: URLSessionTask? { get }
    func responseObj<T: BaseMappable>(completionHandler: @escaping (DataResponse<T>) -> Void) -> Self
    func response(queue: DispatchQueue?, completionHandler: @escaping (DefaultDataResponse) -> Void) -> Self
    func cancel()
}

extension DataRequest: DataRequestProtocol {
    func responseObj<T: BaseMappable>(completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return responseObject(queue: nil,
                              keyPath: nil,
                              mapToObject: nil,
                              context: nil,
                              completionHandler: completionHandler)
    }
}

protocol DownloadRequestProtocol {
    func response(queue: DispatchQueue?, completionHandler: @escaping (DefaultDownloadResponse) -> Void) -> Self
    func cancel()
}

extension DownloadRequest: DownloadRequestProtocol {
}
