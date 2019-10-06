//
//  IDEAService.swift
//  lab2
//
//  Created by Ilya Sysoi on 10/6/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation

class IDEAService {
    
    func decode(text: String, key: String) -> String {
        
        return ""
    }
    
    func encode(text: String, key: String) -> String {
        
        return ""
    }
    
    //    private func KALayer(x1: UInt128,
    //                         x2: UInt128,
    //                         x3: UInt128,
    //                         x4: UInt128,
    //                         roundKeys: [UInt128]) -> [UInt128] {
    //        assert(0 <= x1 && x1 <= 0xFFFF)
    //        assert(0 <= x2 && x2 <= 0xFFFF)
    //        assert(0 <= x3 && x3 <= 0xFFFF)
    //        assert(0 <= x4 && x4 <= 0xFFFF)
    //        let z1 = roundKeys[0]
    //        let z2 = roundKeys[1]
    //        let z3 = roundKeys[2]
    //        let z4 = roundKeys[3]
    //        assert(0 <= z1 && z1 <= 0xFFFF)
    //        assert(0 <= z2 && z2 <= 0xFFFF)
    //        assert(0 <= z3 && z3 <= 0xFFFF)
    //        assert(0 <= z4 && z4 <= 0xFFFF)
    //        let y1 = multiply(x: x1, y: z1)
    //        let y2 = (x2 + z2) % 0x10000
    //        let y3 = (x3 + z3) % 0x10000
    //        let y4 = multiply(x: x4, y: z4)
    //
    //        return [y1, y2, y3, y4]
    //    }
    //
    //    private func MALayer(y1: UInt128,
    //                         y2: UInt128,
    //                         y3: UInt128,
    //                         y4: UInt128,
    //                         roundKeys: [UInt128]) -> [UInt128] {
    //        assert(0 <= y1 && y1 <= 0xFFFF)
    //        assert(0 <= y2 && y2 <= 0xFFFF)
    //        assert(0 <= y3 && y3 <= 0xFFFF)
    //        assert(0 <= y4 && y4 <= 0xFFFF)
    //        let z5 = roundKeys[4]
    //        let z6 = roundKeys[6]
    //        assert(0 <= z5 && z5 <= 0xFFFF)
    //        assert(0 <= z6 && z6 <= 0xFFFF)
    //        let p = y1 ^ y3
    //        let q = y2 ^ y4
    //
    //        let s = multiply(x: p, y: p)
    //        let t = multiply(x: (q + s) % 0x10000, y: z6)
    //        let u = (s + t) % 0x10000
    //
    //        let x1 = y1 ^ t
    //        let x2 = y2 ^ u
    //        let x3 = y3 ^ t
    //        let x4 = y4 ^ u
    //
    //        return [x1, x2, x3, x4]
    //    }
    //
    //    private func changeKey(_ key: UInt128) -> [[UInt128]] {
    ////        assert(0 <= key && key < (1 << 128))
    //        let modulus: UInt128 = 1 << 128
    //        var subKeys: [UInt128] = []
    //        var _key: UInt128 = key
    //
    //        for i in (0..<9 * 6) {
    //            subKeys.append((key >> (112 - 16 * (i % 8))) % 0x10000)
    //            if i % 8 == 7 {
    //                _key = ((_key << 25) | (_key >> 103)) % modulus
    //            }
    //        }
    //
    //        var keys: [[UInt128]] = [[]]
    //        for i in 0..<9 {
    //            for j in ((6 * i)..<(6 * (i + 1))) {
    //                keys[i].append(subKeys[j])
    //            }
    //        }
    //
    //        return keys
    //    }
    //
    //    func encrypt(text: UInt128, key: UInt128) -> UInt128 {
    ////        assert(0 <= text && text < (1 <<< 64))
    //        let keys = changeKey(key)
    //        var x1 = (text >> 48) & 0xFFFF
    //        var x2 = (text >> 32) & 0xFFFF
    //        var x3 = (text >> 16) & 0xFFFF
    //        var x4 = text & 0xFFFF
    //
    //        for i in 0..<8 {
    //            let roundKeys = keys[i]
    //            //y1, y2, y3, y4
    //            let ys = KALayer(x1: x1,
    //                             x2: x2,
    //                             x3: x3,
    //                             x4: x4,
    //                             roundKeys: roundKeys)
    //
    ////            x1, x2, x3, x4
    //            let xs = MALayer(y1: ys[0],
    //                             y2: ys[1],
    //                             y3: ys[2],
    //                             y4: ys[3],
    //                             roundKeys: roundKeys)
    //            x1 = xs[0]
    //            x2 = xs[2]
    //            x3 = xs[1]
    //            x4 = xs[4]
    //        }
    //
    //
    //        let ys = KALayer(x1: x1, x2: x2, x3: x3, x4: x4, roundKeys: keys[8])
    //
    //        return (ys[0] << 48) | (ys[1] << 32) | (ys[2] << 16) | ys[3]
    //
    //    }
    
