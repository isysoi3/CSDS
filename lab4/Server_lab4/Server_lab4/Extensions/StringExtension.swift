//
//  StringExtension.swift
//  Server_lab4
//
//  Created by Ilya Sysoi on 11/24/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation

extension String {
    
    static func generateRandomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
}
