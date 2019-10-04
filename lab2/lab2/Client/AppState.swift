//
//  AppState.swift
//  lab2
//
//  Created by Ilya Sysoi on 10/3/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation
import BigInt

class AppState {
    
    static let shared = AppState()
    
    let rsa = RSAService()
    private(set) var keys: RSAService.Keys?
    var token: String? = .none
    var serverKey: String? = .none
    
    var publicKey: (RSAService.KeyString) {
        get {
            if keys == nil {
                keys = rsa.generateKeys(primeLength: 512)
                saveKeysToStorage()
            }
            return rsa.keyToString(keys!.public)
        }
    }
    
    private init() {
        if let prE = UserDefaults.standard.data(forKey: "RSAPrivatExponent"),
            let prM = UserDefaults.standard.data(forKey: "RSAPrivatModulus"),
            let pE = UserDefaults.standard.data(forKey: "RSAPublicExponent"),
            let pM = UserDefaults.standard.data(forKey: "RSAPublicModulus") {
            keys = (public: (BigUInt(pE), BigUInt(pM)),
                    private: (BigUInt(prE), BigUInt(prM)))
        }
                        
    }
    
    func generateKeys() {
        keys = rsa.generateKeys(primeLength: 512)
        saveKeysToStorage()
    }
    
    private func saveKeysToStorage() {
        UserDefaults.standard.set(keys!.private.exponent.serialize(),
                                  forKey: "RSAPrivatExponent")
        UserDefaults.standard.set(keys!.private.modulus.serialize(),
                                  forKey: "RSAPrivatModulus")
        UserDefaults.standard.set(keys!.public.exponent.serialize(),
                                  forKey: "RSAPublicExponent")
        UserDefaults.standard.set(keys!.public.modulus.serialize(),
                                  forKey: "RSAPublicModulus")
    }
    
}
