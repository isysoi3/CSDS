//
//  test.swift
//  lab3
//
//  Created by Ilya Sysoi on 11/15/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation

func test() {
    var i = 0
    for _ in (0...20) {
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
        if clientB.checkSignature(signature: se, message: "sdsd", key: key) {
            i += 1
        }
    }
    print(i)
}
