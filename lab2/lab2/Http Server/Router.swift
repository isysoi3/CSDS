//
//  Router.swift
//  lab2
//
//  Created by Ilya Sysoi on 10/2/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation
import SwiftyJSON

class Router {
    
    let backend = Backend()
    
    private var backendMethodForType: [String : ProcessRequest] = [:]
    
    init() {
        
    }
    
    func routeWithBody(_ requestBody: String) -> String? {
        return .none
    }
    
    
    
}
