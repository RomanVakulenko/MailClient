//
//  TextCellWithTitleAtBorderViewModel.swift
//  SGTS
//
//  Created by Roman Vakulenko on 09.04.2024.
//

import Foundation
import DifferenceKit

protocol TextCellWithTitleAtBorderViewModelOutput: AnyObject {
    func onChangeText(_ viewModel: TextCellWithTitleAtBorderViewModel, currentText: String)
}

enum TextCellType {
    case only4Digits
    case noLimits
}

struct TextCellWithTitleAtBorderViewModel {
    let id: AnyHashable
    let type: TextCellType
    let maxCharacters: Int?
    let password: String?
    let placeholder: NSAttributedString?
    let borderTitle: NSAttributedString?
    let borderColor: UIColor
    let borderTitleBackground: UIColor
    let isPasswordFieldActiveNeedsForConfirmPassword: Bool
    let switchStateNotificationName: Notification.Name?
    let isActiveKey: String?
    let keyboardType: UIKeyboardType?
    let insets: UIEdgeInsets
    let isOnlyDigits: Bool

    weak var output: TextCellWithTitleAtBorderViewModelOutput?

    init(id: AnyHashable,
         type: TextCellType,
         maxCharacters: Int? = nil,
         password: String? = nil,
         placeholder: NSAttributedString? = nil,
         borderTitle: NSAttributedString? = nil,
         borderColor: UIColor,
         borderTitleBackColor: UIColor,
         isPasswordFieldActiveNeedsForConfirmPassword: Bool,
         switchStateNotificationName: Notification.Name? = nil,
         isActiveKey: String? = nil,
         insets: UIEdgeInsets = .zero,
         keyboardType: UIKeyboardType = .default,
         isOnlyDigits: Bool = true,
         output: TextCellWithTitleAtBorderViewModelOutput? = nil) {
            self.id = id
            self.type = type
            self.maxCharacters = maxCharacters
            self.placeholder = placeholder
            self.password = password
            self.borderTitle = borderTitle
            self.borderColor = borderColor
            self.borderTitleBackground = borderTitleBackColor
            self.isPasswordFieldActiveNeedsForConfirmPassword = isPasswordFieldActiveNeedsForConfirmPassword
            self.switchStateNotificationName = switchStateNotificationName
            self.isActiveKey = isActiveKey
            self.insets = insets
            self.keyboardType = keyboardType
            self.isOnlyDigits = isOnlyDigits
            self.output = output
    }

    func onChangeText(currentText: String?) {
        output?.onChangeText(self, currentText: currentText ?? "")
    }
}

extension TextCellWithTitleAtBorderViewModel: Differentiable {
    var differenceIdentifier: AnyHashable {
        id
    }

    func isContentEqual(to source: TextCellWithTitleAtBorderViewModel) -> Bool {
        source.type == type &&  
        source.placeholder == placeholder &&
        source.password == password &&
        source.borderTitle == borderTitle &&
        source.borderTitleBackground == borderTitleBackground &&
        source.borderColor == borderColor &&
        source.isPasswordFieldActiveNeedsForConfirmPassword == isPasswordFieldActiveNeedsForConfirmPassword &&
        source.switchStateNotificationName == switchStateNotificationName &&
        source.isActiveKey == isActiveKey &&
        source.keyboardType == keyboardType &&
        source.isOnlyDigits == isOnlyDigits &&
        source.insets == insets
    }
}
