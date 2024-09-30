//
//  NetworkManager.swift
// 01.04.2024.
//

protocol NetworkManaging : AuthNetworkManaging,
                           MailNetworkManaging {}

class NetworkManager : NetworkManaging {
    let networkService: NetworkServicing = NetworkService()
    
    init() {}
}
