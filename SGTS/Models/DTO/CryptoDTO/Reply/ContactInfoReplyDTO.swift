//
//  ContactInfo.swift
// 11.06.2024.
//

extension Reply.Mail {
    struct ContactInfoDTO: Codable {
        let contactMail: String?
        let elapsedTime: Int?
        let meta: ContactMetaDTO?
        let reqId: String?
        let status: String?
        let version: String?
        
        enum CodingKeys: String, CodingKey {
            case contactMail = "contact_mail"
            case elapsedTime = "elapsed_time"
            case meta
            case reqId = "req_id"
            case status
            case version
        }
    }
    
    struct ContactMetaDTO: Codable {
        let avatar: String?
        let cn: String?
        let email: String?
        let fname: String?
        let iin: String?
        let phone: String?
        let sname: String?
        let ssn: String?
        let subject: String?
        let uid: String?
        let xsn: String?
    }
}
