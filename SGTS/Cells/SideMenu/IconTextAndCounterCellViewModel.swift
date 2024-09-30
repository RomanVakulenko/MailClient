//
//  SideMenuCellViewModel.swift
//  SGTS
//
//  Created by Roman Vakulenko on 04.07.2024.
//

import Foundation
import DifferenceKit

protocol IconTextAndCounterCellViewModelOutput: AnyObject {
    func didTapAtCell(_ viewModel: IconTextAndCounterCellViewModel)
}

struct IconTextAndCounterCellViewModel {
    let id: AnyHashable
    let cellBackColor: UIColor
    let icon: UIImage
    let title: NSAttributedString
    let counterText: NSAttributedString?
    let insets: UIEdgeInsets

    weak var output: IconTextAndCounterCellViewModelOutput?

    init(id: AnyHashable, cellBackColor: UIColor, icon: UIImage, title: NSAttributedString, counterText: NSAttributedString? = nil, insets: UIEdgeInsets, output: IconTextAndCounterCellViewModelOutput? = nil) {
        self.id = id
        self.cellBackColor = cellBackColor
        self.icon = icon
        self.title = title
        self.counterText = counterText
        self.insets = insets
        self.output = output
    }

    func didTapAtCell() {
        output?.didTapAtCell(self)
    }
}

extension IconTextAndCounterCellViewModel: Differentiable {
    var differenceIdentifier: AnyHashable {
        id
    }

    func isContentEqual(to source: IconTextAndCounterCellViewModel) -> Bool {
        source.cellBackColor == cellBackColor &&
        source.icon == icon &&
        source.title == title &&
        source.counterText == counterText &&
        source.insets == insets
    }
}
