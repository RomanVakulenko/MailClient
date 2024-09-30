//
//  IconTextAndChevronCellViewModel.swift
//  SGTS
//
//  Created by Roman Vakulenko on 18.06.2024.
//


import Foundation
import DifferenceKit

protocol IconTextAndChevronCellViewModelOutput: AnyObject {
    func didTapAtCell(_ viewModel: IconTextAndChevronCellViewModel)
}

struct IconTextAndChevronCellViewModel {
    let id: AnyHashable
    let cellBackColor: UIColor
    let icon: UIImage
    let title: NSAttributedString
    let chevron: UIImage
    let insets: UIEdgeInsets

    weak var output: IconTextAndChevronCellViewModelOutput?

    init(id: AnyHashable, cellBackColor: UIColor, icon: UIImage, title: NSAttributedString, chevron: UIImage, insets: UIEdgeInsets, output: IconTextAndChevronCellViewModelOutput? = nil) {
        self.id = id
        self.cellBackColor = cellBackColor
        self.icon = icon
        self.title = title
        self.chevron = chevron
        self.insets = insets
        self.output = output
    }

    func didTapAtCell() {
        output?.didTapAtCell(self)
    }
}

extension IconTextAndChevronCellViewModel: Differentiable {
    var differenceIdentifier: AnyHashable {
        id
    }

    func isContentEqual(to source: IconTextAndChevronCellViewModel) -> Bool {
        source.cellBackColor == cellBackColor &&
        source.icon == icon &&
        source.title == title &&
        source.chevron == chevron &&
        source.insets == insets
    }
}
