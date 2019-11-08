//
//  main.swift
//  lab3
//
//  Created by Ilya Sysoi on 11/8/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation

print("Hello, World!")

let group = EllipticCurve(coefficients: Coefficients(1, 1), module: 53)

print(group.points)
