//
//  EmailModels.swift
//  SGTS
//
//  Created by Roman Vakulenko on 18.04.2024.
//

import UIKit

struct EmailModels {
    var emailsArray: [EmailMessageWithNeededProperties]
}

struct EmailMessageWithNeededProperties {
    let id: String // id mail'a
    let fromName: String? 
    let senderEmail: String
    let to: String?
    let cc: String? //copy
    let bcc: String? //hidden copy
    let subject: String
    let body: String //for OneEmailDetails it is updatedHtmlBody
    let receivedDate: Date
    var isNewEmailIconDisplaying: Bool?
    let isPersonalToUserIconDisplaying: Bool?
    let isEmportantEmailIndicatorDisplaying: Bool?
    let isExternalEmailIconDisplaying: Bool?
    let isAttachmentIconDisplaying: Bool?
    let arrayOfAttachmentNamesAndExt: [String]?
    let arrayOfAttachmentNamesAndDataPreviewable: [AttachmentModel]?
    let hasFotos: Bool

    init(id: String, fromName: String? = nil, senderEmail: String, to: String? = nil, cc: String? = nil, bcc: String? = nil, subject: String, body: String, receivedDate: Date, isNewEmailIconDisplaying: Bool? = true, isPersonalToUserIconDisplaying: Bool? = false, isEmportantEmailIndicatorDisplaying: Bool? = false, isExternalEmailIconDisplaying: Bool? = false, isAttachmentIconDisplaying: Bool? = false, arrayOfAttachmentNamesAndExt: [String]?, arrayOfAttachmentNamesAndDataPreviewable: [AttachmentModel]? = nil, hasFotos: Bool) {
        self.id = id
        self.fromName = fromName
        self.senderEmail = senderEmail
        self.to = to
        self.cc = cc
        self.bcc = bcc
        self.subject = subject
        self.body = body
        self.receivedDate = receivedDate
        self.isNewEmailIconDisplaying = isNewEmailIconDisplaying
        self.isPersonalToUserIconDisplaying = isPersonalToUserIconDisplaying
        self.isEmportantEmailIndicatorDisplaying = isEmportantEmailIndicatorDisplaying
        self.isExternalEmailIconDisplaying = isExternalEmailIconDisplaying
        self.isAttachmentIconDisplaying = isAttachmentIconDisplaying
        self.arrayOfAttachmentNamesAndExt = arrayOfAttachmentNamesAndExt
        self.arrayOfAttachmentNamesAndDataPreviewable = arrayOfAttachmentNamesAndDataPreviewable
        self.hasFotos = hasFotos
    }
}
