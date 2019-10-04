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
        try? FileService.wrire((0..<128).map { _ in "H"}.joined(), to: "key")
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
       
}
