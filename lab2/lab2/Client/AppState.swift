//
//  AppState.swift
//  lab2
//
//  Created by Ilya Sysoi on 10/3/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation

class AppState {
    
    static let shared = AppState()
    
    private let rsa = RSAService()
    private(set) var keys: RSAService.Keys?
    
    private init() {
        
    }
    
    func generateKeys() {
        keys = rsa.generateKeys()
    }
    
}
