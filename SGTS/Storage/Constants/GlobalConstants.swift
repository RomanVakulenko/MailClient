//
//  GlobalConstants.swift
// 01.04.2024.
//

import CoreFoundation

enum GlobalConstants {
    static let appVersion = "1.0.39"
    static let appGroupIdentifier = "group.sgts.kz"
    static let someConstant = "someConstant"
    static let keyToSavePinCode = "keyToSavePinCode"
    static let keyToSaveLanguage = "keyToSaveLanguage" // ?? так ли ?? TODO
//    static let languageWasChangedNotification = "" //TODO
    static let dropdownMenuTagNewEmailCreateView = 123
    static let shadowForDropdownMenuTagNewEmailCreateView = 124

    static let transparentViewTag = 221
    static let shadowForDropdownMenuTagEmailPickingView = 222
    static let dropdownMenuTagEmailPickingView = 223

    static let shadowForDropdownMenuTagImageFullScreenView = 322
    static let dropdownMenuTagImageFullScreenView = 323

    static let dropdownMenuTagUserProfileSendReportView = 400
    static let shadowForDropdownMenuTagUserProfileSendReportView = 401

    static let cloudAttachmentTextLength20Сhars: Int = 20
    static let cloudAttachmentTextWidthPoints: CGFloat = 128
    static let xButtonWidth: CGFloat = 14
    static let folders: [String] = [
        GlobalConstants.sentEmails,
        GlobalConstants.outgoingEmails,
        GlobalConstants.drafts,
        GlobalConstants.archivedEmails,
        GlobalConstants.deletedEmails
    ]
    static let inboxEmails = "Inbox"
    static let sentEmails = "Sent"
    static let outgoingEmails = "Outgoing"

    static let drafts = "Drafts"
    static let archivedEmails = "Archived"
    static let deletedEmails = "Deleted"

    static let keySK = "keyToSaveSk"
    static let keyCallbackCode = "keyToSaveCallbackCode"
    static let keyCallbackState = "keyToSaveCallbackState"
    
    static let keyFromContainerCN = "KeyToSaveCNFromContainer"
    static let keyFromContainerSerialNumber = "KeyToSaveSerialNumberFromContainer"
    static let keyFromContainerMail = "KeyToSaveMailFromContainer"
    static let keyFromContainerO = "KeyToSaveOFromContainer"
    static let keyFromContainerC = "KeyToSaveCFromContainer"
    
    static let keyFromToken = "KeyToSaveTokenFromContainer"
    static let keyFromTokenExpire = "KeyToSaveTokenExpireromContainer"
    static let keyFromContainerPassword = "keyFromContainerPassword"
    static let keyFromIsFaceIdEnable = "KeyToSaveIsFaceIdEnable"
    
    static let keyFromAppUID = "keyFromAppUID"
    static let userSignature = "userSignature"
}

