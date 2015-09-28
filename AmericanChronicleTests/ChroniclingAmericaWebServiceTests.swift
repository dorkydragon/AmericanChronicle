//
//  ChroniclingAmericaWebServiceTests.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/10/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit
import XCTest
import AmericanChronicle
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class FakeManager: ManagerProtocol {

    var request_wasCalled_withMethod: Alamofire.Method?
    var request_wasCalled_withURLString: URLStringConvertible?
    var request_wasCalled_withParameters: [String: AnyObject]?
    var request_wasCalled_withReturnedRequest: RequestProtocol?

    func request(
        method: Alamofire.Method,
        URLString: URLStringConvertible,
        parameters: [String: AnyObject]?) -> RequestProtocol? {
            request_wasCalled_withMethod = method
            request_wasCalled_withURLString = URLString
            request_wasCalled_withParameters = parameters
            request_wasCalled_withReturnedRequest = FakeRequest()
            return request_wasCalled_withReturnedRequest
    }

    var download_wasCalled_withMethod: Alamofire.Method?
    var download_wasCalled_withURLString: URLStringConvertible?
    var download_wasCalled_withParameters: [String: AnyObject]?
    var download_wasCalled_withDestination: Request.DownloadFileDestination?
    var download_wasCalled_withReturnedRequest: RequestProtocol?

    func download(
        method: Alamofire.Method,
        URLString: URLStringConvertible,
        parameters: [String: AnyObject]?, destination: Request.DownloadFileDestination) -> RequestProtocol? {
            download_wasCalled_withMethod = method
            download_wasCalled_withURLString = URLString
            download_wasCalled_withParameters = parameters
            download_wasCalled_withDestination = destination
            download_wasCalled_withReturnedRequest = FakeRequest()
            return download_wasCalled_withReturnedRequest
    }
}

class FakeRequest: RequestProtocol {
    var task: NSURLSessionTask {
        return NSURLSessionTask()
    }
    var responseObject_wasCalled = false
    var responseObject_wasCalled_withCompletionHandler: Any?
    func responseObject<T: Mappable>(completionHandler: (T?, ErrorType?) -> Void) -> Self {
        responseObject_wasCalled = true
        responseObject_wasCalled_withCompletionHandler = completionHandler
        return self
    }

    var response_wasCalled = false
    var response_wasCalled_withCompletionHandler: Any?
    func response(completionHandler: (NSURLRequest?, NSHTTPURLResponse?, NSData?, ErrorType?) -> Void) -> Self {
        response_wasCalled = true
        response_wasCalled_withCompletionHandler = completionHandler
        return self
    }

    var cancel_wasCalled = false
    func cancel() {
        cancel_wasCalled = true
    }
}

class ChroniclingAmericaWebServiceTests: XCTestCase {

    var subject: ChroniclingAmericaWebService!
    var manager: FakeManager!
    override func setUp() {
        super.setUp()
        manager = FakeManager()
        subject = ChroniclingAmericaWebService(manager: manager)
    }

    func testThat_whenPerformSearchIsCalled_itIncludesSearchTermInTheParameters() {
        subject.performSearch("test term", page: 0, andThen: nil)
        let parameter = manager.request_wasCalled_withParameters?["proxtext"] as? String
        XCTAssertEqual(parameter ?? "", "test term")
    }

    func testThat_whenPerformSearchIsCalled_itIncludesPageNumberInTheParameters() {
        subject.performSearch("", page: 3, andThen: nil)
        let parameter = manager.request_wasCalled_withParameters?["page"] as? Int
        XCTAssertEqual(parameter ?? 0, 3)
    }

    func testThat_whenThePerformSearchRequestFails_itPassesAlongTheError() {
        var returnedError: NSError?
        subject.performSearch("", page: 3) { _, error in
            returnedError = error as? NSError
        }
        let request = manager.request_wasCalled_withReturnedRequest as? FakeRequest
        let error = NSError(domain: "", code: 0, userInfo: nil)
        let handler = request?.responseObject_wasCalled_withCompletionHandler as? (SearchResults?, ErrorType?) -> Void
        handler?(nil, error)
        XCTAssertEqual(returnedError, error)
    }

    func testThat_whenThePerformSearchRequestSucceeds_itPassesAlongTheSearchResults() {
        var returnedResults: SearchResults?
        subject.performSearch("", page: 3) { results, _ in
            returnedResults = results
        }
        let request = manager.request_wasCalled_withReturnedRequest as? FakeRequest
        let map = Map(mappingType: MappingType.FromJSON, JSONDictionary: [:])
        let results = SearchResults(map)
        let handler = request?.responseObject_wasCalled_withCompletionHandler as? (SearchResults?, NSError?) -> Void
        handler?(results, nil)
        XCTAssertEqual(returnedResults!, results)
    }

    func testThat_whenAPDFDownloadSucceeds_itPassesAlongTheFilePath() {

    }

}
