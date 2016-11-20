//
//  APIClient.swift
//  ToDo
//
//  Created by Nicholas Sakaimbo on 11/13/16.
//  Copyright © 2016 nick_skmbo. All rights reserved.
//

import Foundation

protocol ToDoURLSession {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: ToDoURLSession {}

class APIClient {
    
    enum WebServiceError: Error {
        case dataEmpty
        case response
    }
    
    lazy var session: ToDoURLSession = URLSession.shared
    
    var keychainManager: KeychainAccessible?
    
    func loginUser(name: String, password: String, completion: @escaping (Error?) -> Void) {
        
        let allowedCharacters = CharacterSet(charactersIn: "/%&?$#+-~@<>|\\*,.()[]{}^!").inverted
        
        guard let encodedUsername = name.addingPercentEncoding(withAllowedCharacters: allowedCharacters) else {
            fatalError("Error. Could not percent encode username.")
        }
        
        guard let encodedPassword = password.addingPercentEncoding(withAllowedCharacters: allowedCharacters) else {
            fatalError("Error. Could not percent encode password.")
        }
        
        guard let url = URL(string: "https://awesometodos.com/login?username=\(encodedUsername)&password=\(encodedPassword)") else { fatalError() }
        
        let urlRequest = URLRequest(url: url)
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            guard error == nil else {
                completion(WebServiceError.response)
                return
            }
            
            guard let data = data else {
                completion(WebServiceError.dataEmpty)
                return
            }
            
            do {
                let response = try JSONSerialization.jsonObject(with: data, options: [])
                
                if let responseDict = response as? [String:Any],
                    let token = responseDict["token"] as? String {
                    
                    self.keychainManager?.setPassword(token, forAccount: "token")
                }
            }
            catch {
                completion(error)
            }
        }
        task.resume()
    }
}
