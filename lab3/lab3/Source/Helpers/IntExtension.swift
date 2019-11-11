//
//  IntExtension.swift
//  lab3
//
//  Created by Ilya Sysoi on 11/8/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation

extension Int {
    
    func pow(by exp: Int) -> Int {
        if exp == 1 {
            return self
        }
        return self * self.pow(by: exp - 1)
    }
    
    func isPrime() -> Bool {
        if self == 2 || self == 3 { return true }
        let maxDivider = Int(sqrt(Double(self)))
        return self > 1 && !(2...maxDivider).contains { self % $0 == 0 }
    }
    
    func squareRoot(by p: Int) -> Int? {
        let tmp = self % p;
      
        // One by one check all numbers from 2 to p-1
        for x in (0..<p) {
            if (x * x) % p == tmp {
                return x
            }
        }
        return nil
    }
    
}

