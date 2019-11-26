//
//  AuthService.swift
//  Server_lab4
//
//  Created by Ilya Sysoi on 11/24/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation
import BigInt

class AuthService {
    
    private let validUsers = users
    private var currentSessions: [String : UserAuthInfo] = [:] //token to info
    private var currentUsers: [String : (otp: String, token: String)] = [:] //login to otp with token
    
    private let rsaService = RSAService()
    private let mailService = MailService()
    
    func isValidUser(login: String, password: String) -> Bool {
        if let user = validUsers.first(where: { $0.login == login }) {
            return user.password == password
        }
        return false
    }
    
    func loginUser(login: String, key: RSAService.Key) {
        let user = validUsers.first(where: { $0.login == login })!
        let randomKey = String.generateRandomString(length: 16)
        let encodedText: BigUInt = rsaService.encode(text: randomKey, publicKey: key)
        
        let randomToken = String.generateRandomString(length: 9)
        let userAuth = UserAuthInfo(key: randomKey,
                                    encodedKey: Array(encodedText.serialize()))
        let otp = String(Int.random(in: 100000...999999))
        
        currentSessions[randomToken] = userAuth
        currentUsers[login] = (otp, randomToken)
        
        mailService.sendOTPInMessage(to: user.mail,
                                     message: "Login: \(user.login)\nOTP:\(otp)")
    }
    
    func getCurrentUserAuthData(_ login: String) -> (otp: String, token: String)? {
        currentUsers[login]
    }
    
    func removeCurrentUserAuthData(_ login: String) {
        currentUsers.removeValue(forKey: login)
    }
    
    func getKey(_ token: String) -> UserAuthInfo? {
        currentSessions[token]
    }
    
    
    let n = 10000
    private(set) var a: Int = 1
    
    func checkClient(hash: Int, clientNHash: Int) -> Bool {
        let isValid = nHash(a, text: String(hash)) == clientNHash
        if isValid {
            a += 1
        }
        return isValid
    }
    
    func nHash(_ n: Int, text: String) -> Int {
        guard n != 0 else {
            fatalError()
        }
        
        let hash = djb2Hash(text)
        guard n != 1 else {
            print(hash)
            return hash
        }
        return nHash(n - 1, text: String(hash))
    }
    
    private func djb2Hash(_ string: String) -> Int {
      let unicodeScalars = string.unicodeScalars.map { $0.value }
      return unicodeScalars.reduce(5381) {
        ($0 << 5) &+ $0 &+ Int($1)
      }
    }
    
}
