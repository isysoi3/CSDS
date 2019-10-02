//
//  Backend.swift
//  lab2
//
//  Created by Ilya Sysoi on 10/2/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation
import SwiftyJSON

enum BackendErrorEnum: Error {
    case error(String)
}

typealias ProcessRequest = (JSON) -> Result<JSON, BackendErrorEnum>

class Backend {
    
    func getFiles() -> Result<JSON, BackendErrorEnum> {
        guard let files = FileService.getFiles() else {
            return .failure(.error("Проблема с получением списка файлов"))
        }
        return .success(JSON(files))
    }
    
}
