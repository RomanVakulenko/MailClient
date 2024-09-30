//
//  UserProfileModels.swift
//  SGTS
//
//  Created by Roman Vakulenko on 16.06.2024.
//

import DifferenceKit
import UIKit

enum UserProfileModel {

    struct ViewModel {
        let navBarBackground: UIColor
        let backViewColor: UIColor
        let navBar: CustomNavBar
        let separatorUnderNavBarColor: UIColor

        let items: [AnyDifferentiable]
    }

    enum MenuItems {
        case userNameAndEmail
        case changePinCode
        case signature
        case report
        case deleteMailForServer
        case unsafeOutputAlert
        case darkTheme
        case info
    }

}
