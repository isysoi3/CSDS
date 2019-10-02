//
//  HttpServer.swift
//  lab2
//
//  Created by Ilya Sysoi on 10/2/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation
import Swifter

class Server {
    
    private let server: HttpServer
    let router: Router
    
    var backend: Backend {
        return router.backend
    }
    
    var state: HttpServerIO.HttpServerIOState {
        return server.state
    }
    
    private let localhost = "http://127.0.0.1"
    
    private let port: in_port_t = 8181
    
    var url: String {
        return "\(localhost):\(port)"
    }
    
    init() {
        router = Router()
        server = HttpServer()
        
        server["/hello"] = handleRequests
    }
    
    func start() {
        do {
            try server.start(port, forceIPv4: true, priority: .default)
            print("Server has started ( port = \(port) ). Try to connect now...")
        } catch {
            print("Server start error: \(error)")
        }
    }
    
    func stop() {
        server.stop()
    }
    
    private func handleRequests(request: HttpRequest) -> HttpResponse {
        return .ok(.htmlBody("You asked for \(request)"))
        /*
         guard let body = String(bytes: request.body, encoding: .windowsCP1251) else {
         return HttpResponse.internalServerError
         }
         guard let response = router.routeWithBody(body) else {
         print("HttpResponse.notFound")
         return HttpResponse.notFound
         }
         return HttpResponse.ok(.text(response))
         */
    }
       
}
