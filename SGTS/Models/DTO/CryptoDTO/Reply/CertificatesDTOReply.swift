//
//  getCertificatesDTOReply.swift
// 23.05.2024.
//


extension Reply.Auth {
    struct CertificatesDTO: Decodable {
        let version: String
        let status: String
        let cert_sign: String
        let cert_xchg: String
    }
}
