//
//  GetMailListRequestDTO.swift
// 03.06.2024.
//

extension Request.Auth {
    struct GetMailListRequestDTO: Encodable {
        let folder_name: String
        let from_time: String
        let direction: String
    }
}
