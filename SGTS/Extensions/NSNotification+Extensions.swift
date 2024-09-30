//
//  NSNotification+Extensions.swift
//  SGTS
//
//  Created by Roman Vakulenko on 08.04.2024.
//

import Foundation
import UIKit


extension NSNotification.Name {
    static let screenThemeWasChanged = NSNotification.Name("ScreenThemeWasChanged")
    static let languageWasChangedNotification = NSNotification.Name("LanguageWasChangedNotification")
    static let keyboardWillShow = UIResponder.keyboardWillShowNotification
    static let keyboardWillHide = UIResponder.keyboardWillHideNotification

    static let mailStartScreenSelected = NSNotification.Name("ScreenThemeWasChanged")
    static let userProfileScreenSelected = NSNotification.Name("LanguageWasChangedNotification")

    static let closeSideMenuAtSwipe = NSNotification.Name("closeSideMenuAtSwipe")
    static let userNameAndEmail = NSNotification.Name("userNameAndEmail")
    static let incoming = NSNotification.Name("incoming")
    static let sent = NSNotification.Name("sent")
    static let outgoing = NSNotification.Name("outgoing")

    static let drafts = NSNotification.Name("drafts")
    static let archived = NSNotification.Name("archived")
    static let deleted = NSNotification.Name("deleted")

    static let attachments = NSNotification.Name("attachments")
    static let settings = NSNotification.Name("settings")
    static let searchContactsAtServer = NSNotification.Name("searchContactsAtServer")
}
