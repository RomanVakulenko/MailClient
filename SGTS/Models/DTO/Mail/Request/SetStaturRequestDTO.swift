//
//  SetStaturRequestDTO.swift
// 01.08.2024.
//

extension Request.Mail {
    struct SetStaturRequestDTO: Encodable {
        let mail_uid: String
        let mail_status: String
        let folder_name: String
    }
}
