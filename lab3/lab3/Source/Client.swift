//
//  Client.swift
//  lab3
//
//  Created by Ilya Sysoi on 11/8/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation
import BigInt

struct Client {
    
    private(set) var n: Int = 0
    private(set) var k: EllipticPoint?
    var group: EllipticCurve

    init(group: EllipticCurve) {
        self.group = group
    }
    
    mutating func generateOpenKey(with g: EllipticPoint) -> EllipticPoint {
        n = Int.random(in: (1..<g.order))
        return key.g.multiply(by: n)
    }
    
    mutating func generateKey(with p: EllipticPoint) {
        k = p.multiply(by: n)
    }
    
    func getSignature(message m: String, key: EllepticalKey) -> (r: Int, s: Int) {
        var r = 0
        var s = 0
        let h = m.hash
        while (r == 0 || s == 0) {
            let k = Int.random(in: (1..<key.q))
            let kG = key.g.multiply(by: k)
            r = kG.x % key.q
            s = Int(
                (
                    BigInt(k).inverse(BigInt(key.q))!
                    * (BigInt(h) + BigInt(r * n))
                ).modulus(BigInt(key.q))
            )
        }
        return (r, s)
    }
    
    func checkSignature(signature: (r: Int, s: Int),
                        message m: String,
                        key: EllepticalKey) -> Bool {
        let s = signature.1
        let r = signature.0
        let h = m.hash
        guard (1 <= r && r < key.q)
            && (1 <= s && s < key.q) else {
            return false
        }
        let w = BigInt(s).inverse(BigInt(key.q))!
        let u1 = Int((BigInt(h) * w) % BigInt(key.q))
        let u2 = Int((BigInt(r) * w) % BigInt(key.q))
        let sum = key.g.multiply(by: u1) + key.pA.multiply(by: u2)
        let rr = sum.x % key.q
        print("(r, r*) = (\(r), \(rr))")
        
        return rr == r
    }
    
}

