//
//  EllepticalKey.swift
//  lab3
//
//  Created by Ilya Sysoi on 11/8/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation

struct EllepticalKey {
    
    let g: EllipticPoint
    var pA: EllipticPoint
    var pB: EllipticPoint
    let q: Int
    
    init(group: EllipticCurve) {
        pA = EllipticPoint(x: 0, y: 0, module: 0, coefficients: (0, 0))
        pB = EllipticPoint(x: 0, y: 0, module: 0, coefficients: (0, 0))
        g = group.points
            .filter { $0.order.isPrime() }
            .max(by: { $0.order < $1.order})
            ?? EllipticPoint(x: 0, y: 0, module: 0, coefficients: (0, 0))
        q = g.order
    }
    
}
