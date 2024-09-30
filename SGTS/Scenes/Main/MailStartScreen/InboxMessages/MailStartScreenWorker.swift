//
//  MailStartScreenWorker.swift
//  SGTS
//
//  Created by Roman Vakulenko on 17.04.2024.
//

import Foundation

protocol TableOfEmailsLogic {
    var mailManager: EmailManagerProtocol { get }
    var pageNumber: Int { get }
    var totalMessages: Int { get }
    var isAllMailsFetched: Bool { get }
}

protocol MailStartScreenWorkingLogic: TableOfEmailsLogic {
    func getData(isAtPulltoRefresh: Bool,
                 completion: @escaping (Result<(Int, Int, [EmailMessageModel]), MailStartScreenModel.Errors>) -> Void)
    func getAllStoredEmailsFromFolder(_ folderName: String, completion: @escaping (Result<[EmailMessageModel], MailStartScreenModel.Errors>) -> Void)
    func updateIsRead(id: String, isRead: Bool, completion: @escaping (Result<EmailMessageModel, Error>) -> Void)
}


// MARK: - MailStartScreenWorker

final class MailStartScreenWorker: MailStartScreenWorkingLogic {

    enum Constants {
        static let amountOfMailsAtPage = 10
    }

    // MARK: - Public properties

    var isAllMailsFetched = false
    let mailManager = DIManager.shared.container.resolve(EmailManagerProtocol.self)!
    var pageNumber = 0
    var totalMessages = 0

    // MARK: - Private properties
    private var allInboxEmails = [EmailMessageModel]()
    private var unread = 0

    // MARK: - Public methods

    func getAllStoredEmailsFromFolder(_ folderName: String, completion: @escaping (Result<[EmailMessageModel], MailStartScreenModel.Errors>) -> Void) {

        mailManager.getAllStoredEmailsFromFolder(folderName) { result in
            switch result {
            case .success(let emailMessages):
                completion(.success(emailMessages))
            case .failure(_):
                completion(.failure(.cantFetchMails))
            }
        }
    }

    func updateIsRead(id: String, isRead: Bool, completion: @escaping (Result<EmailMessageModel, Error>) -> Void) {
        mailManager.updateIsRead(id: id,
                                 isRead: isRead,
                                 folder: .input,
                                 completion: completion)
    }
    
    func getData(isAtPulltoRefresh: Bool,
                 completion: @escaping (Result<(Int, Int, [EmailMessageModel]), MailStartScreenModel.Errors>) -> Void) {

        if isAtPulltoRefresh {
            pageNumber = 0
            allInboxEmails = []
            isAllMailsFetched = false
        }
        
        if isAllMailsFetched {
            completion(.success((unread, totalMessages, allInboxEmails)))
        } else  {
            mailManager.getTotalEmailCount { [weak self] result in
                guard let self else {return}
                switch result {
                case .success(let amountOf):
                    unread = amountOf.unread
                    totalMessages = amountOf.total
                    completion(.success( (unread, totalMessages, [EmailMessageModel]()) ))
                case .failure(_):
                    completion(.failure(.cantFetchMails))
                }
            }

            mailManager.getMails(fromFolder: GlobalConstants.inboxEmails, page: pageNumber, pageSize: Constants.amountOfMailsAtPage) { [weak self] result in
                guard let self else {return}
                switch result {
                case .success(let emailMessages):
                    isAllMailsFetched = emailMessages.count < Constants.amountOfMailsAtPage
                    pageNumber += 1
                    allInboxEmails.append(contentsOf: emailMessages.compactMap { oneEmailMessage in
                        return oneEmailMessage
                    })
                    completion(.success((unread, totalMessages, allInboxEmails)))

                case .failure(_):
                    completion(.failure(.cantFetchMails))
                }
            }
        }
    }
}
