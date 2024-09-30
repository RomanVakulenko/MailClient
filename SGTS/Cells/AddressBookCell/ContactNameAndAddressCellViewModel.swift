//
//  ContactNameAndAddressCellViewModel.swift
//  SGTS
//
//  Created by Roman Vakulenko on 29.05.2024.
//

import Foundation
import DifferenceKit

protocol ContactNameAndAddressCellViewModelOutput: AnyObject {
    func didLongPressAt(_ viewModel: ContactNameAndAddressCellViewModel)
    func didTapAtOneEmail(_ viewModel: ContactNameAndAddressCellViewModel)
    func didTapAtAvatar(_ viewModel: ContactNameAndAddressCellViewModel)
}

struct ContactNameAndAddressCellViewModel {
    let id: String
    let cellBackColor: UIColor
    let avatarImage: UIImage?
    let name: NSAttributedString
    let email: NSAttributedString
    let chevron: UIImage

    let insets: UIEdgeInsets
    let separatorInset: UIEdgeInsets?

    weak var output: ContactNameAndAddressCellViewModelOutput?

    init(id: String, cellBackColor: UIColor, avatarImage: UIImage?, name: NSAttributedString, email: NSAttributedString, chevron: UIImage, insets: UIEdgeInsets, separatorInset: UIEdgeInsets?, output: ContactNameAndAddressCellViewModelOutput? = nil) {
        self.id = id
        self.cellBackColor = cellBackColor
        self.avatarImage = avatarImage
        self.name = name
        self.email = email
        self.chevron = chevron
        self.insets = insets
        self.separatorInset = separatorInset
        self.output = output
    }


    func onLongTap() {
        output?.didLongPressAt(self)
    }
    
    func didTapAtAvatar() {
        output?.didTapAtAvatar(self)
    }

    func didTapAtEmail() {
        output?.didTapAtOneEmail(self)
    }
}


extension ContactNameAndAddressCellViewModel: Differentiable {
    var differenceIdentifier: String {
        id
    }

    func isContentEqual(to source: ContactNameAndAddressCellViewModel) -> Bool {
        source.cellBackColor == cellBackColor &&
        source.avatarImage == avatarImage &&
        source.name == name &&
        source.email == email &&
        source.chevron == chevron &&
        source.separatorInset == separatorInset &&
        source.insets == insets
    }
}
