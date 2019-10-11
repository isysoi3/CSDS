//
//  FilesRepository.swift
//  lab2
//
//  Created by Ilya Sysoi on 10/2/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import BigInt

class ServerRepository {
    
    static let shared = ServerRepository()
    
    private let service: IDEAService
    var ip = "192.168.100.222:8181"
    private var serverURL: String {
        "http://" + ip + ":8181" + "/api/v1"
    }
    
    private init () {
        service = IDEAService()
        
    }
    
    enum FileRepositoryErrorEnum: Error {
        case server(String)
        case parsing
    }
    
    func login(login: String,
               password: String,
               key: RSAService.KeyString,
               completionBlock: @escaping (Swift.Result<(String, String), FileRepositoryErrorEnum>) -> ()) {
        Alamofire.request("\(serverURL)/login", method: .post, parameters: ["login": login, "password": password, "keyExponent" : key.exponent, "keyModulus" : key.modulus])
            .responseJSON { [weak self] response in
                switch response.result {
                case .success(let json):
                    let json = JSON(json)
                    if let error = self?.parseErrors(json: json) {
                        completionBlock(.failure(.server(error)))
                        return
                    }
                    guard let token = json["token"].string else {
                        completionBlock(.failure(.parsing))
                        return
                    }
                    guard let dataKey = json["key"].array else {
                        completionBlock(.failure(.parsing))
                        return
                    }
                    let array = dataKey.compactMap({ n in n.uInt8 })
                    let key: String = AppState.shared.rsa.decode(decryptedData: BigUInt(Data(array)),
                    privateKey: AppState.shared.keys!.private)
                    completionBlock(.success((token, key)))
                case .failure:
                    completionBlock(.failure(.parsing))
                }
        }
    }
    
    func getFiles(completionBlock: @escaping (Swift.Result<[FileModel], FileRepositoryErrorEnum>) -> ()) {
        Alamofire.request("\(serverURL)/files", method: .get)
            .responseJSON { [weak self] response in
                switch response.result {
                case .success(let json):
                    let json = JSON(json)
                    if let error = self?.parseErrors(json: json) {
                        completionBlock(.failure(.server(error)))
                        return
                    }
                    guard  let array = json.array else {
                        completionBlock(.failure(.parsing))
                        return
                    }
                    let files: [FileModel] = array.compactMap {
                        if let name = $0.string {
                            return FileModel(name: name)
                        } else {
                            return .none
                        }
                    }
                    array.count == files.count ?
                        completionBlock(.success(files)) : completionBlock(.failure(.parsing))
                case .failure:
                    completionBlock(.failure(.parsing))
                }
        }
    }
    
    func getFile(name: String,
                 token: String,
                 completionBlock: @escaping (Swift.Result<FileModel, FileRepositoryErrorEnum>) -> ()) {
        Alamofire.request("\(serverURL)/file", method: .get, parameters: ["name" : name, "token" : token])
            .responseJSON { [weak self] response in
                guard let `self` = self else { return }
                switch response.result {
                case .success(let json):
                    let json = JSON(json)
                    if let error = self.parseErrors(json: json) {
                        completionBlock(.failure(.server(error)))
                        return
                    }
                    guard let textData = json["text"].array else {
                        completionBlock(.failure(.parsing))
                        return
                    }
                    let array = textData.compactMap({ n in n.uInt8 })
                    let text = self.service.decode(data: array, key: AppState.shared.serverKey!)
                                    
                    completionBlock(.success(FileModel(name: name, text: text)))
                case .failure:
                    completionBlock(.failure(.parsing))
                }
        }
    }
    
    private func parseErrors(json: JSON) -> String? {
        return json["error"].string
    }
    
}
