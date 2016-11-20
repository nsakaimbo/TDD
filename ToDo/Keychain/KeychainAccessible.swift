//
//  KeychainAccessible.swift
//  ToDo
//
//  Created by Nicholas Sakaimbo on 11/20/16.
//  Copyright © 2016 nick_skmbo. All rights reserved.
//

import Foundation

protocol KeychainAccessible {
    
    func setPassword(_ password: String, forAccount account: String)
    
    func deletePassword(_ password: String, forAccount account: String)
    
    func passwordForAccount(account: String) -> String?

}
