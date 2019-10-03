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

enum BackendErrorEnum: Error {
    case error(String)
}

typealias ProcessRequest = (JSON) -> Result<JSON, BackendErrorEnum>

class Backend {
    
    func getFiles() -> Result<JSON, BackendErrorEnum> {
        guard let files = FileService.getFiles() else {
            return .failure(.error("Проблема с получением списка файлов"))
        }
        return .success(JSON(files.map { $0.prefix(while: { c in c != "."})}))
    }
    
    func getFile(queryParams: [(String, String)]) -> Result<JSON, BackendErrorEnum> {
        guard let filename = queryParams.getValueForKey("name") else {
            return .failure(.error("На задано имя файла"))
        }
        guard
            let e = queryParams.getValueForKey("keyE"),
            let m = queryParams.getValueForKey("keyM")else {
            return .failure(.error("На задан ключ"))
        }
        guard FileService.containsFile(name: filename) else {
            return .failure(.error("\(filename) не найден"))
        }
        guard let text = try? FileService.read(from: filename) else {
            return .failure(.error("Не удалось прочитать файл"))
        }
        
        let encodedText: String! = AppState.shared.rsa.encode(
            text: text,
            publicKey: RSAService.Key(exponent: BigUInt(e.base64Data!),
                                      modulus: BigUInt(m.base64Data!)))
        return .success(JSON(["text" : encodedText]))
    }
    
}
