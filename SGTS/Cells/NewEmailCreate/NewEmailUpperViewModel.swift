//
//  NewEmailUpperViewModel.swift
//  SGTS
//
//  Created by Roman Vakulenko on 03.05.2024.
//
import UIKit
import DifferenceKit

enum NewEmailCreateUpperModel {

    enum AddressField {
        case toField, copyField
    }

    struct ViewModel {
        let backColor: UIColor

        let fromLabel: NSAttributedString
        let toLabel: NSAttributedString
        let copyLabel: NSAttributedString
        let titleThemeOfEmail: NSAttributedString

        let fromEmailAdressText: NSAttributedString

        let toEmailAddressesText: String?
        let toRectIcon: UIImage
        let toCopyTextColor: UIColor
        let copyEmailAdressesText: String?
        let copyRectIcon: UIImage
        let textThemeOfEmail: String?

        let chevronButtonDown: UIImage
        let separatorColor: UIColor
        let insets: UIEdgeInsets
        let isEmptyViewVisible: Bool?


    }
}


extension NewEmailCreateUpperModel.ViewModel: Differentiable {
    var differenceIdentifier: AnyHashable {
        toEmailAddressesText
    }

    func isContentEqual(to source: NewEmailCreateUpperModel.ViewModel) -> Bool {
        source.backColor == backColor &&

        source.fromEmailAdressText == fromEmailAdressText &&

        source.toRectIcon == toRectIcon &&
        source.toCopyTextColor == toCopyTextColor &&
        source.copyEmailAdressesText == copyEmailAdressesText &&
        source.copyRectIcon == copyRectIcon &&
        source.textThemeOfEmail == textThemeOfEmail &&

        source.separatorColor == separatorColor &&
        source.insets == insets &&
        source.isEmptyViewVisible == isEmptyViewVisible
    }
}
