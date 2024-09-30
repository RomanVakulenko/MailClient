//
//  SetPinCodeModels.swift
//  SGTS
//
//  Created by Roman Vakulenko on 16.04.2024.
//

import DifferenceKit
import UIKit

enum SetPinCodeModel {

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
        case confirmPasswordInput
        case finishButton
    }

}
