//
//  UITextField+Extensions.swift
// 24.01.2024.
//

import UIKit
import ObjectiveC

private var placeholderKey: Void?

extension UITextView {

    var placeholder: String? {
        get {
            objc_getAssociatedObject(self, &placeholderKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &placeholderKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            checkPlaceholder()
        }
    }

    func checkPlaceholder() {
        if let placeholderText = placeholder, text.isEmpty {
            text = placeholderText
            textColor = UIColor(red: 0.538, green: 0.538, blue: 0.538, alpha: 1)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(beginTextEditing), name: UITextView.textDidBeginEditingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(endTextEditing), name: UITextView.textDidEndEditingNotification, object: nil)
    }

    @objc private func beginTextEditing() {
        if text == placeholder {
            text = nil
            textColor = .black // Или любой другой цвет текста
        }
    }

    @objc private func endTextEditing() {
        if text.isEmpty {
            text = placeholder
            textColor = .lightGray
        }
    }

}
