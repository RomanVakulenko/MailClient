//
//  SideMenuWorker.swift
//  SGTS
//
//  Created by Roman Vakulenko on 03.07.2024.
//

import Foundation

protocol SideMenuEmailsCountLogic {
    var mailManager: EmailManagerProtocol { get }
    var totalMessages: String { get }
    var isAllMailsFetched: Bool { get }
}

protocol SideMenuWorkingLogic: SideMenuEmailsCountLogic {
    func getTotalEmailCount(completion: @escaping (Result<(unread: String, total: String), MailStartScreenModel.Errors>) -> Void)
    func getMailsCountFor(folderName: String,
                          completion: @escaping (Result<(unread: String, total: String), MailStartScreenModel.Errors>) -> Void)
}


final class SideMenuWorker: SideMenuWorkingLogic {
    
    // MARK: - Public properties
    
    var isAllMailsFetched = false
    let mailManager = DIManager.shared.container.resolve(EmailManagerProtocol.self)!
    var totalMessages = ""

    // MARK: - Private properties
    private var unread = ""

    // MARK: - Public methods
    func getTotalEmailCount(completion: @escaping (Result<(unread: String, total: String), MailStartScreenModel.Errors>) -> Void) {

        mailManager.getTotalEmailCount { [weak self] result in
            guard let self else {return}
            switch result {
            case .success(let amountOf):
                unread = String(amountOf.unread)
                totalMessages =  String(amountOf.total)
                completion(.success((unread, totalMessages)))
                
            case .failure(_):
                completion(.failure(.cantFetchMails))
            }
        }
    }

    func getMailsCountFor(folderName: String, 
                          completion: @escaping (Result<(unread: String, total: String), MailStartScreenModel.Errors>) -> Void) {

        mailManager.getMailsCountFrom (folderName) { [weak self] result in
            guard let self else {return}

            switch result {
            case .success(let amountOf):
                unread = String(amountOf.unread ?? 0)
                totalMessages =  String(amountOf.total)
                completion(.success((unread, totalMessages)))
                isAllMailsFetched = true
            case .failure(_):
                completion(.failure(.cantFetchMails))
            }
        }
    }
}
