//
//  RSAService.swift
//  lab2
//
//  Created by Ilya Sysoi on 10/2/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation
import BigInt

class RSAService {
    
    typealias Key = (exponent: BigUInt, modulus: BigUInt)
    typealias KeyString = (exponent: String, modulus: String)
    typealias Keys = (`public`: Key, `private`: Key)
    
    private func generatePrime(_ width: Int) -> BigUInt {
        while true {
            var random = BigUInt.randomInteger(withExactWidth: width)
            random |= BigUInt(1)
            if random.isPrime() {
                return random
            }
        }
    }
    
    private func generateE(_ width: Int, fn: BigUInt) -> BigUInt {
        while true {
            var random = BigUInt.randomInteger(withExactWidth: width)
            if random.isPrime() && random.greatestCommonDivisor(with: fn) == BigUInt(1) {
                return random
            }
        }
    }
    
    func generateKeys(primeLength: Int = 64) -> Keys {
        let p = generatePrime(primeLength)
        let q = generatePrime(primeLength)
        let n = p * q
        let fn = (p - 1) * (q - 1)
        let e = generateE(primeLength+2, fn: fn)
        let d = e.inverse(BigUInt(fn))!
        let publicKey: Key = (e, n)
        let privateKey: Key = (d, n)
        
        return (publicKey, privateKey)
    }
    
    func keyToString(_ key: Key) -> KeyString {
        (key.exponent.serialize().base64EncodedString(),
         key.modulus.serialize().base64EncodedString())
    }
}


// MARK: - encoding
extension RSAService {
    
//    func encode(text: String, publicKey key: Key) -> String {
//        String(data: encode(text: text, publicKey: key).serialize(), encoding: .utf8)!
//    }
    
    func encode(text: String, publicKey key: Key) -> BigUInt {
        guard let data = text.data(using: .utf8) else {
            fatalError("Error: Couldn't convert to data. \(text)")
        }
        
        return BigUInt(data).endecrypt(RSAKey: key)
    }
    
}


// MARK: - decoding
extension RSAService {

//    func decode(text: String, privateKey key: Key) -> String {
//        decode(decryptedData: BigUInt(text.data(using: .utf8)!), privateKey: key)
//    }
//
    
    func decode(decryptedData: BigUInt, privateKey key: Key) -> String {
        let tmp = decryptedData.endecrypt(RSAKey: key)
        if let text = String(data: tmp.serialize(), encoding: .utf8) {
            return text
        }
        fatalError("Error: Couldn't convert to text. \(decryptedData.serialize())")
    }
    
}

// MARK: - extension BigUInt endecrypt
extension BigUInt {
    
    func endecrypt(RSAKey key: RSAService.Key) -> BigUInt {
        return self.power(key.exponent, modulus: key.modulus)
    }
    
}

extension String {
    
    var base64Data: Data? {
        return Data(base64Encoded: self)
    }
    
}
