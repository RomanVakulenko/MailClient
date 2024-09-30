//
//  UserProfileSendReportModels.swift
//  SGTS
//
//  Created by Roman Vakulenko on 02.07.2024.
//

import DifferenceKit
import UIKit

enum UserProfileSendReportModels {

    enum Errors: Error {
        case cantSaveMailToDatabase
    }

    enum DropdownMenuTitle {
        case attachFile, pickFotoFromGallary
    }

    struct oneTitleOfDropdownMenu {
        let enumCaseOfDropdownMenu: DropdownMenuTitle
        let attributedString: NSAttributedString
    }

    struct ViewModel {
        let navBar: CustomNavBar
        let backViewColor: UIColor
        let separatorColor: UIColor
        let hasAttachment: Bool

        let views: [AnyDifferentiable]
        let items: [AnyDifferentiable]
    }

}
