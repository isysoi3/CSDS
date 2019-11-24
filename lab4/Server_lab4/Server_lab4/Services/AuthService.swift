//
//  AuthService.swift
//  Server_lab4
//
//  Created by Ilya Sysoi on 11/24/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation

class AuthService {
    
    let n = 10000
    private(set) var a: Int = 1
    
    func checkClient(hash: Int, clientNHash: Int) -> Bool {
        let isValid = nHash(a, text: String(hash)) == clientNHash
        if isValid {
            a += 1
        }
        return isValid
    }
    
    func nHash(_ n: Int, text: String) -> Int {
        guard n != 0 else {
            fatalError()
        }
        
        let hash = djb2Hash(text)
        guard n != 1 else {
            print(hash)
            return hash
        }
        return nHash(n - 1, text: String(hash))
    }
    
    private func djb2Hash(_ string: String) -> Int {
      let unicodeScalars = string.unicodeScalars.map { $0.value }
      return unicodeScalars.reduce(5381) {
        ($0 << 5) &+ $0 &+ Int($1)
      }
    }
    
}
