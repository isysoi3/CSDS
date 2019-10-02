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

class FilesRepository {
    
    static let shared = FilesRepository()
    
    private init () {
        
    }
    
    enum FileRepositoryErrorEnum: Error {
        case server(String)
        case parsing
    }
    
    func getFiles(completionBlock: @escaping (Swift.Result<[FileModel], FileRepositoryErrorEnum>) -> ()) {
        Alamofire.request("http://127.0.0.1:8181/api/v1/files", method: .get)
            .responseJSON { response in
                switch response.result {
                case .success(let json):
                    let json = JSON(json)
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
    
}