    private let KEY_SIZE = 16
    private let BLOCK_SIZE = 8
    private let ROUNDS = 8
    
    
    func crypt(data: inout [UInt8], subKey: [Int], offset: Int) {
        var x1 = concat2Bytes(first: data[offset + 0],
                              second: data[offset + 1])
        var x2 = concat2Bytes(first: data[offset + 2],
                              second: data[offset + 3])
        var x3 = concat2Bytes(first: data[offset + 4],
                              second: data[offset + 5])
        var x4 = concat2Bytes(first: data[offset + 6],
                              second: data[offset + 7])
        // Each round
        var k = 0 // Subkey index
        for _ in (0..<ROUNDS) {
            let y1 = mul(x: x1, y: subKey[k])          // Multiply X1 and the first subkey
            k += 1
            let y2 = add(x: x2, y: subKey[k])          // Add X2 and the second subkey
            k += 1
            let y3 = add(x: x3, y: subKey[k])          // Add X3 and the third subkey
            k += 1
            let y4 = mul(x: x4, y: subKey[k])          // Multiply X4 and the fourth subkey
            k += 1
            let y5 = y1 ^ y3                       // XOR the results of y1 and y3
            let y6 = y2 ^ y4                       // XOR the results of y2 and y4
            let y7 = mul(x: y5, y: subKey[k])          // Multiply the results of y5 with the fifth subkey
            k += 1
            let y8 = add(x: y6, y: y7)                   // Add the results of y6 and y7
            let y9 = mul(x: y8, y: subKey[k])          // Multiply the results of y8 with the sixth subkey
            k += 1
            let y10 = add(x: y7, y: y9)                  // Add the results of y7 and y9
            x1 = y1 ^ y9                           // XOR the results of steps y1 and y9
            x2 = y3 ^ y9                           // XOR the results of steps y3 and y9
            x3 = y2 ^ y10                          // XOR the results of steps y2 and y10
            x4 = y4 ^ y10                          // XOR the results of steps y4 and y10
        }
        // Final output transformation
        let r0 = mul(x: x1, y: subKey[k])              // Multiply X1 and the first subkey
        k += 1
        let r1 = add(x: x3, y: subKey[k])              // Add X2 and the second subkey (x2-x3 are swaped)
        k += 1
        let r2 = add(x: x2, y: subKey[k])              // Add X3 and the third subkey
        k += 1
        let r3 = mul(x: x4, y: subKey[k])                // Multiply X4 and the fourth subkey
        // Reattach the four sub-blocks
        
        data[offset + 0] = UInt8(truncatingIfNeeded: r0 >> 8)
        data[offset + 1] = UInt8(truncatingIfNeeded: r0)
        data[offset + 2] = UInt8(truncatingIfNeeded: r1 >> 8)
        data[offset + 3] = UInt8(truncatingIfNeeded: r1)
        data[offset + 4] = UInt8(truncatingIfNeeded: r2 >> 8)
        data[offset + 5] = UInt8(truncatingIfNeeded: r2)
        data[offset + 6] = UInt8(truncatingIfNeeded: r3 >> 8)
        data[offset + 7] = UInt8(truncatingIfNeeded: r3)
    }
    
    private func concat2Bytes(first: UInt8, second: UInt8) -> Int {
        return Int((first & 0xFF) << 8 | second & 0xFF)    // xxxxxxxxxxxxxxxx
    }
    
