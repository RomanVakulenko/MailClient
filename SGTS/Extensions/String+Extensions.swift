//
//  String+Extensions.swift
// 20.01.2024.
//

import UIKit

extension String {
    func contains(substring: String) -> Bool {
        return self.range(of: substring) != nil
    }

    func convertToArray() -> [String] {
        let separatorsSet = CharacterSet(charactersIn: " ,;")
        let emailAddresses = self.components(separatedBy: separatorsSet)
        var emailsArray = [String]()

        for email in emailAddresses {
            let trimmedEmail = email.trimmingCharacters(in: CharacterSet(charactersIn: " .,;"))
            if !trimmedEmail.isEmpty {
                emailsArray.append(trimmedEmail)
            }
        }
        return emailsArray
    }

    var isEmailValid: Bool {
        let emailRegex = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        do {
            let regex = try NSRegularExpression(pattern: emailRegex, options: .caseInsensitive)
            let range = NSRange(location: 0, length: self.utf16.count)
            return regex.firstMatch(in: self, options: [], range: range) != nil
        } catch {
            return false
        }
    }


    func convertISODateString(to format: String? = "dd.MM.yyyy") -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        guard let date = inputFormatter.date(from: self) else {
            return self
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = format

        return outputFormatter.string(from: date)
    }
    
    func convertISODateStringToHHMMSS(to format: String? = "HH:mm:ss") -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        guard let date = inputFormatter.date(from: self) else {
            return self
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = format

        return outputFormatter.string(from: date)
    }

    var isIINValid: Bool {
        guard self.count == 12, self.allSatisfy({ $0.isNumber }),
              ["0", "1", "2", "3"].contains(self[self.index(self.startIndex, offsetBy: 4)]) else {
            return false
        }
        return isValidID()
    }
    
    var isBINValid: Bool {
        guard self.count == 12, self.allSatisfy({ $0.isNumber }),
              !["0", "1", "2", "3"].contains(self[self.index(self.startIndex, offsetBy: 4)]) else {
            return false
        }
        return isValidID()
    }
    
    private func isValidID() -> Bool {
        let b1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
        let b2 = [3, 4, 5, 6, 7, 8, 9, 10, 11, 1, 2]
        var control = 0
        
        for i in 0..<11 {
            guard let digit = Int(String(self[self.index(self.startIndex, offsetBy: i)])) else {
                return false
            }
            control += digit * b1[i]
        }
        control %= 11
        if control == 10 {
            control = 0
            for i in 0..<11 {
                guard let digit = Int(String(self[self.index(self.startIndex, offsetBy: i)])) else {
                    return false
                }
                control += digit * b2[i]
            }
            control %= 11
        }
        
        guard let lastDigit = Int(String(self.last!)) else {
            return false
        }
        return control == lastDigit
    }
    
    func toDigitArray() -> [Int]? {
        // Преобразование строки в массив символов
        let characters = Array(self)
        
        // Преобразование символов в цифры
        let digitArray = characters.compactMap { character -> Int? in
            if let digit = Int(String(character)) {
                return digit
            }
            return nil
        }
        
        return digitArray
    }
    
    func encodeToBase64() -> String? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        return data.base64EncodedString()
    }
    
    func stripPEMCertificate() -> String {
        let strippedString = self
            .replacingOccurrences(of: "-----BEGIN CERTIFICATE-----\n", with: "")
            .replacingOccurrences(of: "\n-----END CERTIFICATE-----\n", with: "")
        
        return strippedString
    }
    
    func extractDigits() -> String {
        let pattern = "\\d+$"
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let nsString = self as NSString
            let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
            if let match = results.first {
                return nsString.substring(with: match.range)
            }
        } catch let error {
            print("Invalid regex: \(error.localizedDescription)")
        }
        return ""
    }
}
