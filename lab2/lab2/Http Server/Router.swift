//
//  Router.swift
//  lab2
//
//  Created by Ilya Sysoi on 10/2/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation
import SwiftyJSON
import Swifter

class Router {
    
    let backend = Backend()
    
    private(set) var hanldeForPath: [String : (HttpRequest) -> (HttpResponse)] = [:]
    
    init() {
        hanldeForPath = [ "/hello" : helloHandler]
    }
    
    private func helloHandler(_ request: HttpRequest) -> HttpResponse {
        .ok(.htmlBody("You asked for \(request)"))
    }
    
}
