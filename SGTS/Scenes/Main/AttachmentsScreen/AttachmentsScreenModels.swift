//
//  AttachmentsScreenModels.swift
//  SGTS
//
//  Created by Roman Vakulenko on 12.06.2024.
//

import DifferenceKit
import UIKit

enum AttachmentsScreenModel {

    enum Errors: Error {
        case cantFetchData
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
