//
//  LanguageManager.swift
// 01.04.2024.
//

import Foundation

func getString(_ key: InterfaceTranslation) -> String {
    switch Lang.currentLanguage {
    case .ru:
        return key.getRU()
//    case .kz:
//        return key.getKZ()
    }
}

struct Lang {
    static var currentLanguage: Language {
        get {
            if let langString = UserDefaults.standard.string(forKey: GlobalConstants.keyToSaveLanguage),
               let language = Language(rawValue: langString) {
                return language
            }
            else {
                return .ru
            }
        }
        set(newLanguage) {
            let currentLanguage = Lang.currentLanguage
            if newLanguage != currentLanguage {
                UserDefaults.standard.set(newLanguage.rawValue,
                                          forKey: GlobalConstants.keyToSaveLanguage)

                UserDefaults.standard.synchronize()

                let notificationName = NSNotification.Name.languageWasChangedNotification
                NotificationCenter.default.post(name: notificationName, object: nil)
            }
        }
    }
}

enum InterfaceTranslation {
    case error
    case closeAction

    case initialTitle
    case initialTitleVersion

    case aboutAppTitle
    case aboutAppCERTEX
    case aboutAppCopyRights

    case logInRegistrLoadKeysFromPhone
    case logInRegistrScanQRKode
    case registrationTitle

    case pinCodeTitle
    case enterPin //universal

    case enterPasswordTitle
    case enterPasswordSubTitle

    case enterPasswordRectangleTitle
    case enterPasswordNextStep

    case enterQRPasswordSubTitle
    case enterQRPasswordBorderTitle
    case enterQRPasswordNextStep

    case secretKeySelectorTitle
    case secretKeySelectorSubTitle
    case secretKeySelectorPlaceholderOrBorderTitle
    case secretKeySelectorBrowseTitle
    case secretKeySelectorBiometryAlert
    case secretKeySelectorBrowseAlert

    case setPinCodeTitle
    case setPinCodeSubTitle
    case setPinCodeToggleTitle
    case confirmEnterPin //universal
    case setPinCodeFinishRegistration


    case mailStartScreenTitle
    case mailStartScreenCloudNewEmailTitle
    case messagesAlert

    case oneEmailDetailsUpperViewReceivedSubTitle

    case oneEmailDetailsUpperViewFromTitle
    case oneEmailDetailsUpperViewToTitle

    case oneEmailDetailsUpperViewDidSendTitle
    case oneEmailDetailsUpperViewDidReceiveTitle

    case oneEmailDetailsAttachedFilesTitle
    case oneEmailAttachedFotoTitle
    case oneMessageAlert

    case reply
    case replyToAll
    case forward
    case oneEmailDetailsSwipeInstruction

    case imageFullScreenDownloadImage
    case imageFullScreenOpenInOtherApp

    case newEmailCreateUpperViewFromTitle
    case newEmailCreateUpperViewToTitle
    case newEmailCreateUpperViewCopyTitle
    case newEmailCreateUpperViewThemeTitle
    case newEmailCreateScreenTitle
    case newEmailCreateScreenSendButtonTitle

    case newEmailCreatePlaceholderToCopy
    case newEmailCreatePlaceholderTheme

    case newEmailCreateThreeDotsMenuDeleteLabel
    case newEmailCreateThreeDotsMenuSaveDraftLabel

    case newEmailCreateAttachFileLabel
    case newEmailCreateChooseFоtoFromGalleryLabel
    case newEmailCreateTextViewPlaceholder
    case newEmailCreateCanNotGetFileOrFoto
    case newEmailCreateAlertAtToField
    case newEmailCreateAlertAtCopyField
    case newEmailCreateAlertAtAddingFiles
    case newEmailCreateSavingDraft
    case newEmailCreateSendingOk
    case newEmailCreateSendingFailed
    case newEmailCreateToFieldIsEmpty
    
    case newEmailCreateNotAbleToAddFiles
    case newEmailCreateFileSizeIsBiggerThanLimit


    case emailPickingScreenCheckBoxTitlePickAll
    case errorAtMovingToSentFolder
    case errorAtMovingToDraftsFolder
    case errorAtMovingToDeletedFolder
    case errorAtMovingToArchivedFolder
    case errorAtGettingMail
    case doYouWantToDelete
    case doYouWantToArchive
    case movedSuccessfully

    case markEmailAsRead
    case markEmailAsUnread
    case moveEmailTo

    case alreadySentMessage
    case draftMessages
    case archivedMessages
    case deletedMessages
    case сancelTitle
    case saveTitle
    case closeTitle
    case someNotification

    case addressBookScreenTitle
    case addressBookCantGetAddressesAndNames
    case searchViewPlaceholder

    case attachmentsTitle

    case emailsTabBarItemTitle

    case userProfileTitle
    case userProfileChangePinCode
    case userProfileSignature
    case userProfileReport
    case userProfileDeleteMailForServer
    case userProfileUnsafeOutputAlert
    case userProfileDarkTheme

    case changeUserNameTitle
    case userNameSubtitle
    case senderNameTitleAtBorded

    case userProfileChangePinCodeTitle
    case userProfileEnterCurrentPinCode
    case userProfileEnterNewPinCode
    case userProfileConfirmNewPinCode

    case userProfileSetSingnaturePlaceholder
    case userProfileSendReportTitleAndSubject

    case outgoingMessages
    case settingsTitle
    case searchContactsAtWeb
    case searchContacts
    case searchTitleForTabBarItem

    case oneContactDetailsTitle
    case oneContactDetailsEmailTitle
    case oneContactDetailsPhoneTitle
    case oneContactDetailsIINTitle
    case oneContactDetailsInvalidPhoneNumber
}

