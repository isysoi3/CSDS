//
//  FilesListViewModel.swift
//  lab2
//
//  Created by Ilya Sysoi on 10/2/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation
import Combine

class FilesListViewModel {
    
    @Published var files: [FileModel] = []
    @Published var serverError: String? = nil
    
    func getFiles() {
        files.append(FileModel(name: "123"))
        files.append(FileModel(name: "321"))
        files.append(FileModel(name: "21321"))
    }
}
