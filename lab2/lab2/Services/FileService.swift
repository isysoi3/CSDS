//
//  FileService.swift
//  lab2
//
//  Created by Ilya Sysoi on 10/2/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation

class FileService {
    
    private static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    static func wrire(_ text: String, to filename: String) throws {
        let filename = getDocumentsDirectory().appendingPathComponent(filename + ".txt")
        try text.write(to: filename, atomically: false, encoding: .utf8)
    }
    
    static func read(from filename: String) throws -> String  {
        let filename = getDocumentsDirectory().appendingPathComponent(filename + ".txt")
        return try String(contentsOf: filename, encoding: .utf8)
    }
    
    static func getFiles() -> [String]? {
        let fileManager = FileManager.default
        let documentsURL = getDocumentsDirectory()
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL,
                                                               includingPropertiesForKeys: nil)
            let files = fileURLs.compactMap { $0.isFileURL ? $0.pathComponents.last! : .none}
            return files.isEmpty ? .none : files
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
        return .none
    }
    
}
