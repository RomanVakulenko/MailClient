//
//  SecretKeySelectorModels.swift
//  SGTS
//
//  Created by Roman Vakulenko on 12.04.2024.
//

import DifferenceKit
import UIKit

enum SecretKeySelectorModel {

    struct ViewModel {
        let navBarBackground: UIColor
        let backViewColor: UIColor
        let navBar: CustomNavBar
        let separatorColor: UIColor

        let items: [AnyDifferentiable]
    }

    enum MenuItems {
        case title
        case browse
        case cloud
        case passwordInput
        case nextStep
    }

    enum RouteError: Error {
        case invalidURL
        case cannotOpenURL
    }
}
