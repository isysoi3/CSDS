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
    typealias Keys = (`public`: Key, `private`: Key)
    
    private let e = BigUInt(65537)
    
    private func generatePrime(_ width: Int) -> BigUInt {
        while true {
            var random = BigUInt.randomInteger(withExactWidth: width)
            random |= BigUInt(1)
            if random.isPrime() {
                return random
            }
        }
    }
    
    func generateKeys(primeLength: Int = 64) -> Keys {
        let p = generatePrime(primeLength)
        let q = generatePrime(primeLength)
        let n = p * q
        let fn = (p - 1) * (q - 1)
        let d = e.inverse(BigUInt(fn))!
        let publicKey: Key = (e, n)
        let privateKey: Key = (d, n)
        
        return (publicKey, privateKey)
    }
    
}


// MARK: - encode and decode
extension RSAService {
    
    func encode(text: String, publicKey key: Key) -> BigUInt {
        guard let data = text.data(using: .utf8) else {
            fatalError("Error: Couldn't convert to data. \(text)")
        }
        
        return BigUInt(data).endecrypt(RSAKey: key)
    }
    
    func encodeEachChar(text: String, publicKey key: Key) -> [BigUInt] {
        text.map { encode(text: String($0), publicKey: key) }
    }
    
    func decode(decryptedData: BigUInt, privateKey key: Key) -> String {
        let decryptedData = decryptedData.endecrypt(RSAKey: key)
        if let text = String(data: decryptedData.serialize(), encoding: .utf8) {
             return text
        }
        fatalError("Error: Couldn't convert to text. \(decryptedData.serialize())")
    }
    
    func decodeEachChar(decryptedData: [BigUInt], privateKey key: Key) -> String {
        decryptedData.map { decode(decryptedData: $0, privateKey: key) }.joined()
    }
    
}


// MARK: - extension BigUInt endecrypt
extension BigUInt {
    
    func endecrypt(RSAKey key: RSAService.Key) -> BigUInt {
        return self.power(key.exponent, modulus: key.modulus)
    }
    
}
