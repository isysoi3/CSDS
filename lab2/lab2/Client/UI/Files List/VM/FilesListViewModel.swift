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
    @Published var error: String? = nil
    @Published var selectedFile: FileModel? = nil
    @Published var isLoading: Bool = false
    
    @objc func getFiles() {
        isLoading = true
        FilesRepository.shared.getFiles { [weak self] result in
            guard let `self` = self else { return }
            self.isLoading = false
            switch result {
            case .success(let items):
                self.files = items
            case .failure(let error):
                switch error {
                case .server(let message):
                    self.error = message
                case .parsing:
                    self.error = "Какая то ошибка"
                @unknown default:
                    break
                }
            }
        }
    }
    
    func getFile(name: String) {
        isLoading = true
        FilesRepository.shared.getFile(name: name) { [weak self] result in
            guard let `self` = self else { return }
            self.isLoading = false
            switch result {
            case .success(let item):
                self.selectedFile = item
            case .failure(let error):
                switch error {
                case .server(let message):
                    self.error = message
                case .parsing:
                    self.error = "Какая то ошибка"
                @unknown default:
                    break
                }
            }
        }
    }
}
