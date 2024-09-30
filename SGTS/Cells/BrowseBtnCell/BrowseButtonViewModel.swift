//
//  BrowseButtonCellViewModel.swift
//  SGTS
//
//  Created by Roman Vakulenko on 09.04.2024.
//

import Foundation
import DifferenceKit


protocol BrowseButtonViewModelOutput: AnyObject {
    func didTapAt(_ viewModel: BrowseButtonCellViewModel)
}


struct BrowseButtonCellViewModel {
    let id: AnyHashable
    let title: NSAttributedString
    let borderColor: UIColor
    let insets: UIEdgeInsets

    weak var output: BrowseButtonViewModelOutput?

    init(id: AnyHashable, title: NSAttributedString, borderColor: UIColor, insets: UIEdgeInsets, output: BrowseButtonViewModelOutput? = nil) {
        self.id = id
        self.title = title
        self.borderColor = borderColor
        self.insets = insets
        self.output = output
    }

    func onTap() {
        output?.didTapAt(self)
    }
}


extension BrowseButtonCellViewModel: Differentiable {
    var differenceIdentifier: AnyHashable {
        id
    }

    func isContentEqual(to source: BrowseButtonCellViewModel) -> Bool {
        insets == source.insets &&
        title == source.title &&
        borderColor == source.borderColor
    }
}




