import RealmSwift

// Структура для папок
struct FolderData {
    var name: String
    var emails: [EmailMessage]
}

// Реализация классов для Realm
class Folder: Object {
    @objc dynamic var name: String = ""
    let emails = List<EmailMessage>()
}

// Класс для вложений
class Attachment: Object {
    @objc dynamic var filename: String = ""
    @objc dynamic var filenameToTemporarySave: String = ""
    @objc dynamic var mimeType: String = ""
    @objc dynamic var size: Int = 0
    @objc dynamic var content: Data = Data() // Временно для хранения перед сохранением
}

// Класс для контактов
class ContactMail: Object {
    @objc dynamic var displayName: String = ""
    @objc dynamic var mailbox: String = ""
}

// Класс для сообщений
class EmailMessage: Object {
    @objc dynamic var id: String = UUID().uuidString // Уникальный идентификатор
    @objc dynamic var date: Date = Date()
    @objc dynamic var from: String = ""
    @objc dynamic var sender: String = ""
    @objc dynamic var to: String = ""
    @objc dynamic var subject: String = ""
    @objc dynamic var mimeVersion: String = ""
    @objc dynamic var contentType: String = ""
    @objc dynamic var boundary: String = ""
    @objc dynamic var contentTransferEncoding: String = ""
    @objc dynamic var body: String = ""
    @objc dynamic var htmlBody: String = ""
    @objc dynamic var received: Date?
    @objc dynamic var references: String? = nil
    @objc dynamic var messageId: String = ""
    @objc dynamic var isPrivate: Bool = false
    @objc dynamic var isRead: Bool = false // Добавлено свойство
    var cc = List<ContactMail>()
    var bcc = List<ContactMail>()
    var replyTo = List<ContactMail>()
    var attachments = List<Attachment>()
    
    // Новые свойства
    @objc dynamic var userAgent: String = "" // X-Mailer header
    var htmlInlineAttachments = List<Attachment>()
    var requiredPartsForRendering = List<String>() // Хранение необходимых частей для рендеринга

    override static func primaryKey() -> String? {
        return "id"
    }
    
    // Инициализатор для конвертации из EmailMessageModel в EmailMessage
    convenience init(model: EmailMessageModel) {
        self.init()
        self.id = model.id
        self.date = model.date
        self.from = model.from
        self.sender = model.sender
        self.to = model.to
        self.subject = model.subject
        self.mimeVersion = model.mimeVersion
        self.contentType = model.contentType
        self.boundary = model.boundary
        self.contentTransferEncoding = model.contentTransferEncoding
        self.body = model.body
        self.htmlBody = model.htmlBody
        self.received = model.received
        self.references = model.references
        self.messageId = model.messageId
        self.isPrivate = model.isPrivate
        self.isRead = model.isRead // Добавлено свойство
        self.cc.append(objectsIn: model.cc.map { ContactMail(dto: $0) })
        self.bcc.append(objectsIn: model.bcc.map { ContactMail(dto: $0) })
        self.replyTo.append(objectsIn: model.replyTo.map { ContactMail(dto: $0) })
        self.attachments.append(objectsIn: model.attachments.map { Attachment(dto: $0) })
        self.userAgent = model.userAgent
        self.htmlInlineAttachments.append(objectsIn: model.htmlInlineAttachments.map { Attachment(dto: $0) })
        self.requiredPartsForRendering.append(objectsIn: model.requiredPartsForRendering)
    }
}

// Добавляем инициализаторы для моделей вложений и контактов
extension Attachment {
    convenience init(dto: AttachmentModel) {
        self.init()
        self.filename = dto.filename
        self.filenameToTemporarySave = dto.filenameToTemporarySave
        self.mimeType = dto.mimeType
        self.size = dto.size
        self.content = dto.content
    }
}

extension ContactMail {
    convenience init(dto: ContactMailModel) {
        self.init()
        self.displayName = dto.displayName
        self.mailbox = dto.mailbox
    }
}
