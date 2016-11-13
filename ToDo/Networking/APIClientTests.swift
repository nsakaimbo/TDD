//
//  APIClientTests.swift
//  ToDo
//
//  Created by Nicholas Sakaimbo on 11/13/16.
//  Copyright © 2016 nick_skmbo. All rights reserved.
//

import XCTest
@testable
import ToDo

class APIClientTests: XCTestCase {
    
    var sut: APIClient!
    var mockURLSession: MockURLSession!
    
    override func setUp() {
        
        super.setUp()

        sut = APIClient()
        mockURLSession = MockURLSession()
        sut.session = mockURLSession
        
        let completion = { (error: Error?) in }
        
        sut.loginUser(name: "dasdöm",
                      password: "%&34",
                      completion: completion)
    }
    
    func testLogin_MakesRequestWithUsernameAndPassword() {
        
        XCTAssertNotNil(mockURLSession.completionHandler)
        
        guard let request = mockURLSession.urlRequest,
            let url = request.url else {
                XCTFail()
                return
        }
        
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        XCTAssertEqual(urlComponents?.host, "awesometodos.com")
        
        XCTAssertEqual(urlComponents?.path, "/login")
        
        let allowedCharacters = CharacterSet(charactersIn: "/%&?$#+-~@<>|\\*,.()[]{}^!").inverted
        
        guard let expectedUserName = "dasdöm".addingPercentEncoding(withAllowedCharacters: allowedCharacters) else {
            XCTFail("Error. Could not encode username with allowed characters.")
            return
        }
        
        guard let expectedPassword = "%&34".addingPercentEncoding(withAllowedCharacters: allowedCharacters) else {
            XCTFail("Error. Could not encode password with allowed characters.")
            return
        }
        
        XCTAssertEqual(urlComponents?.percentEncodedQuery, "username=\(expectedUserName)&password=\(expectedPassword)")
    }
    
    func testLogin_CallsResumeOfDataTask() {
        XCTAssertTrue(mockURLSession.dataTask.resumeGotCalled)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
}

extension APIClientTests {
    
    class MockURLSession: ToDoURLSession {
        typealias  Handler = (Data?, URLResponse?, Error?) -> Void
        
        var completionHandler: Handler?
        var urlRequest: URLRequest?
        var dataTask = MockURLSessionDataTask()
        
        func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            
            self.urlRequest = request
            self.completionHandler = completionHandler
            
            return dataTask
        }
    }
    
    class MockURLSessionDataTask: URLSessionDataTask {
        var resumeGotCalled = false
        
        override func resume() {
            resumeGotCalled = true
        }
    }
}
