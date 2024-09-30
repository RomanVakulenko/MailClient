//
//  OpenFileManager.swift
// 18.07.2024.
//

import UIKit
import QuickLook

protocol OpenFileManagerProtocol {
    func openData(_ data: Data, withFilename filename: String, currentViewController: UIViewController)
}

class OpenFileManager: NSObject, OpenFileManagerProtocol {
    static let shared: OpenFileManagerProtocol = OpenFileManager()
    private let fileService: FileServiceProtocol = DIManager.shared.container.resolve(FileServiceProtocol.self)!
    private override init() {}
    internal var filename: String = ""
    
    func openData(_ data: Data, withFilename filename: String, currentViewController: UIViewController) {
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        
        if fileService.save(data: data, url: fileURL) != nil {
            self.filename = filename
            // Проверка, что файл существует
            guard fileService.isExist(url: fileURL) else {
                print("File does not exist at path: \(fileURL.path)")
                return
            }
            
            // Открытие файла с использованием QLPreviewController
            let previewController = QLPreviewController()
            previewController.dataSource = self
            previewController.currentPreviewItemIndex = 0
            
            currentViewController.present(previewController, animated: true) {
                // Удаление временного файла после использования
                DispatchQueue.main.asyncAfter(deadline: .now() + 30) { [weak self] in
                    self?.deleteTemporaryFile(at: fileURL)
                }
            }
        } else {
            print("Failed to save data to temporary file")
        }
    }
    
    private func deleteTemporaryFile(at url: URL) {
        if fileService.delete(url: url) {
            print("Temporary file deleted successfully.")
        } else {
            print("Failed to delete temporary file.")
        }
    }
}

// Расширение для поддержки QLPreviewControllerDataSource
extension OpenFileManager: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        return fileURL as QLPreviewItem
    }
}
