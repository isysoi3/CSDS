//
//  EllipticCurve.swift
//  lab3
//
//  Created by Ilya Sysoi on 11/8/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation

struct EllipticCurve {
    
    let module: Int
    let coefficients: Coefficients
    
    var points: [EllipticPoint] {
        var result: [EllipticPoint] = []
        for x in (0..<module) {
            let ySquare = (x.pow(by: 3) + coefficients.a * x + coefficients.b) % module
            
            if let y = ySquare.squareRoot(by: module) {
                result.append(EllipticPoint(x: x,
                                            y: y,
                                            module: module,
                                            coefficients: coefficients))
                if y != 0 {
                    result.append(EllipticPoint(x: x,
                                                y: module - y,
                                                module: module,
                                                coefficients: coefficients))
                }
            }
        }
        return result
//
//        var yValues: [Int] = []
//        var xValues: [Int] = []
//        for i in (0..<module) {
//            yValues.append(i * i % module)
//            xValues.append((i.pow(by: 3) + coefficients.a * i + coefficients.b) % module)
//        }
//
//        return zip(xValues, yValues).map { EllipticPoint(x: $0.0,
//                                                         y: $0.1,
//                                                         module: module,
//                                                         coefficients: coefficients)}
    }
    
    init(coefficients: Coefficients, module: Int) {
        assert(EllipticCurve.isValidCoefficients(coefficients, module: module))
        
        self.coefficients = coefficients
        self.module = module
    }
    
    init(module: Int) {
        let coefficients = EllipticCurve.generateCoefficientsForModule(module)
        self.init(coefficients: coefficients, module: module)
    }
 
    private static func generateCoefficientsForModule(_ module: Int) -> Coefficients {
        var result: [Coefficients] = []
        for a in (1..<module) {
            for b in (1..<module) {
                let coef = Coefficients(a, b)
                if isValidCoefficients(coef, module: module) {
                    result.append(coef)
                }
            }
        }
        return result[result.count/2]
    }
    
    private static func isValidCoefficients(_ coefficients: Coefficients, module: Int) -> Bool {
        (4 * coefficients.a.pow(by: 3) + 27 * coefficients.b.pow(by: 2)) % module != 0
    }
    
//    private func Legendre(_ a: Int, _ p: Int) -> Int {
//        if a == 0 || a == 1 {
//            return a;
//        }
//        var result: Int
//        if a % 2 == 0 {
//            result = Legendre(a / 2, p)
//            if ((p * p - 1) & 8) != 0 {
//                result = -result
//            }
//        } else {
//            result = Legendre(p % a, a)
//            if ((a - 1) * (p - 1) & 4) != 0 {
//                result = -result
//            }
//        }
//        return result;
//    }
    
}
