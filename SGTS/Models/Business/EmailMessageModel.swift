//
//  EmailMessageModel.swift
// 19.06.2024.
//

import Foundation

// Бизнес-модель для папок
struct FolderModel {
    let name: String
    let emails: [EmailMessageModel]
    
    init(name: String, emails: [EmailMessageModel]) {
        self.name = name
        self.emails = emails
    }
    
    init(dto: Folder) {
        self.name = dto.name
        self.emails = dto.emails.map { EmailMessageModel(dto: $0) }
    }
}

// Бизнес-модель для вложений
struct AttachmentModel: Equatable {
    let filename: String
    var filenameToTemporarySave: String
    let mimeType: String
    let size: Int
    var content: Data
    
    init(filename: String, filenameToTemporarySave: String, mimeType: String, size: Int, content: Data) {
        self.filename = filename
        self.filenameToTemporarySave = filenameToTemporarySave
        self.mimeType = mimeType
        self.size = size
        self.content = content
    }
    
    init(dto: Attachment) {
        self.filename = dto.filename
        self.filenameToTemporarySave = dto.filenameToTemporarySave
        self.mimeType = dto.mimeType
        self.size = dto.size
        self.content = dto.content
    }
    
    // Conform to Equatable
    static func == (lhs: AttachmentModel, rhs: AttachmentModel) -> Bool {
        return lhs.filename == rhs.filename &&
               lhs.filenameToTemporarySave == rhs.filenameToTemporarySave &&
               lhs.mimeType == rhs.mimeType &&
               lhs.size == rhs.size &&
               lhs.content == rhs.content
    }
}

// Бизнес-модель для контактов
struct ContactMailModel: Hashable {
    let displayName: String
    let mailbox: String
    
    init(displayName: String = "", mailbox: String = "") {
        self.displayName = displayName
        self.mailbox = mailbox
    }
    
    init(dto: ContactMail) {
        self.displayName = dto.displayName
        self.mailbox = dto.mailbox
    }
}

// Бизнес-модель для сообщений
struct EmailMessageModel {
    let id: String
    let date: Date
    let from: String
    let sender: String
    let to: String
    let subject: String
    let mimeVersion: String
    let contentType: String
    let boundary: String
    let contentTransferEncoding: String
    var body: String
    var htmlBody: String
    let received: Date?
    let references: String?
    let messageId: String
    let isPrivate: Bool
    let isRead: Bool // Добавлено свойство
    let cc: [ContactMailModel]
    let bcc: [ContactMailModel]
    let replyTo: [ContactMailModel]
    var attachments: [AttachmentModel]
    let userAgent: String // Новое свойство
    var htmlInlineAttachments: [AttachmentModel] // Новое свойство
    var requiredPartsForRendering: [String] // Новое свойство
    
    init(id: String,
         date: Date = Date(),
         from: String,
         sender: String,
         to: String,
         subject: String,
         mimeVersion: String,
         contentType: String,
         boundary: String,
         contentTransferEncoding: String,
         body: String,
         htmlBody: String,
         received: Date?,
         references: String?,
         messageId: String,
         isPrivate: Bool,
         isRead: Bool,
         cc: [ContactMailModel],
         bcc: [ContactMailModel],
         replyTo: [ContactMailModel],
         attachments: [AttachmentModel],
         userAgent: String,
         htmlInlineAttachments: [AttachmentModel],
         requiredPartsForRendering: [String]) {
        self.id = id
        self.date = date
        self.from = from
        self.sender = sender
        self.to = to
        self.subject = subject
        self.mimeVersion = mimeVersion
        self.contentType = contentType
        self.boundary = boundary
        self.contentTransferEncoding = contentTransferEncoding
        self.body = body
        self.htmlBody = htmlBody
        self.received = received
        self.references = references
        self.messageId = messageId
        self.isPrivate = isPrivate
        self.isRead = isRead
        self.cc = cc
        self.bcc = bcc
        self.replyTo = replyTo
        self.attachments = attachments
        self.userAgent = userAgent
        self.htmlInlineAttachments = htmlInlineAttachments
        self.requiredPartsForRendering = requiredPartsForRendering
    }
    
    init(dto: EmailMessage) {
        self.id = dto.id
        self.date = dto.date
        self.from = dto.from
        self.sender = dto.sender
        self.to = dto.to
        self.subject = dto.subject
        self.mimeVersion = dto.mimeVersion
        self.contentType = dto.contentType
        self.boundary = dto.boundary
        self.contentTransferEncoding = dto.contentTransferEncoding
        self.body = dto.body
        self.htmlBody = dto.htmlBody
        self.received = dto.received
        self.references = dto.references
        self.messageId = dto.messageId
        self.isPrivate = dto.isPrivate
        self.isRead = dto.isRead
        self.cc = dto.cc.map { ContactMailModel(dto: $0) }
        self.bcc = dto.bcc.map { ContactMailModel(dto: $0) }
        self.replyTo = dto.replyTo.map { ContactMailModel(dto: $0) }
        self.attachments = dto.attachments.map { AttachmentModel(dto: $0) }
        self.userAgent = dto.userAgent
        self.htmlInlineAttachments = dto.htmlInlineAttachments.map { AttachmentModel(dto: $0) }
        self.requiredPartsForRendering = Array(dto.requiredPartsForRendering)
    }
}
