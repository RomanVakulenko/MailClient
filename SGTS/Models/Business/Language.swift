//
//  Language.swift
// 12.10.2023.
//

import Foundation

enum Language: String {
    case ru = "ru"
//    case kz = "kz"
    
    var title: String {
        switch self {
        case .ru:
            return "Русский"
//        case .kz:
//            return "Қазақша"
        }
    }
    
    var longTitle: String {
        switch self {
        case .ru:
            return "Русский язык"
//        case .kz:
//            return "Қазақша тілі"
        }
    }
    
}
