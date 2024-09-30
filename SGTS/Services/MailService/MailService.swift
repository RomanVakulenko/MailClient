//
//  MailService.swift
// 11.07.2024.
//

import Foundation

class MailService: MailServiceProtocol {
    static let shared: MailServiceProtocol = MailService()
    private init() {}
    let network = DIManager.shared.container.resolve(NetworkManaging.self)!
    let storage = DIManager.shared.container.resolve(StorageProtocol.self)!
    let cryptoLayer = DIManager.shared.container.resolve(CryptoLayerProtocol.self)!
    let userProfileStorage = DIManager.shared.container.resolve(UserProfileStoreProtocol.self)!
    let subdStorage = DIManager.shared.container.resolve(MailDatabaseProtocol.self)!
    let fileService = DIManager.shared.container.resolve(FileServiceProtocol.self)!
    
    func fetchEmail(uidl: String, folder: MailFolder, completion: @escaping (EmailMessageModel?) -> Void) {
        fetchEmail(mailUidl: uidl,
                   folder: folder) { emailMessage in
            if let emailMessage = emailMessage {
                completion(EmailMessageModel(dto: emailMessage))
            } else {
                completion(nil)
            }
        }
    }
   
    internal func fetchEmail(mailUidl: String, folder: MailFolder = .input, completion: @escaping (EmailMessage?) -> Void) {
        guard (storage.loadToken()) != nil else { return }

        fetchEmailInfoBy(uidl: mailUidl,
                         folder: folder,
                         completion: { [weak self] result in
            switch result {
            case .success(let mailInfo):
                self?.fetchEmailFileAndParse(mailInfo: mailInfo,
                                             completion: { [weak self] emailMessage in
                    if emailMessage != nil {
                        self?.setEmailState(mailUid: mailUidl,
                                            status: .received,
                                            folder: folder) {}
                    }
                    completion(emailMessage)
                })
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        })
    }
    
    private func fetchEmailFileAndParse(mailInfo: MailDTO, completion: @escaping (EmailMessage?) -> Void) {
            fetchPrivateEmail(source: mailInfo) { [weak self] data in
                guard let self = self else {
                    completion(nil)
                    return
                }
                if let data = data,
                   let message = self.parseEml(uidl: mailInfo.mailUidl,
                                               emlData: data,
                                               mail: mailInfo) {
                    completion(message)
                } else {
                    completion(nil)
                }
            }
    }
    
    func fetchNewEmails(createsIds: [String], completion: @escaping ([EmailMessage]) -> Void) {
        guard let token = storage.loadToken() else { return }
        let folder: MailFolder = .input
        getLetterList(token: token,
                      folder: folder.rawValue,
                      fromDate: Date()) {  [weak self] result in
            switch result {
            case .success(let response):
                self?.fetchAndParseEmails(createsIds: createsIds,
                                          source: response,
                                          completion: { [weak self] emails in
                    emails.forEach { email in
                        self?.setEmailState(mailUid: email.id,
                                            status: .received,
                                            folder: folder) {}
                    }
                    completion(emails)
                })
            case .failure(let error):
                print(error.localizedDescription)
                completion([])
            }
        }
    }
    
    // Вспомогательная функция для получения минимальной даты из списка писем
    private func getMinDate(from mails: [MailDTO]) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss'UTC'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        let dates = mails.compactMap { mail -> Date? in
            guard let timestamp = mail.mailHistory?.first(where: { $0.action == "new" })?.timestamp else { return nil }
            return dateFormatter.date(from: timestamp)
        }
        return dates.min()
    }

    // Основная рекурсивная функция для получения всех писем
    private func getLetterList(token: String, folder: String, fromDate: Date?, accumulatedMails: [MailDTO] = [], completion: @escaping (Result<[MailDTO], Error>) -> Void) {
        
        let fromTime = fromDate != nil ? formatDateToCustomUTCString(fromDate!) : formatDateToCustomUTCString(Date())
        let parameters = Request.Auth.GetMailListRequestDTO(folder_name: folder, from_time: fromTime, direction: "down")
        
        network.getLettersList(token: token, parameters: parameters, completion: { result in
            switch result {
            case .success(let response):
                let newMails = response.mail
                let allMails = accumulatedMails + newMails
                    completion(.success(allMails))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    private func fetchAndParseEmails(createsIds: [String], source: [MailDTO], completion: @escaping ([EmailMessage]) -> Void) {
        let group = DispatchGroup()
        var messages: [EmailMessage] = []
        
        for mail in source {
            if !createsIds.contains(mail.mailUidl) {
                group.enter()
                fetchPrivateEmail(source: mail) { [weak self] data in
                    defer { group.leave() }
                    if let data = data,
                       let message = self?.parseEml(uidl: mail.mailUidl,
                                                    emlData: data,
                                                    mail: mail) {
                        messages.append(message)
                    }
                }
            } else {}
        }
        group.notify(queue: .main) {
            completion(messages)
        }
    }

    internal func setEmailState(mailUid: String, status: MailStatus, folder: MailFolder, completion: @escaping () -> Void) {
        completion()
    }

    private func formatDateToCustomUTCString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss'UTC'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: date)
    }
}
