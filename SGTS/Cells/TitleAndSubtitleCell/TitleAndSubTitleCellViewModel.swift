//
//  TitleAndSubTitleCellViewModel.swift
//  SGTS
//
//  Created by Roman Vakulenko on 09.04.2024.
//

import Foundation
import DifferenceKit

struct TitleAndSubTitleCellViewModel {
    let id: AnyHashable
    let title: NSAttributedString
    let subTitle: NSAttributedString
    let insets: UIEdgeInsets

    init(id: AnyHashable,
         title: NSAttributedString,
         subTitle: NSAttributedString,
         insets: UIEdgeInsets = .zero) {
        self.id = id
        self.title = title
        self.subTitle = subTitle
        self.insets = insets
    }
}


extension TitleAndSubTitleCellViewModel: Differentiable {
    var differenceIdentifier: AnyHashable {
        id
    }

    func isContentEqual(to source: TitleAndSubTitleCellViewModel) -> Bool {
        source.title == title &&
        source.subTitle == subTitle &&
        source.insets == insets
    }
}
