//
//  FiletMetaDTOReply.swift
// 11.06.2024.
//

extension Reply.Mail {
    struct MailInfoDTO: Codable {
        let elapsedTime: Int?
        let mailMeta: MailDTO?
        let reqId: String?
        let status: String?
        let version: String?
        
        enum CodingKeys: String, CodingKey {
            case elapsedTime = "elapsed_time"
            case mailMeta = "mail_meta"
            case reqId = "req_id"
            case status
            case version
        }
    }
}
