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

    private let validUsers = ["test1" : "123",
                              "test2" : "123",
                              "test3" : "123"]
    private var currentSessions: [String : String] = [:]
    private let ideaService = IDEAService()
    private let rsaService = RSAService()
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
            let key = currentSessions[token] else {
            return .failure(.error("На токен"))
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
            let validPasswordForUser = validUsers[login],
            password == validPasswordForUser else {
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
        let randomSting = String.generateRandomString(length: 16)
        let encodedText: BigUInt = rsaService.encode(
            text: randomSting,
            publicKey: RSAService.Key(exponent: exponent,
                                      modulus: modulus))
        currentSessions[login] = randomSting
        return .success(JSON(["key" : Array(encodedText.serialize()),
                              "token" : login]))
    }
    
}
