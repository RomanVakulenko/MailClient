//
//  MockSecretStorage.swift
// 24.07.2024.
//

class MockSecretStorage: SecretStorageProtocol {
    static let shared = MockSecretStorage()
    private init() {}
    
    let authWithBrowserLink = "ya.ru"
    let appID = "516189492959"
    let deepLinkSheme = "iosSGTSApp"
    let deepLinkHost = "sgtsBrowserAuth"
    let applicationInstance = "applicationInstance"
    let clientIdFromBrowserAuth = "clientIdFromBrowserAuth"
    let clientSecret = "SecterSecretSecret"
    let clientStateFromBrowserAuth = "clientStateFromBrowserAuth"
    let baseURLString = "https://ya.ru"
    let serverTrustManagerEvaluators = "ya.ru"
    let keyFromApiRequest = "keyFromApiRequest"
}
