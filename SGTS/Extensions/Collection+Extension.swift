//
//  Collection+Extension.swift
// 26.01.2024.
//


extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

