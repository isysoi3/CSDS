//
//  IDEAService.swift
//  lab2
//
//  Created by Ilya Sysoi on 10/6/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation

class IDEAService {
    
    private let KEY_SIZE = 16
    private let BLOCK_SIZE = 8
    private let ROUNDS = 8
    
    private let initlialVector = "abcdefgh"
    
    func encode(text: String, key: String) -> [UInt8] {
        var dataToEncode: [UInt8] = Array(initlialVector.data(using: .ascii)!)
        let textData: [UInt8] = Array(text.data(using: .ascii)!)
        let texts = textData.chunked(into: BLOCK_SIZE)
        let subKey = generateSubkeys(userKey: Array(key.data(using: .ascii)!))
        var result: [UInt8] = []
        for textPart in texts {
//            dataToEncode = crypt(data: dataToEncode, subKey: subKey)
//            result.append(contentsOf: zip(dataToEncode, textPart).map({ (a, b) in a | b}))
            result.append(contentsOf: crypt(data: textPart, subKey: subKey))
        }
        return result
    }
    
    func decode(data: [UInt8], key: String) -> String {
        var dataToDecode: [UInt8] = Array(initlialVector.data(using: .ascii)!)
        let invSubKey = invertSubkey(subkey: generateSubkeys(userKey: Array(Array(key.data(using: .ascii)!))))
        let texts = data.chunked(into: BLOCK_SIZE)
        var result: [UInt8] = []
        for textPart in texts {
//            dataToDecode = crypt(data: dataToDecode, subKey: invSubKey)
//            result.append(contentsOf: zip(dataToDecode, textPart).map({ (a, b) in a | b}))
            result.append(contentsOf: crypt(data: textPart, subKey: invSubKey))
        }
        return String(data: Data(result), encoding: .ascii) ?? ""
    }

    func crypt(data: [UInt8], subKey: [Int]) -> [UInt8] {
        var x1 = concat2Bytes(first: data[0],
                              second: data[1])
        var x2 = concat2Bytes(first: data[2],
                              second: data[3])
        var x3 = concat2Bytes(first: data[4],
                              second: data[5])
        var x4 = concat2Bytes(first: data[6],
                              second: data[7])
        var result = [UInt8](repeating: 0, count: data.count)
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
        
        result[0] = UInt8(truncatingIfNeeded: r0 >> 8)
        result[1] = UInt8(truncatingIfNeeded: r0)
        result[2] = UInt8(truncatingIfNeeded: r1 >> 8)
        result[3] = UInt8(truncatingIfNeeded: r1)
        result[4] = UInt8(truncatingIfNeeded: r2 >> 8)
        result[5] = UInt8(truncatingIfNeeded: r2)
        result[6] = UInt8(truncatingIfNeeded: r3 >> 8)
        result[7] = UInt8(truncatingIfNeeded: r3)
        
        return result
    }
    
    private func concat2Bytes(first: UInt8, second: UInt8) -> Int {
        return (Int(bitPattern: UInt(first)) & 0xFF) << 8
            | Int(bitPattern: UInt(second)) & 0xFF
    }
    
    private func generateSubkeys(userKey: [UInt8]) -> [Int] {
        assert(userKey.count == 16)
        var key: [Int] = [Int](repeating: 0, count: ROUNDS * 6 + 4) // 52 16-bit subkeys
        
        // The 128-bit userKey is divided into eight 16-bit subkeys
        var b1, b2: Int
        for i in (0..<userKey.count / 2) {
            key[i] = concat2Bytes(first: userKey[2 * i],
                                  second: userKey[2 * i + 1])
        }
        
        // The key is rotated 25 bits to the left and again divided into eight subkeys.
        // The first four are used in round 2 the last four are used in round 3.
        // The key is rotated another 25 bits to the left for the next eight subkeys, and so on.
        for i in (userKey.count / 2..<key.count) {
            // It starts combining k1 shifted 9 bits with k2. This is 16 bits of k0 + 9 bits shifted from k1 = 25 bits
            b1 = key[(i + 1) % 8 != 0 ? i - 7 : i - 15] << 9   // k1,k2,k3...k6,k7,k0,k9, k10...k14,k15,k8,k17,k18...
            b2 = key[(i + 2) % 8 < 2 ? i - 14 : i - 6] >>> 7   // k2,k3,k4...k7,k0,k1,k10,k11...k15,k8, k9,k18,k19...
            key[i] = (b1 | b2) & 0xFFFF
        }
        return key
    }
    
    private func invertSubkey(subkey: [Int]) -> [Int] {
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


extension Array where Array.Element == UInt8 {
    
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            var tmp = [Element](repeating: 0, count: size)
            for i in ($0..<Swift.min($0+size, count)) {
                tmp[i%size] = self[i]
            }
            return tmp
        }
    }
    
}
