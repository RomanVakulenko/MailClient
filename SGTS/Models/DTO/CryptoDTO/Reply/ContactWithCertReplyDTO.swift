//
//  ContactWithCertReplyDTO.swift
// 18.06.2024.
//
import Foundation

extension Reply.Mail {
    struct ContactWithCert: Codable {
        let contact: ContactDTO?
        let elapsedTime: Int?
        let reqId: String?
        let status: String?
        let version: String?
        
        enum CodingKeys: String, CodingKey {
            case contact
            case elapsedTime = "elapsed_time"
            case reqId = "req_id"
            case status
            case version
        }
    }
    
    struct UserMetaData: Codable {
        let iin: String?
        let uid: String?
        let subject: String?
        let cn: String?
        let fname: String?
        let sname: String?
        let email: String?
        let phone: String?
        let ssn: String?
        let xsn: String?
        let avatar: String?
    }

    struct ContactDTO: Codable {
        let contactGroup: String?
        let contactMessage: String?
        let contactStatus: String?
        let userCreatedDate: String?
        let userFname: String?
        let userMetaData: UserMetaData?
        let userSignCertPem: String?
        let userSname: String?
        let userUid: String?
        let userXchgCertPem: String?
        
        enum CodingKeys: String, CodingKey {
            case contactGroup = "contact_group"
            case contactMessage = "contact_message"
            case contactStatus = "contact_status"
            case userCreatedDate = "user_created_date"
            case userFname = "user_fname"
            case userMetaData = "user_meta_data"
            case userSignCertPem = "user_sign_cert_pem"
            case userSname = "user_sname"
            case userUid = "user_uid"
            case userXchgCertPem = "user_xchg_cert_pem"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.contactGroup = try container.decodeIfPresent(String.self, forKey: .contactGroup)
            self.contactMessage = try container.decodeIfPresent(String.self, forKey: .contactMessage)
            self.contactStatus = try container.decodeIfPresent(String.self, forKey: .contactStatus)
            self.userCreatedDate = try container.decodeIfPresent(String.self, forKey: .userCreatedDate)
            self.userFname = try container.decodeIfPresent(String.self, forKey: .userFname)
            
            let userMetaDataString = try container.decodeIfPresent(String.self, forKey: .userMetaData)
            if let userMetaDataString = userMetaDataString, let userMetaDataData = userMetaDataString.data(using: .utf8) {
                self.userMetaData = try JSONDecoder().decode(UserMetaData.self, from: userMetaDataData)
            } else {
                self.userMetaData = nil
            }
            
            self.userSignCertPem = try container.decodeIfPresent(String.self, forKey: .userSignCertPem)
            self.userSname = try container.decodeIfPresent(String.self, forKey: .userSname)
            self.userUid = try container.decodeIfPresent(String.self, forKey: .userUid)
            self.userXchgCertPem = try container.decodeIfPresent(String.self, forKey: .userXchgCertPem)
        }
    }
}
