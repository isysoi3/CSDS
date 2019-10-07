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
    
    private let semaphore = DispatchSemaphore(value: 0)
    
    private let server: HttpServer
    private let router: Router
    
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
        
        router.hanldeForPath.forEach { (path, handler) in
            server[path] = handler
        }
    }
    
    func start() {
        do {
            try server.start(port, forceIPv4: true, priority: .default)
            print("Server has started ( port = \(port) ). Try to connect now...")
            semaphore.wait()
        } catch {
            print("Server start error: \(error)")
            semaphore.signal()
        }
    }
    
    func stop() {
        server.stop()
    }
       
}
