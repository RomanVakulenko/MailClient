//
//  Alphabet.swift
//  SGTS
//
//  Created by Roman Vakulenko on 17.04.2024.
//

import UIKit

enum Alphabet: String, CaseIterable {
    case A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z
    case А, Б, В, Г, Д, Е, Ё, Ж, З, И, Й, К, Л, М, Н, О, П, Р, С, Т, У, Ф, Х, Ц, Ч, Ш, Щ, Ъ, Ы, Ь, Э, Ю, Я
    case Ә, Ғ, Қ, Ң, Ө, Ұ, Ү, Һ, І

    var color: UIColor {
        switch self {
        case .A: return UIColor(red: 0.894, green: 0.223, blue: 0.187, alpha: 1)
        case .B: return UIColor(red: 0.565, green: 0.894, blue: 0.212, alpha: 1)
        case .C: return UIColor(red: 0.221, green: 0.569, blue: 0.885, alpha: 1)
        case .D: return UIColor(red: 0.952, green: 0.412, blue: 0.321, alpha: 1)
        case .E: return UIColor(red: 0.134, green: 0.867, blue: 0.455, alpha: 1)
        case .F: return UIColor(red: 0.654, green: 0.762, blue: 0.112, alpha: 1)
        case .G: return UIColor(red: 0.981, green: 0.611, blue: 0.721, alpha: 1)
        case .H: return UIColor(red: 0.221, green: 0.224, blue: 0.225, alpha: 1)
        case .I: return UIColor(red: 0.912, green: 0.523, blue: 0.789, alpha: 1)
        case .J: return UIColor(red: 0.111, green: 0.891, blue: 0.684, alpha: 1)
        case .K: return UIColor(red: 0.992, green: 0.612, blue: 0.111, alpha: 1)
        case .L: return UIColor(red: 0.322, green: 0.451, blue: 0.821, alpha: 1)
        case .M: return UIColor(red: 0.789, green: 0.321, blue: 0.111, alpha: 1)
        case .N: return UIColor(red: 0.534, green: 0.211, blue: 0.721, alpha: 1)
        case .O: return UIColor(red: 0.821, green: 0.752, blue: 0.441, alpha: 1)
        case .P: return UIColor(red: 0.111, green: 0.231, blue: 0.441, alpha: 1)
        case .Q: return UIColor(red: 0.234, green: 0.421, blue: 0.791, alpha: 1)
        case .R: return UIColor(red: 0.671, green: 0.134, blue: 0.111, alpha: 1)
        case .S: return UIColor(red: 0.334, green: 0.671, blue: 0.211, alpha: 1)
        case .T: return UIColor(red: 0.911, green: 0.432, blue: 0.612, alpha: 1)
        case .U: return UIColor(red: 0.111, green: 0.891, blue: 0.234, alpha: 1)
        case .V: return UIColor(red: 0.321, green: 0.241, blue: 0.881, alpha: 1)
        case .W: return UIColor(red: 0.434, green: 0.111, blue: 0.881, alpha: 1)
        case .X: return UIColor(red: 0.821, green: 0.681, blue: 0.191, alpha: 1)
        case .Y: return UIColor(red: 0.891, green: 0.231, blue: 0.581, alpha: 1)
        case .Z: return UIColor(red: 0.434, green: 0.111, blue: 0.821, alpha: 1)
        case .А: return UIColor(red: 0.984, green: 0.655, blue: 0.447, alpha: 1)
        case .Б: return UIColor(red: 0.255, green: 0.444, blue: 0.895, alpha: 1)
        case .В: return UIColor(red: 0.965, green: 0.568, blue: 0.117, alpha: 1)
        case .Г: return UIColor(red: 0.641, green: 0.255, blue: 0.895, alpha: 1)
        case .Д: return UIColor(red: 0.784, green: 0.447, blue: 0.255, alpha: 1)
        case .Е: return UIColor(red: 0.255, green: 0.784, blue: 0.447, alpha: 1)
        case .Ё: return UIColor(red: 0.255, green: 0.447, blue: 0.784, alpha: 1)
        case .Ж: return UIColor(red: 0.447, green: 0.255, blue: 0.784, alpha: 1)
        case .З: return UIColor(red: 0.255, green: 0.784, blue: 0.255, alpha: 1)
        case .И: return UIColor(red: 0.784, green: 0.255, blue: 0.447, alpha: 1)
        case .Й: return UIColor(red: 0.455, green: 0.892, blue: 0.231, alpha: 1)
        case .К: return UIColor(red: 0.231, green: 0.892, blue: 0.455, alpha: 1)
        case .Л: return UIColor(red: 0.892, green: 0.231, blue: 0.455, alpha: 1)
        case .М: return UIColor(red: 0.312, green: 0.612, blue: 0.889, alpha: 1)
        case .Н: return UIColor(red: 0.612, green: 0.312, blue: 0.889, alpha: 1)
        case .О: return UIColor(red: 0.889, green: 0.612, blue: 0.312, alpha: 1)
        case .П: return UIColor(red: 0.312, green: 0.889, blue: 0.612, alpha: 1)
        case .Р: return UIColor(red: 0.612, green: 0.889, blue: 0.312, alpha: 1)
        case .С: return UIColor(red: 0.889, green: 0.312, blue: 0.612, alpha: 1)
        case .Т: return UIColor(red: 0.312, green: 0.612, blue: 0.312, alpha: 1)
        case .У: return UIColor(red: 0.612, green: 0.312, blue: 0.612, alpha: 1)
        case .Ф: return UIColor(red: 0.312, green: 0.312, blue: 0.889, alpha: 1)
        case .Х: return UIColor(red: 0.889, green: 0.312, blue: 0.312, alpha: 1)
        case .Ц: return UIColor(red: 0.312, green: 0.889, blue: 0.889, alpha: 1)
        case .Ч: return UIColor(red: 0.612, green: 0.612, blue: 0.312, alpha: 1)
        case .Ш: return UIColor(red: 0.889, green: 0.612, blue: 0.612, alpha: 1)
        case .Щ: return UIColor(red: 0.612, green: 0.312, blue: 0.889, alpha: 1)
        case .Ъ: return UIColor(red: 0.889, green: 0.889, blue: 0.312, alpha: 1)
        case .Ы: return UIColor(red: 0.612, green: 0.889, blue: 0.889, alpha: 1)
        case .Ь: return UIColor(red: 0.312, green: 0.889, blue: 0.612, alpha: 1)
        case .Э: return UIColor(red: 0.889, green: 0.312, blue: 0.889, alpha: 1)
        case .Ю: return UIColor(red: 0.312, green: 0.612, blue: 0.889, alpha: 1)
        case .Я: return UIColor(red: 0.889, green: 0.612, blue: 0.312, alpha: 1)
        case .Ә: return UIColor(red: 0.7, green: 0.8, blue: 0.1, alpha: 1)
        case .Ғ: return UIColor(red: 0.5, green: 0.1, blue: 0.8, alpha: 1)
        case .Қ: return UIColor(red: 0.1, green: 0.5, blue: 0.8, alpha: 1)
        case .Ң: return UIColor(red: 0.8, green: 0.5, blue: 0.1, alpha: 1)
        case .Ө: return UIColor(red: 0.1, green: 0.8, blue: 0.5, alpha: 1)
        case .Ұ: return UIColor(red: 0.5, green: 0.8, blue: 0.1, alpha: 1)
        case .Ү: return UIColor(red: 0.8, green: 0.1, blue: 0.5, alpha: 1)
        case .Һ: return UIColor(red: 0.1, green: 0.1, blue: 0.8, alpha: 1)
        case .І: return UIColor(red: 0.8, green: 0.8, blue: 0.1, alpha: 1)
        }
    }

    static func colorOfFirstLetter(in string: String) -> UIColor {
        guard let firstCharacter = string.uppercased().first, let alphabet = Alphabet(rawValue: String(firstCharacter)) else {
            return UIColor(red: 0.144, green: 0.569, blue: 0.887, alpha: 0.5)
        }
        return alphabet.color
    }
}


//использование let color = Alphabet.colorOfFirstLetter(in: "Цвет")
