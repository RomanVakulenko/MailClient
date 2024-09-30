//
//  ArchivedWorker.swift
//  SGTS
//
//  Created by Roman Vakulenko on 11.07.2024.
//

import Foundation

protocol ArchivedWorkingLogic: TableOfEmailsLogic {
    func getAllStoredEmailsFromFolder(_ folderName: String, completion: @escaping (Result<[EmailMessageModel], MailStartScreenModel.Errors>) -> Void)
}


final class ArchivedWorker: ArchivedWorkingLogic {

    enum Constants {
        static let amountOfMailsAtPage = 10
    }

    // MARK: - Public properties

    var isAllMailsFetched = false
    let mailManager = DIManager.shared.container.resolve(EmailManagerProtocol.self)!
    var pageNumber = 0
    var totalMessages = 0

    // MARK: - Public methods

    func getAllStoredEmailsFromFolder(_ folderName: String, completion: @escaping (Result<[EmailMessageModel], MailStartScreenModel.Errors>) -> Void) {

        mailManager.getAllStoredEmailsFromFolder(folderName) { [weak self] result in
            guard let self else {return}

            switch result {
            case .success(let emailMessages):
                completion(.success(emailMessages))
                isAllMailsFetched = true
            case .failure(_):
                completion(.failure(.cantFetchMails))
            }
        }
    }
}
