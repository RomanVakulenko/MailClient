//
//  TextFieldCellViewModel.swift
//  SGTS
//
//  Created by Roman Vakulenko on 24.04.2024.
//

import Foundation
import DifferenceKit

protocol TextFieldCellViewModelOutput: AnyObject {
    func onChangeText(_ viewModel: TextFieldCellViewModel, currentText: String)
}


struct TextFieldCellViewModel {
    let id: AnyHashable
    let text: NSAttributedString
    let backColor: UIColor
    let isUserInteractionEnabled: Bool?
    let insets: UIEdgeInsets

    weak var output: TextFieldCellViewModelOutput?
    init(id: AnyHashable, 
         text: NSAttributedString,
         backColor: UIColor,
         isUserInteractionEnabled: Bool? = false,
         insets: UIEdgeInsets,
         output: TextFieldCellViewModelOutput? = nil) {
        self.id = id
        self.text = text
        self.backColor = backColor
        self.isUserInteractionEnabled = isUserInteractionEnabled
        self.insets = insets
        self.output = output
    }

    func onChangeText(currentText: String?) {
        output?.onChangeText(self,
                             currentText: currentText ?? String())
    }

}


extension TextFieldCellViewModel: Differentiable {
    var differenceIdentifier: AnyHashable {
        id
    }

    func isContentEqual(to source: TextFieldCellViewModel) -> Bool {
        source.text == text &&
        source.backColor == backColor &&
        source.isUserInteractionEnabled == isUserInteractionEnabled &&
        source.insets == insets
    }
}

