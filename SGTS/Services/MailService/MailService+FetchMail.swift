//
//  MailService+FetchMail.swift
// 30.07.2024.
//

import Foundation

extension MailService {
    func fetchEmailInfoBy(uidl: String, folder: MailFolder, completion: @escaping (Result<MailDTO, Error>) -> Void) {
        guard let token = storage.loadToken()
        else {
            Log.e("Failed to load token")
            completion(.failure(NSError(domain: "Token not found",
                                        code: 0,
                                        userInfo: nil)))
            return
        }
        network.getMailInfoById(token: token,
                                uidl: uidl,
                                folder: folder.rawValue,
                                completion: { result in
            switch result {
            case .success(let mailInfo):
                if let mailMeta = mailInfo.mailMeta {
                    completion(.success(mailMeta))
                } else {
                    completion(.failure(NSError(domain: "Failed to fetch email info",
                                                code: 0,
                                                userInfo: nil)))
                }
            case .failure(let error):
                Log.e(error.localizedDescription)
                completion(.failure(error))
            }
        })
    }
    
    private func addMail(_ mailData: EmailMessage, toFolder folderName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Log.i("Adding mail to folder: \(folderName)")
        subdStorage.addEmail(mailData,
                             toFolder: folderName,
                             completion: completion)
    }
    
    func fetchAllEMails(completion: @escaping (Result<Void, Error>) -> Void) {
        Log.i("Fetching all emails")
        Log.i("Development environment detected, skipping email fetch")
        completion(.success(Void()))
    }
    
    private func getAllEMails(completion: @escaping (Result<Void, Error>) -> Void) {
        let group = DispatchGroup()
        var errorCollector: Error?
        
        group.enter()
        subdStorage.getAllEmailIDs { [weak self] resultIds in
            defer { group.leave() }
            switch resultIds {
            case .success(let ids):
                Log.i("Fetched email IDs: \(ids.count)")
                group.enter()
                self?.fetchNewEmails(createsIds: ids) { messages in
                    defer { group.leave() }
                    Log.i("Fetched new emails: \(messages.count)")
                    messages.forEach { message in
                        group.enter()
                        self?.addMail(message, toFolder: GlobalConstants.inboxEmails, completion: { result in
                            defer { group.leave() }
                            switch result {
                            case .success:
                                Log.i("Email added to folder successfully")
                            case .failure(let error):
                                Log.e("Failed to add email to folder: \(error.localizedDescription)")
                                errorCollector = error
                            }
                        })
                    }
                }
            case .failure(let error):
                Log.e("Failed to fetch email IDs: \(error.localizedDescription)")
                errorCollector = error
            }
        }
        
        group.notify(queue: .main) {
            if let error = errorCollector {
                completion(.failure(error))
            } else {
                completion(.success(Void()))
            }
        }
    }
    
    
    
    
    
    
    
    
}
