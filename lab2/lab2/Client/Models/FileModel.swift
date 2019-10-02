//
//  FileModel.swift
//  lab2
//
//  Created by Ilya Sysoi on 10/2/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation

struct FileModel {
    
    let name: String
    let text: String?
    
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
}
