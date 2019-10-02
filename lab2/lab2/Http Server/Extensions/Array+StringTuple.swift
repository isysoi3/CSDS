//
//  Array+StringTuple.swift
//  lab2
//
//  Created by Ilya Sysoi on 10/2/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation

extension Array where Array.Element == (String, String) {
    
    func getValueForKey(_ key: String) -> String? {
        first(where: {$0.0 == key})?.1
    }
    
}
