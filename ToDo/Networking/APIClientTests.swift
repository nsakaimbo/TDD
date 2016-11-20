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

// - We make our MockURLSession conform to the ToDoURLSession protocol, and make the system-defined URLSession retroactively conform to this protocol as well.
// - The System Under Test - API Client - defines its URLSession variable as an instance of the protocol, and not a concrete class. This allows us to swap our MockURLSession for the default URLSession (URLSession.shared) during testing. 
// - We can then fake the server responses and make assertions against them
// - A similar approach follows for the keychainManager property via the KeychainAccessible protocol.

// TODO: To further develop the API client implementation, we could add tests + functionality for:
// - Fetching an item from the web service
// - Posting an item to the web service
// - Accessing an item from the web service
// The above tests would look similar to the tests we have so far.

class APIClientTests: XCTestCase {
    
    var sut: APIClient!
    var mockURLSession: MockURLSession!
    var mockKeychainManager: MockKeychainManager!
    
    override func setUp() {
        
        super.setUp()

        sut = APIClient()
        
        mockURLSession = MockURLSession()
        sut.session = mockURLSession
        
        mockKeychainManager = MockKeychainManager()
        sut.keychainManager = mockKeychainManager
        
        let completion = { (error: Error?) in }
        
        sut.loginUser(name: "dasdöm",
                      password: "%&34",
                      completion: completion)
    }
    
    // MARK: Login
    
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
    
    // MARK: Keychain
    // - We override the default setup() to test keychain behavior by calling the completionHandler with specific inputs where necessary
    
    func testLogin_SetsToken() {
        
        let responseDict = ["token" : "1234567890"]
        let responseData = try! JSONSerialization.data(withJSONObject: responseDict, options: [])
        mockURLSession.completionHandler?(responseData, nil, nil)
        
        let token = mockKeychainManager.passwordForAccount(account: "token")
        XCTAssertEqual(token, responseDict["token"])
    }
    
    func testLogin_ThrowsErrorWhenJSONIsInvalid() {
        
        var theError: Error?
        
        let completion = { (error: Error?) in
            theError = error
        }
        
        sut.loginUser(name: "dasdöm", password: "1234", completion: completion)
        
        let responseData = Data()
        mockURLSession.completionHandler?(responseData, nil, nil)
        
        XCTAssertNotNil(theError)
    }
    
    func testLogin_ThrowsErrorWhenDataIsNil() {
        
        var theError: Error?
        
        let completion = { (error: Error?) in
            theError = error
        }
        
        sut.loginUser(name: "dasdöm", password: "1234", completion: completion)
        
        mockURLSession.completionHandler?(nil, nil, nil)
        
        XCTAssertNotNil(theError)
    }
    
    func testLogin_ThrowsErrorWhenResponseHasError() {
        
        var theError: Error?
        
        let completion = { (error: Error?) in
            theError = error
        }
        
        sut.loginUser(name: "dasdöm", password: "1234", completion: completion)
        
        // We stub a non-nil error being returned by the dataTask, implying an error with the server response
        let responseDict = ["token": "1234567890"]
        let responseData = try! JSONSerialization.data(withJSONObject: responseDict, options: [])
        let error = StubError.stub
        mockURLSession.completionHandler?(responseData, nil, error)
        
        // We expect the dataTask error will result in the error being populated in the completion block of the loginUser(name:password:completion:) method
        XCTAssertNotNil(theError)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
}

extension APIClientTests {
    
    enum StubError: Error {
        case stub
    }
    
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
    
    class MockKeychainManager: KeychainAccessible {
        var passwordDict = [String:String]()
        
        func setPassword(_ password: String, forAccount account: String) {
            passwordDict[account] = password
        }
        
        func deletePassword(_ password: String, forAccount account: String) {
            passwordDict.removeValue(forKey: account)
        }
        
        func passwordForAccount(account: String) -> String? {
            return passwordDict[account]
        }
    }
}
