//
//  CellWithWKWebViewViewModel.swift
//  SGTS
//
//  Created by Roman Vakulenko on 15.07.2024.
//

import UIKit
import DifferenceKit

struct CellWithWKWebViewViewModel: Equatable {
    let id: AnyHashable
    let backColor: UIColor
    let isUserInteractionEnabled: Bool?
    let showsVerticalScrollIndicator: Bool?
    let insets: UIEdgeInsets
    let htmlString: String?
    let htmlInlineAttachments: [AttachmentModel]
    
    init(id: AnyHashable,
         backColor: UIColor,
         isUserInteractionEnabled: Bool? = nil,
         showsVerticalScrollIndicator: Bool? = nil,
         insets: UIEdgeInsets,
         htmlString: String?,
         htmlInlineAttachments: [AttachmentModel]) {
        self.id = id
        self.backColor = backColor
        self.isUserInteractionEnabled = isUserInteractionEnabled
        self.showsVerticalScrollIndicator = showsVerticalScrollIndicator
        self.insets = insets
        self.htmlString = htmlString
        self.htmlInlineAttachments = htmlInlineAttachments
    }
    
    // Equatable conformance
    static func == (lhs: CellWithWKWebViewViewModel, rhs: CellWithWKWebViewViewModel) -> Bool {
        return lhs.id == rhs.id &&
               lhs.backColor == rhs.backColor &&
               lhs.isUserInteractionEnabled == rhs.isUserInteractionEnabled &&
               lhs.showsVerticalScrollIndicator == rhs.showsVerticalScrollIndicator &&
               lhs.insets == rhs.insets &&
               lhs.htmlString == rhs.htmlString &&
               lhs.htmlInlineAttachments == rhs.htmlInlineAttachments
    }
}

extension CellWithWKWebViewViewModel: Differentiable {
    var differenceIdentifier: AnyHashable {
        id
    }

    func isContentEqual(to source: CellWithWKWebViewViewModel) -> Bool {
        return self == source
    }
}
