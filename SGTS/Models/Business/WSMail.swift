//
//  WSMail.swift
// 03.08.2024.
//

struct WSMailPayload: Codable {
    let uidl: String
    let status: String
    let folder: String
}

struct WSMail: Decodable {
    let cuid: String
    let type: String
    let folder: String
    let payload: WSMailPayload
}
