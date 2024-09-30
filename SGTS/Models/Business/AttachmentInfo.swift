//
//  AttachmentInfo.swift
// 11.07.2024.
//
import Foundation

struct AttachmentInfo {
    let filename: String?
    let mimeType: String?
    let data: Data?
    let decodedString: String?
    let partID: String?
    let size: Int?
    
    init(filename: String?, mimeType: String?, data: Data?, decodedString: String?, partID: String?, size: Int?) {
        self.filename = filename
        self.mimeType = mimeType
        self.data = data
        self.decodedString = decodedString
        self.partID = partID
        self.size = size
    }

    init(attachment: Attachment) {
        self.filename = attachment.filename
        self.mimeType = attachment.mimeType
        self.data = attachment.content
        self.decodedString = nil // Если требуется, можно добавить логику для декодирования
        self.partID = nil // Это поле можно заполнить, если есть соответствующая логика
        self.size = attachment.size
    }
}
