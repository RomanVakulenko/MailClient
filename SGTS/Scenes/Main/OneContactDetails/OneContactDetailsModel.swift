//
//  OneContactDetailsModel.swift
//  SGTS
//
//  Created by Roman Vakulenko on 31.07.2024.
//

import DifferenceKit
import UIKit

enum OneContactDetailsModel {

    enum Errors: Error {
        case cantFetchAllContacts, cantSearchContacts
    }

    struct ViewModel {
        let navBarBackground: UIColor
        let navBar: CustomNavBar
        let backColor: UIColor
        let separatorColor: UIColor
        let avatarImg: UIImage
        let fullName: NSAttributedString

        let emailTitle: NSAttributedString
        let emailAddress: NSAttributedString

        let phoneTitle: NSAttributedString
        let phoneNumber: NSAttributedString

        let iinTitle: NSAttributedString
        let iin: NSAttributedString
    }

}
