//
//  EllipticPoint.swift
//  lab3
//
//  Created by Ilya Sysoi on 11/8/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation

typealias Coefficients = (a: Int, b: Int)

struct EllipticPoint: CustomStringConvertible, Equatable {
    
    let x: Int
    let y: Int
    let module: Int
    let coefficients: Coefficients
    
    var description: String {
        String(format: "(%d, %d) -- module: %d -- order: %d", x, y, module, order)
    }
    
    var order: Int {
        var list = [self]
        while (true) {
            let current = list.last! + self
            if !list.contains(current) {
                list.append(current)
            }
            else {
                break
            }
        }
        return list.count
        
        let m = Int(pow(Double(module + 1 + 20) * pow(Double(module), 0.5), 0.5))
        var table = [EllipticPoint(x: x, y: y, module: module + 1, coefficients: coefficients)]
        for i in (1...m) {
            table.append(self.multiply(by: i))
        }
        let alpha = self.multiply(by: m).minus()
        for i in (1...m) {
            let elPoint = alpha.multiply(by: i)
            if let index = table.firstIndex(where: { $0 == elPoint}) {
                return m * i + index;
            }
        }
        return 0
    }
    
    func minus() -> EllipticPoint {
        EllipticPoint(x: x,
                      y: EllipticPoint.addOnValue(-y, module: module),
                      module: module,
                      coefficients: coefficients);
    }
    
    func multiply(by mult: Int) -> EllipticPoint {
        var result = self
        let point = self
        for _ in (1..<mult) {
            result = result + point
        }
        return result
    }
    
    private static func addOnValue(_ value: Int, module: Int) -> Int {
        var rez = value
        while rez < 0 {
            rez += module
        }
        return rez % module
    }
    
    private static func onModules(valueUp: Int, valueDown: Int, module: Int) -> Int {
        var up = valueUp
        var down = valueDown
        if down < 0 {
            up = -up
            down = -down
        }
        up = addOnValue(up, module: module)
        for i in (0..<module) {
            if down * i % module == up {
                return i
            }
        }
        return 0;
    }
    
    static func +(lhs: EllipticPoint, rhs: EllipticPoint) -> EllipticPoint {
        let lambda = (lhs == rhs ?
            onModules(valueUp: 3 * lhs.x.pow(by: 2) + lhs.coefficients.a,
                      valueDown: 2 * lhs.y,
                      module: lhs.module)
            : onModules(valueUp: rhs.y - lhs.y,
                        valueDown: rhs.x - lhs.x,
                        module: lhs.module)
        )
        let x = addOnValue(lambda.pow(by: 2) - lhs.x - rhs.x, module: lhs.module)
        let y = addOnValue(lambda * (lhs.x - x) - lhs.y, module: lhs.module)
        return EllipticPoint(x: x,
                             y: y,
                             module: lhs.module,
                             coefficients: lhs.coefficients)
    }
    
    static func ==(lhs: EllipticPoint, rhs: EllipticPoint) -> Bool {
        return lhs.x == rhs.x
            && lhs.y == rhs.y
            && lhs.y == rhs.y
    }
    
}
