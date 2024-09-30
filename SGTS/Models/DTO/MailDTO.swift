//
//  MailDTO.swift
// 04.08.2024.
//

struct MailDTO: Codable {
    let encryptedSize: String?
    let fileName: String?
    let fileSize: String?
    let mailHistory: [MailHistoryDTO]?
    let mailLuid: String
    let mailStatus: String?
    let mailUidl: String
    let recipients: [[String]]
    let sender: [String]
    let type: String?

    enum CodingKeys: String, CodingKey {
        case encryptedSize = "encrypted_size"
        case fileName = "file_name"
        case fileSize = "file_size"
        case mailHistory = "mail_history"
        case mailLuid = "mail_luid"
        case mailStatus = "mail_status"
        case mailUidl = "mail_uidl"
        case recipients = "recipients"
        case sender = "sender"
        case type = "type"
    }
}

struct MailHistoryDTO: Codable {
    let action: String?
    let timestamp: String?

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        action = try container.decode(String.self)
        timestamp = try container.decode(String.self)
    }
}
