//
//  lab2Tests.swift
//  lab2Tests
//
//  Created by Ilya Sysoi on 10/4/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import XCTest
@testable import lab2

class lab2Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSimpleText() {
        let service = RSAService()
        let messsgae = "Hello world"
        let keys = service.generateKeys()
        
        let data = service.encode(text: messsgae,
                                  publicKey: keys.public)
        let newMessage = service.decode(decryptedData: data,
                                        privateKey: keys.private)
        XCTAssert(messsgae == newMessage)
    }
    
    func testLargeText() {
        let service = RSAService()
        let messsgae = (0..<128).map { _ in "H"}.joined()
        let keys = service.generateKeys(primeLength: 512)
        
        let data = service.encode(text: messsgae,
                                  publicKey: keys.public)
        let newMessage = service.decode(decryptedData: data,
                                        privateKey: keys.private)
        XCTAssert(messsgae == newMessage)
       }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
