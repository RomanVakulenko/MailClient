//
//  ContactSearchListDTOReply.swift
// 31.07.2024.
//

extension Reply.Mail {
    
    struct ContactSearchListResponseDTO: Decodable {
        let elapsedTime: Int?
        let metes: [ContactListItemDTO]?
        let query: String?
        let reqId: String?
        let status: String?
        let version: String?
        
        enum CodingKeys: String, CodingKey {
            case elapsedTime = "elapsed_time"
            case metes
            case query
            case reqId = "req_id"
            case status
            case version
        }
    }
    
    struct ContactListItemDTO: Decodable {
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
        
        enum CodingKeys: String, CodingKey {
            case avatar
            case cn
            case email
            case fname
            case iin
            case phone
            case sname
            case ssn
            case subject
            case uid
            case xsn
        }
    }
}
