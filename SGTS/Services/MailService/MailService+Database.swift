//
//  MailService+Database.swift
// 30.07.2024.
//

import Foundation

extension MailService {
    
    // Методы для работы с папками
    func createFolder(name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Log.i("Creating folder: \(name)")
        subdStorage.createFolder(name: name, completion: completion)
    }

    func getAllFolders(completion: @escaping (Result<[FolderData], Error>) -> Void) {
        Log.i("Fetching all folders")
        subdStorage.getAllFolders(completion: completion)
    }

    func deleteFolder(_ folderName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Log.i("Deleting folder: \(folderName)")
        subdStorage.deleteFolder(folderName, completion: completion)
    }

    func clearFolder(_ folderName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Log.i("Clearing folder: \(folderName)")
        subdStorage.clearFolder(folderName, completion: completion)
    }

    // Методы для работы с письмами
    
    func getAllEmailIDs(completion: @escaping (Result<[String], Error>) -> Void) {
        subdStorage.getAllEmailIDs(completion: completion)
    }
    
    func updateIsRead(id: String, isRead: Bool, folder: MailFolder, completion: @escaping (Result<EmailMessageModel, Error>) -> Void) {
        subdStorage.updateIsRead(id: id,
                                 isRead: isRead,
                                 completion: { [weak self] result in
            switch result {
                case .success(let success):
                    Log.i("updateIsRead updated mail: \(success)")
                    self?.setEmailState(mailUid: id,
                                        status: .read,
                                        folder: folder,
                                        completion: {})
                    completion(.success(EmailMessageModel(dto: success)))
                case .failure(let failure):
                    Log.e("updateIsRead error: \(failure.localizedDescription)")
                    completion(.failure(failure))
            }
        })
    }
    
    func addMail(_ mailData: EmailMessageModel, toFolder folderName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Log.i("Adding mail to folder: \(folderName)")
        subdStorage.addEmail(EmailMessage(model: mailData), toFolder: folderName, completion: completion)
    }

    func getAllMails(page: Int, pageSize: Int, completion: @escaping (Result<[EmailMessageModel], Error>) -> Void) {
        Log.i("Fetching all mails, page: \(page), pageSize: \(pageSize)")
        subdStorage.getAllEmails(page: page, pageSize: pageSize) { result in
            switch result {
            case .success(let emailsData):
                let emails = emailsData.map { EmailMessageModel(dto: $0) }
                completion(.success(emails))
            case .failure(let error):
                Log.e("Error fetching all mails: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func getAllStoredEmails(completion: @escaping (Result<[EmailMessageModel], Error>) -> Void) {
        Log.i("Fetching all emails")
        subdStorage.getAllEmails { result in
            switch result {
            case .success(let emailsData):
                let emails = emailsData.map { EmailMessageModel(dto: $0) }
                completion(.success(emails))
            case .failure(let error):
                Log.e("Error fetching all emails: \(error)")
                completion(.failure(error))
            }
        }
    }

    func getAllStoredEmailsFromFolder(_ folderName: String, completion: @escaping (Result<[EmailMessageModel], Error>) -> Void) {
        Log.i("Fetching all emails from folder: \(folderName)")
        subdStorage.getAllEmailsFromFolder(folderName) { result in
            switch result {
            case .success(let emailsData):
                let emails = emailsData.map { EmailMessageModel(dto: $0) }
                completion(.success(emails))
            case .failure(let error):
                Log.e("Error fetching all emails: \(error)")
                completion(.failure(error))
            }
        }
    }

    func getTotalEmailCount(completion: @escaping (Result<(total: Int, unread: Int), Error>) -> Void) {
        subdStorage.getTotalEmailCount(completion: { result in
            switch result {
                case .success(let success):
                    Log.i("getTotalEmailCount count: \(success)")
                    completion(.success(success))
                case .failure(let failure):
                    Log.e("getTotalEmailCount error: \(failure.localizedDescription)")
                    completion(.failure(failure))
            }
        })
    }

    func getMailsCountFrom(_ folderName: String, completion: @escaping (Result<(total: Int, unread: Int?), Error>) -> Void) {
        Log.i("Fetching all emails from folder: \(folderName)")
        subdStorage.getMailsCountFrom(folderName) { result in
            switch result {
            case .success(let success):
                Log.e("Successfully fetched mailsCount for folder: \(folderName)")
                completion(.success(success))
            case .failure(let failure):
                Log.e("Error fetching mailsCount for folder: \(folderName), error: \(failure)")
                completion(.failure(failure))
            }
        }
    }

    func getMails(fromFolder folderName: String, page: Int, pageSize: Int, completion: @escaping (Result<[EmailMessageModel], Error>) -> Void) {
        Log.i("Fetching mails from folder: \(folderName), page: \(page), pageSize: \(pageSize)")
        subdStorage.getEmails(fromFolder: folderName, page: page, pageSize: pageSize) { result in
            switch result {
            case .success(let emailsData):
                let emails = emailsData.map { EmailMessageModel(dto: $0) }
                completion(.success(emails))
            case .failure(let error):
                Log.e("Error fetching mails from folder: \(folderName), error: \(error)")
                completion(.failure(error))
            }
        }
    }

    func getMail(byUIDL uidl: String, completion: @escaping (Result<EmailMessageModel, Error>) -> Void) {
        Log.i("Fetching mail by UIDL: \(uidl)")
        subdStorage.getEmail(byUIDL: uidl) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let mail):
                let emailModel = EmailMessageModel(dto: mail)
                self.loadAttachmentsContent(for: emailModel) { result in
                    switch result {
                    case .success(let modelWithFiles):
                        DispatchQueue.main.async {
                            Log.i("Successfully loaded attachments content for mail UIDL: \(uidl)")
                            completion(.success(modelWithFiles))
                        }
                    case .failure(let error):
                        Log.e("Error loading attachments content for mail UIDL: \(uidl), error: \(error)")
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                }
                completion(.success(emailModel))
            case .failure(let error):
                Log.e("Error fetching mail by UIDL: \(uidl), error: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    func deleteMail(_ mailUIDL: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Log.i("Deleting mail by UIDL: \(mailUIDL)")
        subdStorage.deleteEmail(mailUIDL, completion: completion)
    }

    func moveMail(_ mailUIDL: String, toFolder folderName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Log.i("Moving mail UIDL: \(mailUIDL) to folder: \(folderName)")
        subdStorage.moveEmail(mailUIDL, toFolder: folderName, completion: completion)
    }
}
