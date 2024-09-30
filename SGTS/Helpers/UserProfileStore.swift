//
//  UserProfileStore.swift
// 20.06.2024.
//

import Foundation

protocol UserProfileStoreProtocol {
    func save(certificate: Certificates)
    func saveAccessToken(token: String)
    func saveExpireTime(time: String)
    func getAccessToken() -> String
    func getExpireTime() -> String
    func getUserIIN() -> String
    func saveSignature(text: String)
    func getSignature() -> String
}

// Storing user profile informations and access token
struct UserProfileStore: UserProfileStoreProtocol {
    static let shared: UserProfileStore = UserProfileStore()

    private enum Constants {
        static let ACCESS_TOKEN = "SGTSkAccessToken"
        static let TOKEN_EXPIRE_TIME = "SGTSkTokenExpirationTime"
        static let STORED_DELETED_MAILS = "kStoredDeletedMails"
        static let SIGNATURE = "kSignature"
        static let USER_IIN_STRING = "kIIN"
    }
    
    fileprivate let userDefault: UserDefaults = .standard
    fileprivate var certificates: Certificates?
    
    func save(certificate: Certificates) {
        
    }
    
    // MARK: - saving access token to UserDefaults
    func saveAccessToken(token: String) {
        let _ = KeychainService.set(token, forKey: Constants.ACCESS_TOKEN)
    }
    
    // MARK: - saving expiration time of access token to UserDefaults
    func saveExpireTime(time: String) {
        userDefault.set(time, forKey: Constants.TOKEN_EXPIRE_TIME)
    }
    
    // MARK: - get a current access token (if it's necessary)
    func getAccessToken() -> String {
        guard let token = KeychainService.get(forKey: Constants.ACCESS_TOKEN) else { return "" }
        if !token.isEmpty {
            return token
        }
        return ""
    }
    
    // MARK: - get a token expiration time (if it's necessary)
    func getExpireTime() -> String {
        guard let time = userDefault.string(forKey: Constants.TOKEN_EXPIRE_TIME) else { return "" }
        if !time.isEmpty {
            return time
        }
        return ""
    }
    
    // MARK: - get an user IIN
    func getUserIIN() -> String {
        guard let userIIN = userDefault.string(forKey: Constants.USER_IIN_STRING) else { return "" }
        if !userIIN.isEmpty {
            return userIIN
        }
        return ""
    }
    
    func saveSignature(text: String) {
        if let oldText = userDefault.string(forKey: Constants.SIGNATURE) {
            if oldText != text {
                userDefault.set(text, forKey: Constants.SIGNATURE)
            }
        } else {
            userDefault.set(text, forKey: Constants.SIGNATURE)
        }
    }
    
    func getSignature() -> String {
        guard let text = userDefault.string(forKey: Constants.SIGNATURE) else { return "" }
        if !text.isEmpty {
            return text
        }
        return ""
    }
}
