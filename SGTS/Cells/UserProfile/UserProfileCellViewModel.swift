//
//  UserProfileCellViewModel.swift
//  SGTS
//
//  Created by Roman Vakulenko on 18.06.2024.
//

import Foundation
import DifferenceKit

protocol UserProfileCellViewModelOutput: AnyObject {
    func didTapAtCell(_ viewModel: UserProfileCellViewModel)
}

struct UserProfileCellViewModel {
    let id: AnyHashable
    let cellBackColor: UIColor
    let avatarImage: UIImage
    let name: NSAttributedString
    let email: NSAttributedString
    let chevron: UIImage
    let insets: UIEdgeInsets

    weak var output: UserProfileCellViewModelOutput?

    init(id: AnyHashable, cellBackColor: UIColor, avatarImage: UIImage, name: NSAttributedString, email: NSAttributedString, chevron: UIImage, insets: UIEdgeInsets, output: UserProfileCellViewModelOutput? = nil) {
        self.id = id
        self.cellBackColor = cellBackColor
        self.avatarImage = avatarImage
        self.name = name
        self.email = email
        self.chevron = chevron
        self.insets = insets
        self.output = output
    }


    func didTapAtCell() {
        output?.didTapAtCell(self)
    }
}


extension UserProfileCellViewModel: Differentiable {
    var differenceIdentifier: AnyHashable {
        id
    }

    func isContentEqual(to source: UserProfileCellViewModel) -> Bool {
        source.cellBackColor == cellBackColor &&
        source.avatarImage == avatarImage &&
        source.name == name &&
        source.email == email &&
        source.chevron == chevron &&
        source.insets == insets
    }
}
