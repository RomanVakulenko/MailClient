//
//  OneEmailDetailsButtonsViewModel.swift
//  SGTS
//
//  Created by Roman Vakulenko on 23.04.2024.
//

import Foundation
import DifferenceKit

struct OneEmailDetailsButtonsViewModel {

    enum ButtonType {
        case reply, replyToAll, forward
    }
    let id: AnyHashable
    let replyTitle: NSAttributedString
    let replyBackColor: UIColor
    let replyImage: UIImage

    let replyToAllTitle: NSAttributedString
    let replyToAllBackColor: UIColor
    let replyToAllImage: UIImage
    let borderColor: UIColor

    let forwardTitle: NSAttributedString
    let forwardBackColor: UIColor
    let forwardImage: UIImage

    let insets: UIEdgeInsets

    init(id: AnyHashable, replyTitle: NSAttributedString, replyBackColor: UIColor, replyImage: UIImage, replyToAllTitle: NSAttributedString, replyToAllBackColor: UIColor, replyToAllImage: UIImage, borderColor: UIColor, forwardTitle: NSAttributedString, forwardBackColor: UIColor, forwardImage: UIImage, insets: UIEdgeInsets) {
        self.id = id
        self.replyTitle = replyTitle
        self.replyBackColor = replyBackColor
        self.replyImage = replyImage
        self.replyToAllTitle = replyToAllTitle
        self.replyToAllBackColor = replyToAllBackColor
        self.replyToAllImage = replyToAllImage
        self.borderColor = borderColor
        self.forwardTitle = forwardTitle
        self.forwardBackColor = forwardBackColor
        self.forwardImage = forwardImage
        self.insets = insets
    }
}


extension OneEmailDetailsButtonsViewModel: Differentiable {
    var differenceIdentifier: AnyHashable {
        id
    }

    func isContentEqual(to source: OneEmailDetailsButtonsViewModel) -> Bool {
        return source.id == id &&
               source.replyTitle == replyTitle &&
               source.replyBackColor == replyBackColor &&
               source.replyImage == replyImage &&
               source.replyToAllTitle == replyToAllTitle &&
               source.replyToAllBackColor == replyToAllBackColor &&
               source.replyToAllImage == replyToAllImage &&
               source.borderColor == borderColor &&
               source.forwardTitle == forwardTitle &&
               source.forwardBackColor == forwardBackColor &&
               source.forwardImage == forwardImage &&
               source.insets == insets
    }
}




