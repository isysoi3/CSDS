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
                          "/api/v1/files" : getFilesHandler,
                          "/api/v1/file" : getFileHandler,
                          "/api/v1/login" : loginHandler]
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
    
    func getFilesHandler(_ request: HttpRequest) -> HttpResponse {
        guard request.method == "GET" else {
            return HttpResponse.notFound
        }
        let result = backend.getFiles()
        return buildResponseForResult(result)
    }
    
    func getFileHandler(_ request: HttpRequest) -> HttpResponse {
        guard request.method == "GET" else {
            return HttpResponse.notFound
        }
        let result = backend.getFile(queryParams: request.queryParams)
        return buildResponseForResult(result)
    }
    
    
    func loginHandler(_ request: HttpRequest) -> HttpResponse {
        guard request.method == "POST" else {
            return HttpResponse.notFound
        }
        let params = String(data: Data(request.body), encoding: .utf8)?
            .split(separator: "&")
            .reduce(into: [String : String]()) {
                let tmp = $1.split(separator: "=")
                $0.updateValue(String(tmp[1]), forKey: String(tmp[0]))
        }
        
        let result = backend.checkUser(params: params!)
        return buildResponseForResult(result)
    }
}
