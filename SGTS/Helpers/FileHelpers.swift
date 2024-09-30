//
//  FileHelpers.swift
// 11.07.2024.
//

import Foundation

func saveFileToDownloads(data: Data, fileName: String) -> URL? {
    // Получаем путь к папке "Загрузки"
    guard let downloadsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Downloads") else {
        print("Не удалось получить путь к папке Загрузки")
        return nil
    }
    
    // Создаем папку "Загрузки", если она не существует
    if !FileManager.default.fileExists(atPath: downloadsDirectory.path) {
        do {
            try FileManager.default.createDirectory(at: downloadsDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Не удалось создать папку Загрузки: \(error.localizedDescription)")
            return nil
        }
    }
    
    // Создаем URL для файла в папке "Загрузки"
    let fileURL = downloadsDirectory.appendingPathComponent(fileName)
    
    // Пишем данные в файл
    do {
        try data.write(to: fileURL)
        print("Файл успешно сохранен: \(fileURL.path)")
        return fileURL
    } catch {
        print("Не удалось записать данные в файл: \(error.localizedDescription)")
        return nil
    }
}

func createAndWipeFileWithRandomName() -> String? {
    let fileManager = FileManager.default
    let data = Data()
    guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
        print("createAndWipeFileWithRandomName Не удалось получить путь к папке документов")
        return nil
    }
    
    for _ in 0..<5 {
        let fileName = UUID().uuidString + ".dat"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            // Запись данных в файл
            try data.write(to: fileURL, options: .atomic)
            // Удаление файла
            try fileManager.removeItem(at: fileURL)
            print("createAndWipeFileWithRandomName удалось записать и удалить файл \(fileURL.path)")
            return fileURL.path
        } catch {
            print("createAndWipeFileWithRandomName Не удалось записать или удалить файл \(fileName): \(error.localizedDescription)")
        }
    }
    print("createAndWipeFileWithRandomName ")
    return nil
}

func deleteOrWipeFile(at filePath: String) {
    let fileURL = URL(fileURLWithPath: filePath)
    let fileManager = FileManager.default
    do {
        try fileManager.removeItem(at: fileURL)
        print("Файл успешно удалён.")
    } catch {
        print("Не удалось удалить файл: \(error.localizedDescription)")
        do {
            let emptyData = Data()
            try emptyData.write(to: fileURL, options: .atomic)
            print("Содержимое файла затёрто.")
        } catch {
            print("Не удалось затереть содержимое файла: \(error.localizedDescription)")
        }
    }
}


func createFile(with data: Data) -> String? {
    // Получение пути к папке документов
    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        print("createFile(with Не удалось получить путь к папке документов")
        return nil
    }
    print("createFile(with удалось получить путь к папке документов")
    print("createFile(with начинаем попытки записи файла")
    // Максимальное количество попыток
    let maxAttempts = 20
    var attempt = 0
    
    while attempt < maxAttempts {
        // Создание случайного имени файла
        let fileName = UUID().uuidString
        let fileURL = documentsDirectory.appendingPathComponent("\(fileName).dat")
        
        do {
            // Запись данных в файл
            try data.write(to: fileURL)
            print("createFile(with Успешно записаны данные в файл \(fileURL.path)")
            return fileURL.path
        } catch {
            print("createFile(with Не удалось записать данные в файл: \(error.localizedDescription), попытка \(attempt + 1) из \(maxAttempts)")
        }
        
        attempt += 1
    }
    
    print("createFile(with Не удалось записать данные в файл после \(maxAttempts) попыток")
    return nil
}
