//
//  GetTokenDTORequest.swift
// 31.05.2024.
//

extension Reply.Auth {
    struct TokenResponse: Decodable {
        let accessToken: String
        let expiresIn: String
        let expiryTime: String
        let status: String?
        let tokenType: String?
        let tokenVersion: String?
        let ucReset: String?
        let version: String?

        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case expiresIn = "expires_in"
            case expiryTime = "expiry_time"
            case status = "status"
            case tokenType = "token_type"
            case tokenVersion = "token_version"
            case ucReset = "uc_reset"
            case version = "version"
        }
    }
}
