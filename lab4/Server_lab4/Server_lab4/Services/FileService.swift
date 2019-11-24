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
    
    static func write(_ text: String, to filename: String, with key: String) throws {
        let filename = getDocumentsDirectory().appendingPathComponent(filename + ".data")
        let data = IDEAService().encode(text: text, key: key)
        let pointer = UnsafeBufferPointer(start: data, count: data.count)
        try Data(buffer: pointer).write(to: filename)
    }
    
    static func read(from filename: String, with key: String) throws -> String {
        let filename = getDocumentsDirectory().appendingPathComponent(filename + ".data")
        let data = try Data(contentsOf: filename)
        return IDEAService().decode(data: Array(data), key: key)
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
            return fileURLs.compactMap {
                ($0.isFileURL && $0.pathComponents.last!.contains("data"))
                ? $0.pathComponents.last!
                : .none
            }
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
        return .none
    }
    
    static func containsFile(name: String) -> Bool {
        let filename = name + ".data"
        guard
            let files = FileService.getFiles(),
            !files.isEmpty,
            let file = files.first(where: { filename == $0}) else {
                return false
        }
        return true
    }
    
}
