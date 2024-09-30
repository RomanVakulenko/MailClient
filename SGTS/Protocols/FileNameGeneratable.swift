//
//  FileNameGeneratable.swift
// 01.11.2023.
//

import Foundation

protocol FileNameGeneratable {
    func generateFileName(prefix: String, withExtension fileExtension: String) -> String
}

extension FileNameGeneratable {
    func generateFileName(prefix: String = "", withExtension fileExtension: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMddHHmmss"
        let dateString = dateFormatter.string(from: Date())
        return "\(prefix)\(dateString).\(fileExtension)"
    }
}

// Использование
//struct MyFileHandler: FileNameGeneratable {}
//
//let handler = MyFileHandler()
//let filename = handler.generateFileName(prefix: "log_", withExtension: "txt")
//print(filename) // Например, "log_231101174512.txt", если сейчас 1 ноября 2023 года, 17:45:12
