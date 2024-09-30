//
//  MovePickedEmailsWorker.swift
//  SGTS
//
//  Created by Roman Vakulenko on 24.05.2024.
//

import Foundation

protocol MovePickedEmailsWorkingLogic {
    func getData(completion: @escaping (Result<Data, Error>) -> Void) 
}


final class MovePickedEmailsWorker: MovePickedEmailsWorkingLogic {
    private let network: NetworkManaging = NetworkManager()
    
    func getData(completion: @escaping (Result<Data, Error>) -> Void) {
        
    }
}
