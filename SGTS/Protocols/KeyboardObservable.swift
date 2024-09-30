//
//  KeyboardObservable.swift
// 20.12.2023.
//

import UIKit

protocol KeyboardObservable {
    func keyboardWillShow(_ notification: Notification)
    func keyboardWillHide(_ notification: Notification)
    func registerForKeyboardNotifications()
    func unregisterFromKeyboardNotifications()
    func getKeyboardHeight(from notification: Notification) -> CGFloat
}

extension KeyboardObservable where Self: UIViewController {
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            self.keyboardWillShow(notification)
        }

        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { notification in
            self.keyboardWillHide(notification)
        }
    }

    func unregisterFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func keyboardWillShow(_ notification: Notification) {
        // Реализация по умолчанию
    }

    func keyboardWillHide(_ notification: Notification) {
        // Реализация по умолчанию
    }

    func getKeyboardHeight(from notification: Notification) -> CGFloat {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return 0
        }
        return keyboardFrame.cgRectValue.height
    }
}
