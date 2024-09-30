import Foundation

protocol EmailManagerProtocol {
    // Методы для работы с папками
    func createFolder(name: String, completion: @escaping (Result<Void, Error>) -> Void)
    func getAllFolders(completion: @escaping (Result<[FolderData], Error>) -> Void)
    func deleteFolder(_ folderName: String, completion: @escaping (Result<Void, Error>) -> Void)
    func clearFolder(_ folderName: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    // Методы для работы с письмами
    func addMail(_ mailData: EmailMessageModel, toFolder folderName: String, completion: @escaping (Result<Void, Error>) -> Void)
    func getAllMails(page: Int, pageSize: Int, completion: @escaping (Result<[EmailMessageModel], Error>) -> Void)
    func getAllStoredEmails(completion: @escaping (Result<[EmailMessageModel], Error>) -> Void)
    func getAllStoredEmailsFromFolder(_ folderName: String, completion: @escaping (Result<[EmailMessageModel], Error>) -> Void)
    func getMails(fromFolder folderName: String, page: Int, pageSize: Int, completion: @escaping (Result<[EmailMessageModel], Error>) -> Void)
    func getMail(byUIDL uidl: String, completion: @escaping (Result<EmailMessageModel, Error>) -> Void)
    func deleteMail(_ mailUIDL: String, completion: @escaping (Result<Void, Error>) -> Void)
    func moveMail(_ mailUIDL: String, toFolder folderName: String, completion: @escaping (Result<Void, Error>) -> Void)
    func getTotalEmailCount(completion: @escaping (Result<(total: Int, unread: Int), Error>) -> Void)
//    func getMailsCountFrom(_ folderName: String, completion: @escaping (Result<Int, Error>) -> Void)
    func getMailsCountFrom(_ folderName: String, completion: @escaping (Result<(total: Int, unread: Int?), Error>) -> Void)
    func updateIsRead(id: String, isRead: Bool, folder: MailFolder, completion: @escaping (Result<EmailMessageModel, Error>) -> Void)
    
    // Методы для отправки и получения писем
    func sendMail(_ mailData: EmailMessageModel, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchNewMails(completion: @escaping (Result<[EmailMessageModel], Error>) -> Void)
}

import Foundation
import CocoaLumberjack

final class MailManager: EmailManagerProtocol {
    static let shared: EmailManagerProtocol = MailManager()
    internal let mailService = DIManager.shared.container.resolve(MailServiceProtocol.self)!
    internal let userNotificationManager = DIManager.shared.container.resolve(UserNotificationManagerProtocol.self)!
    private var sentMails: [EmailMessage] = []
    
    private init() {
        subscribeToNotification()
    }

    private func subscribeToNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNewMail),
                                               name: .didReceiveWSMail,
                                               object: nil)
    }
    
    private func updateBadgeCount() {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 3, execute: { [weak self] in
            self?.mailService.getTotalEmailCount { result in
                switch result {
                case .success(let count):
                    self?.userNotificationManager.updateBadgeCount(to: count.unread)
                case .failure(let error):
                    Log.e("Failed to update badge count: \(error.localizedDescription)")
                }
            }
        })
    }
    
    @objc private func handleNewMail(_ notification: Notification) {
        if let mail = notification.object as? WSMail {
            mailService.getAllEmailIDs { [weak self] resultSavedIds in
                switch resultSavedIds {
                case .success(let savedIds):
                    if !savedIds.contains(mail.payload.uidl) {
                        self?.mailService.fetchEmail(uidl: mail.payload.uidl,
                                                     folder: .input,
                                                    completion: { email in
                            if let email = email {
                                self?.addMail(email,
                                        toFolder: GlobalConstants.inboxEmails) { result in
                                    switch result {
                                    case .success():
                                        Log.i("Email added by uidl: \(mail.payload.uidl)")
                                        NotificationCenter.default.post(name: .inputMailListDidUpdate, object: nil)
                                        self?.userNotificationManager.sendLocalNotification(title: "Новое письмо",
                                                                                            text: email.subject)
                                    case .failure(let error):
                                        Log.e("Failed to add Email By uidl: \(mail.payload.uidl)  \(error.localizedDescription)")
                                    }
                                }
                            } else {
                                Log.e("Failed to EmailInfoBy(uidl: \(mail.payload.uidl)")
                            }
                        })
                    }
                case .failure(let error):
                    Log.e("Failed to fetch saved mail ids: \(error.localizedDescription)")
                }

            }
        }
    }
    
