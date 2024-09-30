//
//  MovePickedEmailsModels.swift
//  SGTS
//
//  Created by Roman Vakulenko on 24.05.2024.
//

import DifferenceKit
import UIKit

enum MovePickedEmailsModel {

    struct ViewModel {
        let grayViewColor: UIColor
        let extendedMenuMoveToColor: UIColor
        let titleOfExtendedMenu: NSAttributedString

        let toAlreadySentTitle: NSAttributedString
        let toDraftsTitle: NSAttributedString
        let toArchiveTitle: NSAttributedString
        let toDeletedTitle: NSAttributedString
        
        let cancelTitle: NSAttributedString
    }
}
