//
//  SecretStorageProtocol.swift
// 24.07.2024.
//

protocol SecretStorageProtocol {
    var authWithBrowserLink: String { get }
    var appID: String { get }
    var deepLinkSheme: String { get }
    var deepLinkHost: String { get }
    var applicationInstance: String { get }
    var clientIdFromBrowserAuth: String { get }
    var clientSecret: String { get }
    var clientStateFromBrowserAuth: String { get }
    var baseURLString: String { get }
    var serverTrustManagerEvaluators: String { get }
    var keyFromApiRequest: String { get }
}
