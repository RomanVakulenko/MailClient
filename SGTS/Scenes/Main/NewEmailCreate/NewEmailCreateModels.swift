//
//  NewEmailCreateModels.swift
//  SGTS
//
//  Created by Roman Vakulenko on 02.05.2024.
//

import DifferenceKit
import UIKit

enum NewEmailCreateModels {

    enum AlertAtOrCase {
        case fillingFieldTo, fillingFieldCopy, sendingEmailIsOk, sendingEmailFailed, sendingEmailEmptyToField, attachingFiles, gettingAllContactListItems, saveAsDraftOrNot, savingAsDraft
    }

    enum NewReOrFwdEmailType {
        case newEmail, reply, replyAll, forward
    }

    enum Errors: Error {
        case cantSaveMailToDatabase
        case errorAtSending
        case errorAtAddingToFolder
        case errorAtCreatingFolder
        case errorAtDeletingFolder
    }

    enum DropdownMenuID {
        case attachmentMenu, threeDotsMenu
    }

    enum DropdownMenuTitle {
        case deleteMail, saveDraft, attachFile, pickFotoFromGallary
    }

    struct oneTitleOfDropdownMenu {
        let enumCaseOfDropdownMenu: DropdownMenuTitle
        let attributedString: NSAttributedString
    }

    struct ViewModel {
        let navBar: CustomNavBar
        let backViewColor: UIColor
        let separatorColor: UIColor
        let hasAttachment: Bool

        let views: [AnyDifferentiable]
        let items: [AnyDifferentiable]
    }

}
