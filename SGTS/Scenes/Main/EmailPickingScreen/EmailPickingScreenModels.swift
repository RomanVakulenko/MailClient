//
//  EmailPickingScreenModels.swift
//  SGTS
//
//  Created by Roman Vakulenko on 20.05.2024.
//

import DifferenceKit
import UIKit

enum EmailPickingScreenModel {

    enum AlertAtOrCase {
        case movingToSentFolder, movingToDraftsFolder, movingToDeletedFolder, movingToArchivedFolder, gettingMail, movedSuccessfully, areYorReallyWantToDelete, areYorReallyWantToArchive
    }

    enum Errors: Error {
        case cantSaveMailToDatabase
        case errorAtSending
        case errorAtAddingToFolder
        case errorAtCreatingFolder
        case errorAtDeletingFolder
    }
    enum DropdownMenuTitle {
        case reply, replyToAll, forward, moveTo, markAsRead, markAsUnread
    }

    struct oneTitleOfDropdownMenu {
        let enumCaseOfDropdownMenu: DropdownMenuTitle
        let attributedString: NSAttributedString
    }

    struct ViewModel {
        let backViewColor: UIColor

        let leftBarButtonImage: UIImage
        let backNavBarButtonColor: UIColor
        let screenTitle: NSAttributedString

        let archiveNavBarIcon: UIImage
        let trashNavBarIcon: UIImage
        let unreadNavBarIcon: UIImage
        let threeDotsNavBarIcon: UIImage

        let checkBoxButtonImage: UIImage
        let checkBoxTitle: NSAttributedString

        let separatorColor: UIColor
        let tabBarTitle: String
        let tabBarImage: UIImage
        let tabBarSelectedImage: UIImage
        
        let items: [AnyDifferentiable]
    }
}
