//
//  User.swift
//  Server_lab4
//
//  Created by Ilya Sysoi on 11/25/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation

struct User: Hashable {
    
    let login: String
    let mail: String
    let password: String
    
}

struct UserAuthInfo {

    let encodedKey: [UInt8]
    let key: String
    let otp: Int
    
    init(key: String, encodedKey: [UInt8]) {
        self.key = key
        self.encodedKey = encodedKey
        otp = Int.random(in: 100000...999999)
    }
    
}

let users = [User(login: "test1", mail: "14_ilya@mail.ru", password: "123"),
             User(login: "test1", mail: "14_ilya@mail.ru", password: "123"),
             User(login: "test1", mail: "14_ilya@mail.ru", password: "123")]
