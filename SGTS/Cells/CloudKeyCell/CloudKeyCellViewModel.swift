//
//  CloudKeyCellViewModel.swift
//  SGTS
//
//  Created by Roman Vakulenko on 09.04.2024.
//

import Foundation
import DifferenceKit


protocol CloudKeyViewModelOutput: AnyObject {
    func didTapAt(_ viewModel: CloudKeyCellViewModel)
}


struct CloudKeyCellViewModel {
    let id: AnyHashable
    let backColor: UIColor
    let borderColor: UIColor
    let title: NSAttributedString
    let xButton: UIImage
    let insets: UIEdgeInsets

    weak var output: CloudKeyViewModelOutput?

    init(id: AnyHashable,
         backColor: UIColor,
         borderColor: UIColor,
         title: NSAttributedString,
         xButton: UIImage,
         insets: UIEdgeInsets,
         output: CloudKeyViewModelOutput? = nil) {
        self.id = id
        self.backColor = backColor
        self.borderColor = borderColor
        self.title = title
        self.xButton = xButton
        self.insets = insets
        self.output = output
    }

    func onTap() {
        output?.didTapAt(self)
    }
}


extension CloudKeyCellViewModel: Differentiable {
    var differenceIdentifier: AnyHashable {
        id
    }

    func isContentEqual(to source: CloudKeyCellViewModel) -> Bool {
        source.backColor == backColor &&
        source.borderColor == borderColor &&
        source.title == title &&
        source.xButton == xButton &&
        source.insets == insets
    }
}





