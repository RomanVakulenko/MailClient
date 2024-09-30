//
//
//  SecretKeySelectorWorker.swift
//  SGTS
//
//  Created by Roman Vakulenko on 12.04.2024.
//

import Foundation
import UIKit

protocol SecretKeySelectorWorkingLogic {
    func openFile(url: URL, completion: @escaping (Result<Data, Error>) -> Void)
    func getCertificates(completion: @escaping (Result<Certificates, Error>) -> Void)
    func authenticateWithBrowser(clientId: String, state: String, redirectURI: String, scope: String, completion: @escaping (Result<Void, Error>) -> Void)
}

final class SecretKeySelectorWorker: SecretKeySelectorWorkingLogic {

    // MARK: - Private properties

    private let network = DIManager.shared.container.resolve(NetworkManaging.self)!
    private let concurrentQueue = DispatchQueue(label: "ru.SecretKeySelectorFileQueue", attributes: .concurrent)
    private let secretStorage = DIManager.shared.container.resolve(SecretStorageProtocol.self)!

    // MARK: - Public methods

    func openFile(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        concurrentQueue.async {
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    func getCertificates(completion: @escaping (Result<Certificates, Error>) -> Void) {
        network.requestCertificates { result in
            switch result {
            case .success(let dto):
                completion(.success(Certificates(dto: dto)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func authenticateWithBrowser(clientId: String, state: String, redirectURI: String, scope: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let urlString = secretStorage.authWithBrowserLink
        
        if let url = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                completion(.success(Void()))
            } else {
                print("Cannot open URL")
                completion(.failure(Error.self as! Error))
            }
        }
    }
}
