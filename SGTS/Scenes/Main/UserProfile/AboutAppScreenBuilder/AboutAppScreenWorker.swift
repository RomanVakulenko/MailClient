//
//  AboutAppScreenWorker.swift
//  SGTS
//
//  Created by Roman Vakulenko on 24.06.2024.
//

import Foundation

protocol AboutAppScreenWorkingLogic {
    func getData(completion: @escaping (Result<Data, Error>) -> Void) 
}


final class AboutAppScreenWorker: AboutAppScreenWorkingLogic {
    private let network: NetworkManaging = NetworkManager()

    func getData(completion: @escaping (Result<Data, Error>) -> Void) {

    }
}
