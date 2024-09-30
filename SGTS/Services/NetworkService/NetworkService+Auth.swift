//
//  NetworkService+Auth.swift
// 11.07.2024.
//

import Alamofire
import Foundation

protocol AuthNetworkServicing {
    func getCertificates(completion: @escaping (Result<Reply.Auth.CertificatesDTO, Error>) -> Void)
    func getToken(bodyText: String, completion: @escaping (Result<Reply.Auth.TokenResponse, Error>) -> Void)
}

extension NetworkService: AuthNetworkServicing {
    private enum EndpointName {
        static let getCertificates = "/somehost/restapi/auth/certs"
        static let getToken = "/somehost/restapi/auth/token"
    }

    func getCertificates(completion: @escaping (Result<Reply.Auth.CertificatesDTO, Error>) -> Void) {

    }

    func getToken(bodyText: String, completion: @escaping (Result<Reply.Auth.TokenResponse, Error>) -> Void) {
 
    }
}
