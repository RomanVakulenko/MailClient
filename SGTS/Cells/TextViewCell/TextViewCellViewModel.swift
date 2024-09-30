//
//  TextViewCellViewModel.swift
//  SGTS
//
//  Created by Roman Vakulenko on 06.05.2024.
//

import Foundation
import DifferenceKit

protocol TextViewCellViewModelOutput: AnyObject {
    func onChangeTextInTextView(_ viewModel: TextViewCellViewModel, currentText: String)
}

struct TextViewCellViewModel {
    let id: AnyHashable
    let placeholder: NSAttributedString?
    let isCreatingNewEmail: Bool
    let isMakingSignature: Bool
    let attributedText: NSAttributedString
    let backColor: UIColor
    let isUserInteractionEnabled: Bool?
    let isScrollEnabled: Bool?
    let isEditable: Bool?
    let showsVerticalScrollIndicator: Bool?
    let borderWidth: CGFloat?
    let borderColor: UIColor?

    let insets: UIEdgeInsets

    weak var output: TextViewCellViewModelOutput?

    init(id: AnyHashable, placeholder: NSAttributedString?, isCreatingNewEmail: Bool, isMakingSignature: Bool, attributedText: NSAttributedString, backColor: UIColor, isUserInteractionEnabled: Bool? = true, isScrollEnabled: Bool? = true, isEditable: Bool? = true, showsVerticalScrollIndicator: Bool? = nil, borderWidth: CGFloat? = nil, borderColor: UIColor? = nil, insets: UIEdgeInsets, output: TextViewCellViewModelOutput? = nil) {
        self.id = id
        self.placeholder = placeholder
        self.isCreatingNewEmail = isCreatingNewEmail
        self.isMakingSignature = isMakingSignature
        self.attributedText = attributedText
        self.backColor = backColor
        self.isUserInteractionEnabled = isUserInteractionEnabled
        self.isScrollEnabled = isScrollEnabled
        self.isEditable = isEditable
        self.showsVerticalScrollIndicator = showsVerticalScrollIndicator
        self.insets = insets
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.output = output
    }

    func onChangeText(currentText: String?) {
        output?.onChangeTextInTextView(self, currentText: currentText ?? String())
    }
}


extension TextViewCellViewModel: Differentiable {
    var differenceIdentifier: AnyHashable {
        id
    }

    func isContentEqual(to source: TextViewCellViewModel) -> Bool {
        source.attributedText == attributedText &&
        source.placeholder == placeholder &&
        source.isCreatingNewEmail == isCreatingNewEmail &&
        source.isMakingSignature == isMakingSignature &&
        source.backColor == backColor &&
        source.isUserInteractionEnabled == isUserInteractionEnabled &&
        source.isScrollEnabled == isScrollEnabled &&
        source.isEditable == isEditable &&
        source.showsVerticalScrollIndicator == showsVerticalScrollIndicator &&
        source.insets == insets &&
        source.borderWidth == borderWidth &&
        source.borderColor == borderColor
    }
}

