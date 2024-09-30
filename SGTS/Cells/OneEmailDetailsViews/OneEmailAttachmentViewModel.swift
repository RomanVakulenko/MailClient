//
//  OneEmailAttachmentModel.swift
//  SGTS
//
//  Created by Roman Vakulenko on 23.04.2024.
//

import Foundation
import DifferenceKit


struct OneEmailAttachmentViewModel {
    let id: AnyHashable
    let backColor: UIColor
    let attachmentTitle: NSAttributedString
    let insets: UIEdgeInsets

    let items: [AnyDifferentiable]
    let widths: [CGFloat]

    init(id: AnyHashable, backColor: UIColor, attachmentTitle: NSAttributedString, insets: UIEdgeInsets, items: [AnyDifferentiable], widths: [CGFloat]) {
        self.id = id
        self.backColor = backColor
        self.attachmentTitle = attachmentTitle
        self.insets = insets
        self.items = items
        self.widths = widths
    }
}

extension OneEmailAttachmentViewModel: Differentiable {
    var differenceIdentifier: AnyHashable {
        id
    }

    func isContentEqual(to source: OneEmailAttachmentViewModel) -> Bool {
        source.attachmentTitle == attachmentTitle &&
        source.backColor == backColor &&
        source.attachmentTitle == attachmentTitle &&
        source.insets == insets &&
        source.widths == widths
    }
}

