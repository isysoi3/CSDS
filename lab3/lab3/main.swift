//
//  main.swift
//  lab3
//
//  Created by Ilya Sysoi on 11/8/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation

let group = EllipticCurve(coefficients: (1, 0), module: 23)
print(group.points)
var key = EllepticalKey(group: group)
var clientA = Client(group: group)
key.pA = clientA.generateKey(for: key)

var clientB = Client(group: group)
key.pB = clientB.generateKey(for: key)

clientA.generateOpenKey(for: key.pB)
clientB.generateOpenKey(for: key.pA)

print(clientA.k == clientB.k)
print(clientA.k!)
print(clientB.k!)

let se = getSignature(message: "sdsd", key: key, client: clientB)
print(se)

checkSignature(signature: se, message: "sdsd", key: key)
