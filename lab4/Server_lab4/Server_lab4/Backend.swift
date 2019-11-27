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

    private let ideaService = IDEAService()
    private let authService = AuthService()
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
            let key = authService.getKey(token)?.key else {
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
    
    func getUserA(queryParams: [(String, String)]) -> ReturnType {
        guard
            let login = queryParams.getValueForKey("login"),
            let a = authService.getA(login: login)
            else {
                return .failure(.error("Пользователь не найден"))
        }
        return .success(JSON(["a" : a]))
    }
    
    func checkUser(params: [String:String]) -> ReturnType {
        guard
            let password = params["password"],
            let login = params["login"] else {
                return .failure(.error("На задан логин или пароль"))
        }
        guard authService.isValidUser(login: login, password: password) else {
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
        
        authService.loginUser(login: login, key: RSAService.Key(exponent, modulus))

        return .success(JSON())
    }
    
    func checkOTP(params: [String : String]) -> ReturnType {
        guard
            let login = params["login"],
            let userAuthData = authService.getCurrentUserAuthData(login)
            else {
                return .failure(.error("Неправильрный токен"))
        }
        guard
            let otp = params["otp"],
            userAuthData.otp == otp
            else {
//                currentSessions.removeValue(forKey: token)
                return .failure(.error("Неправильрный otp"))
        }
        authService.removeCurrentUserAuthData(login)
        let token = userAuthData.token
        return .success(JSON(["key" : authService.getKey(token)!.encodedKey,
                              "token" : token]))

    }
    
}
