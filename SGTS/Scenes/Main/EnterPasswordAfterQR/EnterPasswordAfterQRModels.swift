//
//  EnterPasswordAfterQRModels.swift
//  SGTS
//
//  Created by Roman Vakulenko on 09.04.2024.
//

import DifferenceKit
import UIKit

enum EnterPasswordAfterQRModel {

    struct ViewModel {
        let navBarBackground: UIColor
        let backViewColor: UIColor
        let navBar: CustomNavBar
        let separatorColor: UIColor

        let items: [AnyDifferentiable]
    }

    enum MenuItems {
        case title
        case passwordInput
        case nextStep
    }

}
