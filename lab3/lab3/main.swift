//
//  main.swift
//  lab3
//
//  Created by Ilya Sysoi on 11/8/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation

let group = EllipticCurve(module: 53)

var key = EllepticalKey(group: group)
var clientA = Client(group: group)
key.pA = clientA.generateOpenKey(with: key.g)

var clientB = Client(group: group)
key.pB = clientB.generateOpenKey(with: key.g)

clientA.generateKey(with: key.pB)
clientB.generateKey(with: key.pA)

print("A == B :", clientA.k == clientB.k)
print("A : \(clientA.k!)")
print("B : \(clientB.k!)")
print()

let se = clientA.getSignature(message: "sdsd", key: key)
print(se)
print()

print("Valid", clientB.checkSignature(signature: se, message: "sdsd", key: key))
print()

print("Invalid", clientB.checkSignature(signature: (1,4), message: "sdsd", key: key))
print()
