//
//  UserProfileWorker.swift
//  SGTS
//
//  Created by Roman Vakulenko on 16.06.2024.
//

import Foundation

protocol UserProfileWorkingLogic {
    func getUserDataAt(url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}


final class UserProfileWorker: UserProfileWorkingLogic {

    // MARK: - Private properties
    private let network: NetworkManaging = NetworkManager()
    private let concurrentQueue = DispatchQueue(label: "com.SGTS.fileQueue", attributes: .concurrent)

    // MARK: - Public methods
    func getUserDataAt(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
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

}
