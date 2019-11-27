//
//  ClientHelper.swift
//  Client_lab4
//
//  Created by Ilya Sysoi on 11/27/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation

struct ClientHelper {
    
    static func nHash(_ n: Int, text: String) -> String {
        guard n != 0 else {
            fatalError()
        }
        
        let hash = String(djb2Hash(text))
        guard n != 1 else {
            print(hash)
            return hash
        }
        return nHash(n - 1, text: hash)
    }
    
    private static func djb2Hash(_ string: String) -> Int {
        let unicodeScalars = string.unicodeScalars.map { $0.value }
        return unicodeScalars.reduce(5381) {
            ($0 << 5) &+ $0 &+ Int($1)
        }
    }
    
}
