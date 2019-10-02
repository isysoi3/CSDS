//
//  ViewController.swift
//  lab2
//
//  Created by Ilya Sysoi on 10/2/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let keys = RSAService().generateKeys()
        print(RSAService().keyToString(keys.public))
        print(RSAService().keyToString(keys.private))
        let text = RSAService().encode(text: "hello word", publicKey: keys.public)
        let tmp1 = RSAService().decode(decryptedData: text, privateKey: keys.private)
//        let s = RSAService().encodeEachChar(text: "hello word", publicKey: keys.public)
//        let s1 = RSAService().decodeEachChar(decryptedData: s, privateKey: keys.private)
//
//        let a = 1
    }


}

