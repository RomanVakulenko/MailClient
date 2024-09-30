//
//  UserProfileChangePinCodeModels.swift
//  SGTS
//
//  Created by Roman Vakulenko on 28.06.2024.
//

import DifferenceKit
import UIKit

enum UserProfileChangePinCodeModel {

    struct ViewModel {
        let navBarBackground: UIColor
        let backViewColor: UIColor
        let navBar: CustomNavBar
        let separatorColor: UIColor

        let items: [AnyDifferentiable]
    }

    enum MenuItems {
        case enterCurrentPinCode
        case enterNewPinCode
        case confirmNewPinCode
        case saveButton
        case cancelButton
    }

}
