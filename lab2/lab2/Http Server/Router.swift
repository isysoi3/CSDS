//
//  Router.swift
//  lab2
//
//  Created by Ilya Sysoi on 10/2/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation
import Swifter
import SwiftyJSON

class Router {
    
    let backend = Backend()
    
    private(set) var hanldeForPath: [String : (HttpRequest) -> (HttpResponse)] = [:]
    
    init() {
        hanldeForPath = [ "/hello" : helloHandler,
                          "api/v1/files" : filesHandler]
    }
    
    private func buildResponseForResult(_ result: Result<JSON, BackendErrorEnum>) -> HttpResponse {
        switch result {
        case .success(let json):
            return .ok(.data(try! json.rawData()))
        case .failure(let error):
            switch error {
            case .error(let message):
                return .ok(.json(["error" : message]))
            default:
                return .ok(.text(""))
            }
        }
    }
    
}


// MARK: - handlers
fileprivate extension Router {
    
    func helloHandler(_ request: HttpRequest) -> HttpResponse {
        .ok(.htmlBody("You asked for \(request)"))
    }
    
    func filesHandler(_ request: HttpRequest) -> HttpResponse {
        guard request.method == "GET" else {
            return HttpResponse.notFound
        }
        let result = backend.getFiles()
        return buildResponseForResult(result)
    }
    
}