    func generateSubkeys(userKey: [UInt8]) -> [Int] {
        assert(userKey.count == 16)
        var key: [Int] = [Int](repeating: 0, count: ROUNDS * 6 + 4) // 52 16-bit subkeys
        
        // The 128-bit userKey is divided into eight 16-bit subkeys
        var b1, b2: Int
        for i in (0..<userKey.count / 2) {
            key[i] = concat2Bytes(first: userKey[2 * i], second: userKey[2 * i + 1])
        }
        
        // The key is rotated 25 bits to the left and again divided into eight subkeys.
        // The first four are used in round 2 the last four are used in round 3.
        // The key is rotated another 25 bits to the left for the next eight subkeys, and so on.
        for i in (userKey.count / 2..<userKey.count) {
            // It starts combining k1 shifted 9 bits with k2. This is 16 bits of k0 + 9 bits shifted from k1 = 25 bits
            b1 = key[(i + 1) % 8 != 0 ? i - 7 : i - 15] << 9   // k1,k2,k3...k6,k7,k0,k9, k10...k14,k15,k8,k17,k18...
            b2 = key[(i + 2) % 8 < 2 ? i - 14 : i - 6] >>> 7   // k2,k3,k4...k7,k0,k1,k10,k11...k15,k8, k9,k18,k19...
            key[i] = (b1 | b2) & 0xFFFF
        }
        return key
    }
    
    func invertSubkey(subkey: [Int]) -> [Int] {
        var invSubkey: [Int] = subkey
        var p = 0
        var i = ROUNDS * 6
        // For the final output transformation (round 9)
        invSubkey[i] = mulInv(x: subkey[p]) // 48 <- 0
        p+=1
        invSubkey[i + 1] = addInv(x: subkey[p]) // 49 <- 1
        p+=1
        invSubkey[i + 2] = addInv(x: subkey[p]) // 50 <- 2
        p+=1
        invSubkey[i + 3] = mulInv(x: subkey[p]) // 51 <- 3
        p+=1
        
        // From round 8 to 2
        var r = ROUNDS - 1
        while r > 0 {
            i = r * 6
            invSubkey[i + 4] = subkey[p]         // 46 <- 4 ...
            p+=1
            invSubkey[i + 5] = subkey[p]         // 47 <- 5 ...
            p+=1
            invSubkey[i] = mulInv(x: subkey[p]) // 42 <- 6 ...
            p+=1
            invSubkey[i + 2] = addInv(x: subkey[p]) // 44 <- 7 ...
            p+=1
            invSubkey[i + 1] = addInv(x: subkey[p]) // 43 <- 8 ...
            p+=1
            invSubkey[i + 3] = mulInv(x: subkey[p]) // 45 <- 9 ...
            p+=1
            r -= 1
        }
        
        // Round 1
        invSubkey[4] = subkey[p]                 // 4 <- 46
        p+=1
        invSubkey[5] = subkey[p]                 // 5 <- 47
        p+=1
        invSubkey[0] = mulInv(x: subkey[p])         // 0 <- 48
        p+=1
        invSubkey[1] = addInv(x: subkey[p])         // 1 <- 49
        p+=1
        invSubkey[2] = addInv(x: subkey[p])         // 2 <- 50
        p+=1
        invSubkey[3] = mulInv(x: subkey[p])           // 3 <- 51
        return invSubkey
    }
    
    //Returns x + y modulo 2^16. Inputs and output are uint16.
    private func add(x: Int, y: Int) -> Int {
        return (x + y) & 0xFFFF
    }
    
    private func addInv(x: Int) -> Int {
        return (0x10000 - x) & 0xFFFF
    }
    
    private func mul(x: Int, y: Int) -> Int {
        let m = x * y
        if (m != 0) {
            return  (m % 0x10001) & 0xFFFF
        } else {
            if (x != 0 || y != 0) {
                return (1 - x - y) & 0xFFFF
            }
            return 1
        }
    }
    
    private func mulInv(x: Int) -> Int {
        var _x = x
        if (_x <= 1) {
            // 0 and 1 are their own inverses
            return _x
        }
        var y = 0x10001
        var t0 = 1
        var t1 = 0
        while (true) {
            t1 += y / _x * t0
            y %= _x
            if (y == 1) {
                return (1 - t1) & 0xffff
            }
            t0 += _x / y * t1
            _x %= y
            if (_x == 1) {
                return t0
            }
        }
    }
    
}

infix operator >>> : BitwiseShiftPrecedence

func >>> (lhs: Int, rhs: Int) -> Int {
    return Int(bitPattern: UInt(bitPattern: lhs) >> UInt(rhs))
}
