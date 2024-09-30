//
//  EmailPickingScreenWorker.swift
//  SGTS
//
//  Created by Roman Vakulenko on 20.05.2024.
//

import Foundation

protocol EmailPickingScreenWorkingLogic {
    func getMail(byUIDL uidl: String, completion: @escaping (Result<EmailMessageModel, OneEmailDetailsModel.Errors>) -> Void)
    func getAllStoredEmailsFromFolder(_ folderName: String, completion: @escaping (Result<[EmailMessageModel], MailStartScreenModel.Errors>) -> Void)
    func createFolder(name: String, completion: @escaping (Result<Void, OneEmailDetailsModel.Errors>) -> Void)
    func addMail(_ mailData: EmailMessageModel, toFolder folderName: String, completion: @escaping (Result<Void, OneEmailDetailsModel.Errors>) -> Void)
    func deleteMail(_ mailUIDL: String, completion: @escaping (Result<Void, OneEmailDetailsModel.Errors>) -> Void)
    func updateIsRead(id: String, isRead: Bool, completion: @escaping (Result<EmailMessageModel, Error>) -> Void)
}


final class EmailPickingScreenWorker: EmailPickingScreenWorkingLogic {
    
    // MARK: - Private properties
    private let mailManager = DIManager.shared.container.resolve(EmailManagerProtocol.self)!

    func getMail(byUIDL uidl: String,
                 completion: @escaping (Result<EmailMessageModel, OneEmailDetailsModel.Errors>) -> Void) {

        mailManager.getMail(byUIDL: uidl) { result in
            switch result {
            case .success(let oneEmailMessage):
                completion(.success(oneEmailMessage))

            case .failure(_):
                completion(.failure(.cantFetchOneEmail))
            }
        }
    }

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

    func createFolder(name: String,
                      completion: @escaping (Result<Void, OneEmailDetailsModel.Errors>) -> Void) {
        Log.i("Creating folder: \(name)")

        mailManager.createFolder(name: name) { result in
            switch result {
            case .success():
                completion(.success(Void()))

            case .failure(_):
                completion(.failure(.errorAtCreatingFolder))
            }
        }
    }

    func addMail(_ mailData: EmailMessageModel,
                 toFolder folderName: String,
                 completion: @escaping (Result<Void, OneEmailDetailsModel.Errors>) -> Void) {

        Log.i("Adding mail to folder: \(folderName)")
        mailManager.addMail(mailData, toFolder: folderName) { result in
            switch result {
            case .success():
                completion(.success(Void()))

            case .failure(_):
                completion(.failure(.errorAtAddingToFolder))
            }
        }
    }

    func deleteMail(_ mailUIDL: String, completion: @escaping (Result<Void, OneEmailDetailsModel.Errors>) -> Void) {
        Log.i("Deleting mail by mailUIDL: \(mailUIDL)")

        mailManager.deleteMail(mailUIDL) { result in
            switch result {
            case .success():
                completion(.success(Void()))

            case .failure(_):
                completion(.failure(.errorAtDeleting))
            }
        }
    }

    func updateIsRead(id: String, isRead: Bool, completion: @escaping (Result<EmailMessageModel, Error>) -> Void) {
        mailManager.updateIsRead(id: id,
                                 isRead: isRead,
                                 folder: .input,
                                 completion: completion)
    }

}
