//
//  ListAllMailHeaders.swift
// 06.06.2024.
//

extension Reply.Mail {
    struct MailHeadersResponse: Decodable {
        let elapsedTime: Int?
        let mail: [MailDTO]
        let reqId: String
        let status: String
        let version: String?

        enum CodingKeys: String, CodingKey {
            case elapsedTime = "elapsed_time"
            case mail = "mail"
            case reqId = "req_id"
            case status = "status"
            case version = "version"
        }
    }
}
