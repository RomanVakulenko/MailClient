//
//  PinCodeModels.swift
//  SGTS
//
//  Created by Roman Vakulenko on 04.04.2024.
//

import DifferenceKit
import UIKit

enum PinCodeModel {

    enum Errors {
        case cameraAccessDenied,
             cameraAccessDeniedOrRestricted,
             errorAtFaceDetection
    }

    struct ViewModel {
        let items: [AnyDifferentiable]
        let enteredDigitsCount: Int
        let backColor: UIColor
        let title: NSAttributedString
        let navBar: CustomNavBar //уточнить - был ли тут навБар с шевроном назад
        let separatorColor: UIColor
        let enterPinLabel: NSAttributedString
        var circleColors: [UIColor]
        var didDeleteDigit: Bool
    }
    
}
