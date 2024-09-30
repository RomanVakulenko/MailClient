//
//  Dictionary.swift
// 18.06.2024.
//

import Foundation

extension Dictionary {
    func toJSONString() -> String? {
        // Проверка, может ли словарь быть сериализован в JSON
        guard JSONSerialization.isValidJSONObject(self) else {
            return nil
        }
        
        do {
            // Сериализация словаря в данные JSON
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .withoutEscapingSlashes)
            // Преобразование данных JSON в строку
            return String(data: jsonData, encoding: .utf8)
        } catch {
            // Обработка ошибки сериализации
            print("Ошибка сериализации JSON: \(error.localizedDescription)")
            return nil
        }
    }
}
