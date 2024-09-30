//
//  FileModel.swift
//  28.04.2023.
//

import Foundation

struct FileInfoResult {
    let fileInfo: FileInfoItem
}

extension FileInfoResult: Codable {
    enum CodingKeys: String, CodingKey {
        case fileInfo = "file"

    }
}

struct FileInfoItem {
    let fileInfo: FileInfo
    let meta: FileMeta
    let recipients: [Recipient]
    let sender: Sender
}

extension FileInfoItem: Codable {
    enum CodingKeys: String, CodingKey {
        case fileInfo = "file"
        case meta
        case recipients
        case sender

    }
}

struct FileInfo {
    let name: String?
    let size: String
}

extension FileInfo: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case size
    }
}

struct FileMeta {
    let encSize: String
    let encHash: String?
    let clearSize: String?
    let hash: String
    let provider: String
    let sign: String
    let time: String
    let type: String
}

extension FileMeta: Codable {
    enum CodingKeys: String, CodingKey {
        case encSize = "encrypt"
        case encHash = "hashd"
        case clearSize = "clear"
        case hash
        case provider
        case sign
        case time
        case type
    }
}

struct Recipient {
    let dn: String
    var skey: String
    let time: String
    let uid: String
    let ssn: String?
    let xsn: String
}

extension Recipient: Codable {
    enum CodingKeys: String, CodingKey {
        case dn
        case skey
        case time
        case uid
        case ssn
        case xsn
    }
}

struct Sender {
    let dn: String
    var skey: String
    let ssn: String?
    let uid: String
    let xsn: String
}

extension Sender: Codable {
    enum CodingKeys: String, CodingKey {
        case dn
        case skey
        case ssn
        case uid
        case xsn
    }
}
