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
        FilesRepository.shared.getFiles { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let items):
                self.files.append(contentsOf: items)
            case .failure(let error):
                switch error {
                case .server(let message):
                    self.serverError = message
                case .parsing:
                    self.serverError = "Какая то ошибка"
                @unknown default:
                    break
                }
            }
        }
    }
}
