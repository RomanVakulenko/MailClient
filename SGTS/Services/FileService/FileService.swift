//
//  FileService.swift
// 21.07.2024.
//

import Foundation

protocol FileServiceProtocol {
    func saveIntoContainer(data: Data) -> String?
    func findFilePathAtContainer(fileName: String) -> String?
    func isFileExistAtContainer(fileName: String) -> Bool
    func getAtContainer(fileName: String) -> Data?
    func deleteAtContainer(fileName: String) -> Bool
    
    func save(data: Data, directory: FileManager.SearchPathDirectory) -> String?
    func find(fileName: String, directory: FileManager.SearchPathDirectory) -> String?
    func isExist(fileName: String, directory: FileManager.SearchPathDirectory) -> Bool
    func read(fileName: String, directory: FileManager.SearchPathDirectory) -> Data?
    func delete(fileName: String, directory: FileManager.SearchPathDirectory) -> Bool
    
    func save(data: Data, url: URL) -> String?
    func isExist(url: URL) -> Bool
    func read(url: URL) -> Data?
    func delete(url: URL) -> Bool
}

class FileService: FileServiceProtocol {
    private let fileManager = FileManager.default
    private let storage = DIManager.shared.container.resolve(StorageProtocol.self)!
    
    // Сохранение данных в группу приложений
    func saveIntoContainer(data: Data) -> String? {
        guard let containerURL = getAppGroupContainerURL() else {
            Log.e("Failed to get app group container URL")
            return nil
        }
        let fileName = generateUniqueFileName(directoryURL: containerURL)
        let fileURL = containerURL.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            Log.i("File saved successfully to container: \(fileName)")
            return fileName
        } catch {
            Log.e("Error saving file: \(error)")
            return nil
        }
    }
    
    // Проверка существования файла в контейнере
    func findFilePathAtContainer(fileName: String) -> String? {
        return getFilePathIfExists(fileName: fileName)
    }
    
    // Проверка существования файла в контейнере
    func isFileExistAtContainer(fileName: String) -> Bool {
        return getFilePathIfExists(fileName: fileName) != nil
    }
    
    // Загрузка данных из группы приложений
    func getAtContainer(fileName: String) -> Data? {
        guard let containerURL = getAppGroupContainerURL() else {
            Log.e("Failed to get app group container URL")
            return nil
        }
        let fileURL = containerURL.appendingPathComponent(fileName)
        
        return try? Data(contentsOf: fileURL)
    }
    
    // Удаление файла из группы приложений
    func deleteAtContainer(fileName: String) -> Bool {
        guard let containerURL = getAppGroupContainerURL() else {
            Log.e("Failed to get app group container URL")
            return false
        }
        let fileURL = containerURL.appendingPathComponent(fileName)
        
        do {
            try fileManager.removeItem(at: fileURL)
            Log.i("File deleted successfully from container: \(fileName)")
            return true
        } catch {
            Log.e("Error deleting file: \(error)")
            return false
        }
    }
    
    // Сохранение данных в указанную директорию
    func save(data: Data, directory: FileManager.SearchPathDirectory) -> String? {
        guard let directoryURL = fileManager.urls(for: directory, in: .userDomainMask).first else {
            Log.e("Failed to get directory URL")
            return nil
        }
        let fileName = generateUniqueFileName(directoryURL: directoryURL)
        let fileURL = directoryURL.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            Log.i("File saved successfully to directory: \(fileName)")
            return fileName
        } catch {
            Log.e("Error saving file: \(error)")
            return nil
        }
    }
    
    // Поиск пути к файлу в указанной директории
    func find(fileName: String, directory: FileManager.SearchPathDirectory) -> String? {
        guard let directoryURL = fileManager.urls(for: directory, in: .userDomainMask).first else {
            Log.e("Failed to get directory URL")
            return nil
        }
        let fileURL = directoryURL.appendingPathComponent(fileName)
        
        guard fileManager.fileExists(atPath: fileURL.path),
              let data = try? Data(contentsOf: fileURL),
              !data.isEmpty else {
            return nil
        }
        
        return fileURL.path
    }
    
    // Проверка существования файла в указанной директории
    func isExist(fileName: String, directory: FileManager.SearchPathDirectory) -> Bool {
        return find(fileName: fileName, directory: directory) != nil
    }
    
    // Чтение данных из файла в указанной директории
    func read(fileName: String, directory: FileManager.SearchPathDirectory) -> Data? {
        guard let directoryURL = fileManager.urls(for: directory, in: .userDomainMask).first else {
            Log.e("Failed to get directory URL")
            return nil
        }
        let fileURL = directoryURL.appendingPathComponent(fileName)
        
        return try? Data(contentsOf: fileURL)
    }
    
    // Удаление файла в указанной директории
    func delete(fileName: String, directory: FileManager.SearchPathDirectory) -> Bool {
        guard let directoryURL = fileManager.urls(for: directory, in: .userDomainMask).first else {
            Log.e("Failed to get directory URL")
            return false
        }
        let fileURL = directoryURL.appendingPathComponent(fileName)
        
        do {
            try fileManager.removeItem(at: fileURL)
            Log.i("File deleted successfully from directory: \(fileName)")
            return true
        } catch {
            Log.e("Error deleting file: \(error)")
            return false
        }
    }
    
    // Сохранение данных по указанному URL
    func save(data: Data, url: URL) -> String? {
        do {
            try data.write(to: url)
            Log.i("File saved successfully to URL: \(url.lastPathComponent)")
            return url.lastPathComponent
        } catch {
            Log.e("Error saving file: \(error)")
            return nil
        }
    }
    
    // Проверка существования файла по указанному URL
    func isExist(url: URL) -> Bool {
        guard fileManager.fileExists(atPath: url.path),
              let data = try? Data(contentsOf: url),
              !data.isEmpty else {
            Log.e("File does not exist or is empty at URL: \(url.path)")
            return false
        }
        
        return true
    }
    
    // Чтение данных из файла по указанному URL
    func read(url: URL) -> Data? {
        return try? Data(contentsOf: url)
    }
    
    // Удаление файла по указанному URL
    func delete(url: URL) -> Bool {
        do {
            try fileManager.removeItem(at: url)
            Log.i("File deleted successfully from URL: \(url.path)")
            return true
        } catch {
            Log.e("Error deleting file: \(error)")
            return false
        }
    }
    
    // Генерация уникального имени файла
    private func generateUniqueFileName(directoryURL: URL) -> String {
        for _ in 0..<1000 {
            let uuid = UUID().uuidString
            let fileName = "\(uuid).dat"
            let fileURL = directoryURL.appendingPathComponent(fileName)
            if !fileManager.fileExists(atPath: fileURL.path) {
                return fileName
            }
        }
        Log.e("Unable to generate unique file name")
        fatalError("Unable to generate unique file name")
    }
    
    // Проверка существования файла в контейнере и возврат пути к файлу
    private func getFilePathIfExists(fileName: String) -> String? {
        guard let containerURL = getAppGroupContainerURL() else {
            Log.e("Failed to get app group container URL")
            return nil
        }
        let fileURL = containerURL.appendingPathComponent(fileName)
        
        guard fileManager.fileExists(atPath: fileURL.path),
              let data = try? Data(contentsOf: fileURL),
              !data.isEmpty else {
            Log.e("File does not exist or is empty at path: \(fileURL.path)")
            return nil
        }
        
        return fileURL.path
    }
    
    // Получение URL для общего контейнера группы приложений
    private func getAppGroupContainerURL() -> URL? {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
    }
}
