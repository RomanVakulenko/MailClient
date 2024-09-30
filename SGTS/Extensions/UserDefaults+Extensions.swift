//
//  UserDefaults+Extensions.swift
// 07.02.2024.
//

import UIKit

extension UserDefaults {
    
    func set(image: UIImage, forKey key: String) {
        let fileManager = FileManager.default
        let fileName = "\(UUID().uuidString).png" // Уникальное имя файла
        if let directory = try? fileManager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        ) as URL {
            let filePath = directory.appendingPathComponent(fileName)
            if let pngData = image.pngData() {
                do {
                    try pngData.write(to: filePath)
                    set(fileName, forKey: key) // Сохраняем ссылку на файл в UserDefaults
                } catch {
                    print("Не удалось сохранить изображение: \(error)")
                }
            }
        }
    }
    
    func image(forKey key: String) -> UIImage? {
        if let fileName = string(forKey: key) {
            let fileManager = FileManager.default
            if let directory = try? fileManager.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            ) as URL {
                let filePath = directory.appendingPathComponent(fileName)
                if let imageData = try? Data(contentsOf: filePath) {
                    return UIImage(data: imageData)
                }
            }
        }
        return nil
    }
    
    func removeImage(forKey key: String) {
        if let fileName = string(forKey: key) {
            let fileManager = FileManager.default
            if let directory = try? fileManager.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            ) as URL {
                let filePath = directory.appendingPathComponent(fileName)
                do {
                    try fileManager.removeItem(at: filePath)
                    removeObject(forKey: key) // Удаляем ссылку из UserDefaults
                } catch {
                    print("Не удалось удалить изображение: \(error)")
                }
            }
        }
    }
}