//MARK: - Методы для работы с папками
    func createFolder(name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        mailService.createFolder(name: name,
                                 completion: completion)
    }

    func getAllFolders(completion: @escaping (Result<[FolderData], Error>) -> Void) {
        mailService.getAllFolders(completion: completion)
    }

    func deleteFolder(_ folderName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        mailService.deleteFolder(folderName,
                                 completion: completion)
    }

    func clearFolder(_ folderName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        mailService.clearFolder(folderName,
                                completion: completion)
    }

//MARK: - Методы для работы с письмами
    func getTotalEmailCount(completion: @escaping (Result<(total: Int, unread: Int), Error>) -> Void) {
        mailService.getTotalEmailCount(completion: completion)
    }

    func getMailsCountFrom(_ folderName: String, completion: @escaping (Result<(total: Int, unread: Int?), Error>) -> Void) {
        mailService.getMailsCountFrom(folderName, completion: completion)
    }

    func updateIsRead(id: String, isRead: Bool, folder: MailFolder, completion: @escaping (Result<EmailMessageModel, Error>) -> Void) {
        mailService.updateIsRead(id: id,
                                 isRead: isRead,
                                 folder: folder,
                                 completion: completion)
        updateBadgeCount()
    }
    
    func addMail(_ mailData: EmailMessageModel, toFolder folderName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        mailService.addMail(mailData,
                            toFolder: folderName,
                            completion: completion)
    }

    func getAllMails(page: Int, pageSize: Int, completion: @escaping (Result<[EmailMessageModel], Error>) -> Void) {
        mailService.getAllMails(page: page,
                                pageSize: pageSize,
                                completion: completion)
        updateBadgeCount()
    }

    func getAllStoredEmails(completion: @escaping (Result<[EmailMessageModel], Error>) -> Void) {
        mailService.getAllStoredEmails(completion: completion)
        updateBadgeCount()
    }

    func getAllStoredEmailsFromFolder(_ folderName: String, completion: @escaping (Result<[EmailMessageModel], Error>) -> Void) {
        mailService.getAllStoredEmailsFromFolder(folderName, completion: completion)
        updateBadgeCount()
    }

    func getMails(fromFolder folderName: String, page: Int, pageSize: Int, completion: @escaping (Result<[EmailMessageModel], Error>) -> Void) {
        mailService.getMails(fromFolder: folderName,
                             page: page,
                             pageSize: pageSize,
                             completion: completion)
    }

    func getMail(byUIDL uidl: String, completion: @escaping (Result<EmailMessageModel, Error>) -> Void) {
        mailService.getMail(byUIDL: uidl,
                            completion: completion)
    }

    func deleteMail(_ mailUIDL: String, completion: @escaping (Result<Void, Error>) -> Void) {
        mailService.deleteMail(mailUIDL, completion: completion)
    }

    func moveMail(_ mailUIDL: String, toFolder folderName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        mailService.moveMail(mailUIDL,
                             toFolder: folderName,
                             completion: completion)
    }

//MARK: - Методы для отправки и получения писем
//    func sendMail(_ mailData: EmailMessageModel, completion: @escaping (Result<Void, Error>) -> Void) {
//        Log.i("Sending mail: \(mailData.subject)")
//        DispatchQueue.global().async(flags: .barrier) {
//            self.sentMails.append(EmailMessage(model: mailData))
//            DispatchQueue.main.async {
//                Log.i("Mail sent: \(mailData.subject)")
//                completion(.success(()))
//            }
//        }
//    }


    func sendMail(_ mailData: EmailMessageModel, completion: @escaping (Result<Void, Error>) -> Void) {
        let sendingQueue = DispatchQueue(label: "com.SGTS.fileQueue", attributes: .concurrent)
        Log.i("Sending mail: \(mailData.subject)")

        sendingQueue.async(flags: .barrier) {
            do {
                self.sentMails.append(EmailMessage(model: mailData))

                DispatchQueue.main.async {
                    Log.i("Mail sent: \(mailData.subject)")
                    completion(.success(()))
                }
            }
        }
    }

    func fetchNewMails(completion: @escaping (Result<[EmailMessageModel], Error>) -> Void) {
        mailService.fetchAllEMails(completion: { _ in
            Log.i("Fetched new mails")
            completion(.success([]))
        })
    }
}

extension Notification.Name {
    static let inputMailListDidUpdate = Notification.Name("inputMailListDidUpdate")
}
