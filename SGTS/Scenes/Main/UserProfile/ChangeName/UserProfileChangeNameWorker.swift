//
//  UserProfileChangeNameWorker.swift
//  SGTS
//
//  Created by Roman Vakulenko on 24.06.2024.
//

import Foundation

protocol UserProfileChangeNameWorkingLogic {
    func getData(completion: @escaping (Result<Data, Error>) -> Void) 
}


final class UserProfileChangeNameWorker: UserProfileChangeNameWorkingLogic {
    private let network: NetworkManaging = NetworkManager()

    func getData(completion: @escaping (Result<Data, Error>) -> Void) {

    }

}
