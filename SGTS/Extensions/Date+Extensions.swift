//
//  Date+Extensions.swift
// 20.06.2024.
//

import Foundation

extension Date {
    func getCurrentTimeInUTC() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let utcTimeString = dateFormatter.string(from: self)
        return utcTimeString
    }
}
