//
//  DataWithAdditionalInfoReplyDTO.swift
// 12.06.2024.
//

import Foundation
extension Reply.Mail {
    struct DataWithCertsDTO: Codable {
        let data: Data
        let certsDTO: CertsDTO
    }
    
    struct CertsDTO: Codable {
        let certsIsRevoked: Bool?
        let fileInfo: FileInfoDTO?
        let status: String?
        
        enum CodingKeys: String, CodingKey {
            case certsIsRevoked = "certs_is_revoked"
            case fileInfo = "file_info"
            case status
        }
    }
    
    struct RecipientDTO: Codable {
        let dn: String?
        let skey: String?
        let time: String?
        let uid: String?
        let xsn: String?
    }
    
    struct SenderDTO: Codable {
        let dn: String?
        let skey: String?
        let ssn: String?
        let uid: String?
        let xsn: String?
    }
    
    struct FileMetaDTO: Codable {
        let encryptedHash: String?
        let encryptedSize: String?
        let hash: String?
        let provider: String?
        let sign: String?
        let time: String?
        let type: String?
        
        enum CodingKeys: String, CodingKey {
            case encryptedHash = "encrypted_hash"
            case encryptedSize = "encrypted_size"
            case hash
            case provider
            case sign
            case time
            case type
        }
    }
    
    struct FileInfoDetailsDTO: Codable {
        let comment: String?
        let name: String?
        let size: String?
    }
    
    struct FileInfoDTO: Codable {
        let fileInfo: FileInfoDetailsDTO?
        let meta: FileMetaDTO?
        let recipients: [RecipientDTO]?
        let sender: SenderDTO?
        
        enum CodingKeys: String, CodingKey {
            case fileInfo = "file_info"
            case meta
            case recipients
            case sender
        }
    }
}
