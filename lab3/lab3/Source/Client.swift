//
//  Client.swift
//  lab3
//
//  Created by Ilya Sysoi on 11/8/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation

struct Client {
    
    private(set) var n: Int = 0
    private(set) var k: EllipticPoint?
    var group: EllipticCurve

    init(group: EllipticCurve) {
        self.group = group
    }
    
    mutating func generateKey(for key: EllepticalKey) -> EllipticPoint {
        n = Int.random(in: (1...group.module))
        return key.g.multiply(by: n)
    }
    
    mutating func generateOpenKey(for p: EllipticPoint) {
        k = p.multiply(by: n)
    }
    
}


func getSignature(message m: String, key: EllepticalKey, client: Client) -> (r: Int, s: Int) {
    var r = 0
    var s = 0
    let h = m.hash
    while (r == 0 || s == 0) {
        let k = Int.random(in: (2..<key.q - 1))
        let kG = key.g.multiply(by: k)
        r = kG.x % key.q
        s = (k.modInverse(m: key.q)! * (h + r * client.n)) % key.q
    }
    return (r, s)
}


func checkSignature(signature: (r: Int, s: Int),
                    message m: String,
                    key: EllepticalKey) {
    let s = signature.1
    let r = signature.0
    let h = m.hash
    guard (1 <= r && r < key.q)
        && (1 <= s && s < key.q) else {
        print("not true")
        return
    }
    let w = s.modInverse(m: key.q)!
    let u1 = (h * w) % key.q
    let u2 = (r * w) % key.q
    let sum = key.g.multiply(by: u1) + key.pA.multiply(by: u2)
    let rr = sum.x % key.q
    print("(r, r*) = (\(r), \(rr))")
}
