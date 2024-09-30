//
//  NetworkManager+Auth.swift
// 11.07.2024.
//

import Foundation

protocol AuthNetworkManaging: AnyObject {
    func requestCertificates(completion: @escaping (Result<Reply.Auth.CertificatesDTO, Error>) -> Void)
    func requestToken(bodyText: String, completion: @escaping (Result<Reply.Auth.TokenResponse, Error>) -> Void)
}

extension NetworkManager: AuthNetworkManaging {
    func requestCertificates(completion: @escaping (Result<Reply.Auth.CertificatesDTO, Error>) -> Void) {
        networkService.getCertificates(completion: completion)
    }
    
    func requestToken(bodyText: String, completion: @escaping (Result<Reply.Auth.TokenResponse, Error>) -> Void) {
        networkService.getToken(bodyText: bodyText, completion: completion)
    }
}
