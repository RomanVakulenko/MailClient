//
//  MailStartScreenModels.swift
//  SGTS
//
//  Created by Roman Vakulenko on 17.04.2024.
//

import DifferenceKit
import UIKit

enum MailStartScreenModel {

    enum Errors: Error {
        case cantFetchMails
    }

    struct ViewModel {
        let navBarBackground: UIColor
        let backViewColor: UIColor
        let navBar: CustomNavBar
        let separatorColor: UIColor

        let tabBarTitle: String
        let tabBarImage: UIImage
        let tabBarSelectedImage: UIImage

        let items: [AnyDifferentiable]
    }

}
