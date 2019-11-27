//
//  AppState.swift
//  lab2
//
//  Created by Ilya Sysoi on 10/3/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation
import BigInt
import KeychainSwift

class AppState {
    
    static let shared = AppState()
    private let keychain = KeychainSwift()
    
    let rsa = RSAService()
    var keys: RSAService.Keys?
    var token: String? = .none
    var login: String?
    var serverKey: String? = .none
    
    var publicKey: (RSAService.KeyString) {
        get {
            if keys == nil {
                keys = rsa.generateKeys(primeLength: 64)
                saveKeysToStorage()
            }
            return rsa.keyToString(keys!.public)
        }
    }
    
    private init() {
        if let prE = keychain.getData("RSAPrivatExponent"),
            let prM = keychain.getData("RSAPrivatModulus"),
            let pE = keychain.getData("RSAPublicExponent"),
            let pM = keychain.getData("RSAPublicModulus") {
            keys = (public: (BigUInt(pE), BigUInt(pM)),
                    private: (BigUInt(prE), BigUInt(prM)))
        }
    }
    
    private func saveKeysToStorage() {
        keychain.set(keys!.private.exponent.serialize(),
                     forKey: "RSAPrivatExponent")
        keychain.set(keys!.private.modulus.serialize(),
                     forKey: "RSAPrivatModulus")
        keychain.set(keys!.public.exponent.serialize(),
                     forKey: "RSAPublicExponent")
        keychain.set(keys!.public.modulus.serialize(),
                     forKey: "RSAPublicModulus")
    }
    
}
