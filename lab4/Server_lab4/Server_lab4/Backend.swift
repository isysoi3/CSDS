//
//  Backend.swift
//  lab2
//
//  Created by Ilya Sysoi on 10/2/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation
import SwiftyJSON
import BigInt
import KeychainSwift

enum BackendErrorEnum: Error {
    case error(String)
}

typealias ProcessRequest = (JSON) -> Result<JSON, BackendErrorEnum>

class Backend {
    
    typealias ReturnType = Result<JSON, BackendErrorEnum>

    private let validUsers = users
    private var currentSessions: [String : UserAuthInfo] = [:]
    private let ideaService = IDEAService()
    private let rsaService = RSAService()
    private let mailService = MailService()
    private let key: String
    
    init() {
        let keychain = KeychainSwift()
        if let key = keychain.get("Key") {
            self.key = key
        } else {
            key = String.generateRandomString(length: 16)
            keychain.set(key, forKey: "Key")
        }
//        let text = """
//                   """
//        try? FileService.write(text, to: "test", with: key)
    }
    
    func getFiles() -> ReturnType {
        guard let files = FileService.getFiles() else {
            return .failure(.error("Проблема с получением списка файлов"))
        }
        return .success(JSON(files.map { $0.prefix(while: { c in c != "."})}))
    }
    
    func getFile(queryParams: [(String, String)]) -> ReturnType {
        guard let token = queryParams.getValueForKey("token"),
            let key = currentSessions[token]?.key else {
            return .failure(.error("Неправильрный токен"))
        }
        guard let filename = queryParams.getValueForKey("name") else {
            return .failure(.error("На задано имя файла"))
        }
        guard FileService.containsFile(name: filename) else {
            return .failure(.error("\(filename) не найден"))
        }
        guard let text = try? FileService.read(from: "test", with: self.key) else {
            return .failure(.error("Не удалось прочитать файл"))
        }
        let encoded = ideaService.encode(text: text,
                                         key: key)
        return .success(JSON(["text" : encoded]))
    }
    
    func checkUser(params: [String:String]) -> ReturnType {
        guard
            let password = params["password"],
            let login = params["login"] else {
                return .failure(.error("На задан логин или пароль"))
        }
        guard
            let user = validUsers.first(where: { $0.login == login }),
            user.password == password else {
                return .failure(.error("Неправильный логин или пароль"))
        }
        guard
            let e = params["keyExponent"],
            let m = params["keyModulus"] else {
                return .failure(.error("На задан ключ RSA"))
        }
        let eS = e.replacingOccurrences(of: "%2B", with: "+").replacingOccurrences(of: "%3D", with: "=")
        let mS = m.replacingOccurrences(of: "%2B", with: "+").replacingOccurrences(of: "%3D", with: "=")
        let exponent = BigUInt(eS.base64Data!)
        let modulus = BigUInt(mS.base64Data!)
        let randomKey = String.generateRandomString(length: 16)
        let encodedText: BigUInt = rsaService.encode(
            text: randomKey,
            publicKey: RSAService.Key(exponent: exponent,
                                      modulus: modulus))
        
        let randomToken = String.generateRandomString(length: 9)
        let userAuth = UserAuthInfo(key: randomKey,
                                    encodedKey: Array(encodedText.serialize()))
        currentSessions[randomToken] = userAuth
        mailService.sendOTPInMessage(to: user.mail,
                                     message: "Login: \(user.login)\nOTP:\(userAuth.otp)")
        return .success(JSON(["token" : randomToken]))
    }
    
    func checkOTP(params: [String : String]) -> ReturnType {
        guard
            let token = params["token"],
            let authInfo = currentSessions[token]
            else {
                return .failure(.error("Неправильрный токен"))
        }
        guard
            let otpString = params["otp"],
            let otp = Int(otpString),
            authInfo.otp == otp
            else {
                currentSessions.removeValue(forKey: token)
                return .failure(.error("Неправильрный otp"))
        }
        return .success(JSON(["key" : authInfo.encodedKey,
                              "token" : token]))

    }
    
}
