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
    
    let rsa = RSAService()
    private(set) var keys: RSAService.Keys?
    
    var publicKey: (RSAService.KeyString)? {
        if let keys = keys {
            return rsa.keyToString(keys.public)
        }
        return .none
    }
    
    private init() {
        
    }
    
    func generateKeys() {
        keys = rsa.generateKeys(primeLength: 512)
    }
    
}
