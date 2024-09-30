import Foundation
import RealmSwift

// Протокол для работы с Realm
protocol MailDatabaseProtocol {
    func createFolder(name: String, completion: @escaping (Result<Void, Error>) -> Void)
    func getAllFolders(completion: @escaping (Result<[FolderData], Error>) -> Void)
    func deleteFolder(_ folderName: String, completion: @escaping (Result<Void, Error>) -> Void)
    func clearFolder(_ folderName: String, completion: @escaping (Result<Void, Error>) -> Void)
    func addEmail(_ email: EmailMessage, toFolder folderName: String, completion: @escaping (Result<Void, Error>) -> Void)
    func getAllEmails(page: Int, pageSize: Int, completion: @escaping (Result<[EmailMessage], Error>) -> Void)
    func getAllEmails(completion: @escaping (Result<[EmailMessage], Error>) -> Void)
    func getAllEmailsFromFolder(_ folderName: String, completion: @escaping (Result<[EmailMessage], Error>) -> Void)
    func getEmails(fromFolder folderName: String, page: Int, pageSize: Int, completion: @escaping (Result<[EmailMessage], Error>) -> Void)
    func getEmail(byUIDL uidl: String, completion: @escaping (Result<EmailMessage, Error>) -> Void)
    func deleteEmail(_ emailUIDL: String, completion: @escaping (Result<Void, Error>) -> Void)
    func moveEmail(_ emailUIDL: String, toFolder folderName: String, completion: @escaping (Result<Void, Error>) -> Void)
    func getAllEmailIDs(completion: @escaping (Result<[String], Error>) -> Void)
    func getTotalEmailCount(completion: @escaping (Result<(total: Int, unread: Int), Error>) -> Void)
//    func getMailsCountFrom(_ folderName: String, completion: @escaping (Result<Int, Error>) -> Void)
    func getMailsCountFrom(_ folderName: String, completion: @escaping (Result<(total: Int, unread: Int?), Error>) -> Void)
    func updateIsRead(id: String, isRead: Bool, completion: @escaping (Result<EmailMessage, Error>) -> Void)
}

class MailDatabaseService: MailDatabaseProtocol {
    static let shared: (MailDatabaseProtocol & ContactDatabaseProtocol) = MailDatabaseService()
    internal let queue = DispatchQueue(label: "realmSGTSQueue",
                                      qos: .userInitiated,
                                      attributes: .concurrent)
    internal let fileManager = DIManager.shared.container.resolve(FileServiceProtocol.self)!
    private init() {
        configureRealm()
    }
    
    private func configureRealm() {
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    // Пример миграции: Если добавляется новое поле, его нужно инициализировать
                }
            },
            shouldCompactOnLaunch: { totalBytes, usedBytes in
                // Сжимаем базу данных при запуске, если более 50% пространства не используется
                let fiftyMB = 50 * 1024 * 1024
                return (totalBytes > fiftyMB) && (Double(usedBytes) / Double(totalBytes)) < 0.5
            }
        )
        Realm.Configuration.defaultConfiguration = config
    }
    
    func createFolder(name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Log.i("Creating folder with name: \(name)")
        queue.async(flags: .barrier) {
            Realm.asyncOpen { result in
                switch result {
                case .success(let realm):
                    do {
                        let folder = Folder()
                        folder.name = name
                        try realm.write {
                            realm.add(folder)
                        }
                        Log.i("Folder \(name) created successfully")
                        DispatchQueue.main.async {
                            completion(.success(()))
                        }
                    } catch {
                        Log.e("Failed to create folder \(name): \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    Log.e("Failed to open Realm for creating folder \(name): \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func getAllFolders(completion: @escaping (Result<[FolderData], Error>) -> Void) {
        Log.i("Fetching all folders")
        queue.async {
            Realm.asyncOpen { result in
                switch result {
                case .success(let realm):
                    let folders = realm.objects(Folder.self).map { folder in
                        FolderData(
                            name: folder.name,
                            emails: folder.emails.map { $0 }
                        )
                    }
                    Log.i("Fetched \(folders.count) folders")
                    DispatchQueue.main.async {
                        completion(.success(Array(folders)))
                    }
                case .failure(let error):
                    Log.e("Failed to fetch folders: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func deleteFolder(_ folderName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Log.i("Deleting folder with name: \(folderName)")
        queue.async(flags: .barrier) {
            Realm.asyncOpen { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let realm):
                    do {
                        if let folder = realm.objects(Folder.self).filter("name == %@", folderName).first {
                            try realm.write {
                                for email in folder.emails {
                                    for attachment in email.attachments {
                                        if self.fileManager.deleteAtContainer(fileName: attachment.filenameToTemporarySave) {
                                            Log.i("File \(attachment.filenameToTemporarySave) deleted successfully.")
                                        } else {
                                            Log.e("Failed to delete file \(attachment.filenameToTemporarySave).")
                                        }
                                    }
                                }
                                realm.delete(folder)
                            }
                            Log.i("Folder \(folderName) deleted successfully")
                            DispatchQueue.main.async {
                                completion(.success(()))
                            }
                        } else {
                            Log.e("Folder \(folderName) not found")
                            DispatchQueue.main.async {
                                completion(.failure(NSError(domain: "",
                                                            code: 404,
                                                            userInfo: [NSLocalizedDescriptionKey: "Folder not found"])))
                            }
                        }
                    } catch {
                        Log.e("Failed to delete folder \(folderName): \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    Log.e("Failed to open Realm for deleting folder \(folderName): \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func clearFolder(_ folderName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Log.i("Clearing folder with name: \(folderName)")
        queue.async(flags: .barrier) {
            Realm.asyncOpen { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let realm):
                    do {
                        if let folder = realm.objects(Folder.self).filter("name == %@", folderName).first {
                            try realm.write {
                                for email in folder.emails {
                                    for attachment in email.attachments {
                                        if self.fileManager.deleteAtContainer(fileName: attachment.filenameToTemporarySave) {
                                            Log.i("File \(attachment.filenameToTemporarySave) deleted successfully.")
                                        } else {
                                            Log.e("Failed to delete file \(attachment.filenameToTemporarySave).")
                                        }
                                    }
                                }
                                realm.delete(folder.emails)
                            }
                            Log.i("Folder \(folderName) cleared successfully")
                            DispatchQueue.main.async {
                                completion(.success(()))
                            }
                        } else {
                            Log.e("Folder \(folderName) not found")
                            DispatchQueue.main.async {
                                completion(.failure(NSError(domain: "",
                                                            code: 404,
                                                            userInfo: [NSLocalizedDescriptionKey: "Folder not found"])))
                            }
                        }
                    } catch {
                        Log.e("Failed to clear folder \(folderName): \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    Log.e("Failed to open Realm for clearing folder \(folderName): \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func addEmail(_ email: EmailMessage, toFolder folderName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Log.i("Adding email to folder: \(folderName)")
        queue.async(flags: .barrier) {
            Realm.asyncOpen { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let realm):
                    do {
                        guard let folder = realm.objects(Folder.self).filter("name == %@", folderName).first else {
                            Log.e("Folder \(folderName) not found")
                            DispatchQueue.main.async {
                                completion(.failure(NSError(domain: "",
                                                            code: 404,
                                                            userInfo: [NSLocalizedDescriptionKey: "Folder not found"])))
                            }
                            return
                        }
                        
                        // Проверка на существование email перед транзакцией
                        if realm.object(ofType: EmailMessage.self, forPrimaryKey: email.id) != nil {
                            Log.i("Email with primary key \(email.id) already exists, skipping creation.")
                            DispatchQueue.main.async {
                                completion(.success(()))
                            }
                            return
                        }

                        try realm.write {
                            for attachment in email.attachments {
                                if let fileName = self.fileManager.saveIntoContainer(data: attachment.content) {
                                    attachment.filenameToTemporarySave = fileName
                                    attachment.content = Data()
                                }
                            }
                            for attachment in email.htmlInlineAttachments {
                                if let fileName = self.fileManager.saveIntoContainer(data: attachment.content) {
                                    attachment.filenameToTemporarySave = fileName
                                    attachment.content = Data()
                                }
                            }
                            folder.emails.append(email)
                        }
                        Log.i("Email added to folder \(folderName) successfully")
                        DispatchQueue.main.async {
                            completion(.success(()))
                        }
                    } catch {
                        Log.e("Failed to add email to folder \(folderName): \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    Log.e("Failed to open Realm for adding email to folder \(folderName): \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func getAllEmails(page: Int, pageSize: Int, completion: @escaping (Result<[EmailMessage], Error>) -> Void) {
        Log.i("Fetching all emails, page: \(page), pageSize: \(pageSize)")
        queue.async {
            Realm.asyncOpen { result in
                switch result {
                case .success(let realm):
                    let emails = realm.objects(EmailMessage.self)
                        .sorted(byKeyPath: "date", ascending: false)
                        .dropFirst(page * pageSize)
                        .prefix(pageSize)
                        .map { $0 }
                    Log.i("Fetched (emails.count) emails")
                    DispatchQueue.main.async {
                        completion(.success(Array(emails)))
                    }
                case .failure(let error):
                    Log.e("Failed to fetch emails: (error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func getAllEmails(completion: @escaping (Result<[EmailMessage], Error>) -> Void) {
        Log.i("Fetching all emails")
        queue.async {
            Realm.asyncOpen { result in
                switch result {
                case .success(let realm):
                    let emails = realm.objects(EmailMessage.self)
                        .sorted(byKeyPath: "date", ascending: false)
                        .map { $0 }
                    Log.i("Fetched \(emails.count) emails")
                    DispatchQueue.main.async {
                        completion(.success(Array(emails)))
                    }
                case .failure(let error):
                    Log.e("Failed to fetch emails: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func getEmails(fromFolder folderName: String, page: Int, pageSize: Int, completion: @escaping (Result<[EmailMessage], Error>) -> Void) {
        Log.i("Fetching emails from folder: \(folderName), page: \(page), pageSize: \(pageSize)")
        queue.async {
            Realm.asyncOpen { result in
                switch result {
                case .success(let realm):
                    if let folder = realm.objects(Folder.self).filter("name == %@", folderName).first {
                        let emails = folder.emails
                            .sorted(byKeyPath: "date", ascending: false)
                            .dropFirst(page * pageSize)
                            .prefix(pageSize)
                            .map { $0 }
                        Log.i("Fetched \(emails.count) emails from folder \(folderName)")
                        DispatchQueue.main.async {
                            completion(.success(Array(emails)))
                        }
                    } else {
                        Log.e("Folder \(folderName) not found")
                        DispatchQueue.main.async {
                            completion(.failure(NSError(domain: "",
                                                        code: 404,
                                                        userInfo: [NSLocalizedDescriptionKey: "Folder not found"])))
                        }
                    }
                case .failure(let error):
                    Log.e("Failed to fetch emails from folder \(folderName): \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }

    func getAllEmailsFromFolder(_ folderName: String, completion: @escaping (Result<[EmailMessage], Error>) -> Void) {
        Log.i("Fetching all emails from folder: \(folderName)")
        queue.async {
            Realm.asyncOpen { result in
                switch result {
                case .success(let realm):
                    if let folder = realm.objects(Folder.self).filter("name == %@", folderName).first {
                        let emails = folder.emails
                            .sorted(byKeyPath: "date", ascending: false)
                            .map { $0 }
                        Log.i("Fetched \(emails.count) - all emails from folder \(folderName)")
                        DispatchQueue.main.async {
                            completion(.success(Array(emails)))
                        }
                    } else {
                        Log.e("Folder \(folderName) not found")
                        DispatchQueue.main.async {
                            completion(.failure(NSError(domain: "",
                                                        code: 404,
                                                        userInfo: [NSLocalizedDescriptionKey: "Folder not found"])))
                        }
                    }
                case .failure(let error):
                    Log.e("Failed to fetch emails from folder \(folderName): \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }

    func getEmail(byUIDL uidl: String, completion: @escaping (Result<EmailMessage, Error>) -> Void) {
        Log.i("Fetching email with UIDL: \(uidl)")
        queue.async {
            Realm.asyncOpen { result in
                switch result {
                case .success(let realm):
                    if let email = realm.objects(EmailMessage.self).filter("id == %@", uidl).first {
                        Log.i("Fetched email with UIDL: \(uidl)")
                        DispatchQueue.main.async {
                            completion(.success(email))
                        }
                    } else {
                        Log.e("Email with UIDL \(uidl) not found")
                        DispatchQueue.main.async {
                            completion(.failure(NSError(domain: "",
                                                        code: 404,
                                                        userInfo: [NSLocalizedDescriptionKey: "Email not found"])))
                        }
                    }
                case .failure(let error):
                    Log.e("Failed to fetch email with UIDL \(uidl): \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func deleteEmail(_ emailUIDL: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Log.i("Deleting email with UIDL: \(emailUIDL)")
        queue.async(flags: .barrier) {
            Realm.asyncOpen { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let realm):
                    do {
                        if let email = realm.objects(EmailMessage.self).filter("id == %@", emailUIDL).first {
                            try realm.write {
                                for attachment in email.attachments {
                                    if self.fileManager.deleteAtContainer(fileName: attachment.filenameToTemporarySave) {
                                        Log.i("File \(attachment.filenameToTemporarySave) deleted successfully.")
                                    } else {
                                        Log.e("Failed to delete file \(attachment.filenameToTemporarySave).")
                                    }
                                }
                                realm.delete(email)
                            }
                            Log.i("Email with UIDL \(emailUIDL) deleted successfully")
                            DispatchQueue.main.async {
                                completion(.success(()))
                            }
                        } else {
                            Log.e("Email with UIDL \(emailUIDL) not found")
                            DispatchQueue.main.async {
                                completion(.failure(NSError(domain: "",
                                                            code: 404,
                                                            userInfo: [NSLocalizedDescriptionKey: "Email not found"])))
                            }
                        }
                    } catch {
                        Log.e("Failed to delete email with UIDL \(emailUIDL): \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    Log.e("Failed to open Realm for deleting email with UIDL \(emailUIDL): \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func moveEmail(_ emailUIDL: String, toFolder folderName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Log.i("Moving email with UIDL \(emailUIDL) to folder \(folderName)")
        queue.async(flags: .barrier) {
            Realm.asyncOpen { result in
                switch result {
                case .success(let realm):
                    do {
                        guard let email = realm.objects(EmailMessage.self).filter("id == %@", emailUIDL).first,
                              let newFolder = realm.objects(Folder.self).filter("name == %@", folderName).first else {
                            Log.e("Email or Folder not found for moving")
                            DispatchQueue.main.async {
                                completion(.failure(NSError(domain: "",
                                                            code: 404,
                                                            userInfo: [NSLocalizedDescriptionKey: "Email or Folder not found"])))
                            }
                            return
                        }
                        try realm.write {
                            if let currentFolder = realm.objects(Folder.self).filter("emails.id == %@", emailUIDL).first,
                               let index = currentFolder.emails.index(of: email) {
                                currentFolder.emails.remove(at: index)
                            }
                            newFolder.emails.append(email)
                        }
                        Log.i("Email with UIDL \(emailUIDL) moved to folder \(folderName) successfully")
                        DispatchQueue.main.async {
                            completion(.success(()))
                        }
                    } catch {
                        Log.e("Failed to move email with UIDL \(emailUIDL) to folder \(folderName): \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    Log.e("Failed to open Realm for moving email with UIDL \(emailUIDL) to folder \(folderName): \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func getAllEmailIDs(completion: @escaping (Result<[String], Error>) -> Void) {
        Log.i("Fetching all email IDs")
        queue.async {
            Realm.asyncOpen { result in
                switch result {
                case .success(let realm):
                    let allEmails = realm.objects(Folder.self).flatMap { $0.emails }
                    let emailIDs = allEmails.map { $0.id }
                    Log.i("Fetched \(emailIDs.count) email IDs")
                    DispatchQueue.main.async {
                        completion(.success(Array(emailIDs)))
                    }
                case .failure(let error):
                    Log.e("Failed to fetch email IDs: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func getTotalEmailCount(completion: @escaping (Result<(total: Int, unread: Int), Error>) -> Void) {
        Log.i("Fetching total and unread email count")
        queue.async {
            Realm.asyncOpen { result in
                switch result {
                case .success(let realm):
                    let totalEmailCount = realm.objects(EmailMessage.self).count
                    let unreadEmailCount = realm.objects(EmailMessage.self).filter("isRead == false").count
                    Log.i("Fetched total email count: \(totalEmailCount), unread email count: \(unreadEmailCount)")
                    DispatchQueue.main.async {
                        completion(.success((total: totalEmailCount, unread: unreadEmailCount)))
                    }
                case .failure(let error):
                    Log.e("Failed to fetch email count: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }

    func getMailsCountFrom(_ folderName: String, completion: @escaping (Result<(total: Int, unread: Int?), Error>) -> Void) {
        Log.i("Fetching all emails from folder: \(folderName)")
        queue.async {
            Realm.asyncOpen { result in
                switch result {
                case .success(let realm):
                    if let folder = realm.objects(Folder.self).filter("name == %@", folderName).first {
                        // Папка найдена, возвращаем количество писем
                        let emailsCount = folder.emails.count
                        Log.i("Fetched \(emailsCount) - all emails from folder \(folderName)")
//                        DispatchQueue.main.async {
//                            completion(.success(emailsCount))
//                        }
                        let totalEmailCount = folder.emails.count
                        let unreadEmailCount = folder.emails.filter("isRead == false").count
                        Log.i("Fetched total email count: \(totalEmailCount), unread email count: \(unreadEmailCount)")
                        DispatchQueue.main.async {
                            completion(.success((total: totalEmailCount, unread: unreadEmailCount)))
                        }
                    } else {
                        // Папка не найдена, создаем новую и возвращаем 0
                        self.createFolder(name: folderName) { creationResult in
                            switch creationResult {
                            case .success:
                                Log.i("Created new folder: \(folderName)")
                                DispatchQueue.main.async {
                                    completion(.success((total: 0, unread: nil)))
                                }
                            case .failure(let error):
                                Log.e("Failed to create folder \(folderName): \(error.localizedDescription)")
                                DispatchQueue.main.async {
                                    completion(.failure(error))
                                }
                            }
                        }
                    }
                case .failure(let error):
                    Log.e("Failed to fetch emails from folder \(folderName): \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }


//    func updateEmail(email: EmailMessage, completion: @escaping (Result<EmailMessage, Error>) -> Void) {
//        Log.i("Updating email with id: \(email.id)")
//        queue.async(flags: .barrier) {
//            Realm.asyncOpen { result in
//                switch result {
//                case .success(let realm):
//                    do {
//                        if let existingEmail = realm.objects(EmailMessage.self).filter("id == %@", email.id).first {
//                            try realm.write {
//                                existingEmail.subject = email.subject
//                                existingEmail.body = email.body
//                                existingEmail.sender = email.sender
//                                existingEmail.recipients = email.recipients
//                                existingEmail.date = email.date
//                                existingEmail.attachments.removeAll()
//                                existingEmail.attachments.append(objectsIn: email.attachments)
//                                // Обновление всех других полей объекта EmailMessage
//                            }
//                            Log.i("Email with id \(email.id) updated successfully")
//                            DispatchQueue.main.async {
//                                completion(.success(existingEmail))
//                            }
//                        } else {
//                            Log.e("Email with id \(email.id) not found")
//                            DispatchQueue.main.async {
//                                completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Email not found"])))
//                            }
//                        }
//                    } catch {
//                        Log.e("Failed to update email with id \(email.id): \(error.localizedDescription)")
//                        DispatchQueue.main.async {
//                            completion(.failure(error))
//                        }
//                    }
//                case .failure(let error):
//                    Log.e("Failed to open Realm for updating email with id \(email.id): \(error.localizedDescription)")
//                    DispatchQueue.main.async {
//                        completion(.failure(error))
//                    }
//                }
//            }
//        }
//    }
    
    func updateIsRead(id: String, isRead: Bool, completion: @escaping (Result<EmailMessage, Error>) -> Void) {
        Log.i("Updating email with id: \(id)")
        queue.async(flags: .barrier) {
            Realm.asyncOpen { result in
                switch result {
                case .success(let realm):
                    do {
                        if let existingEmail = realm.objects(EmailMessage.self).filter("id == %@", id).first {
                            try realm.write {
                                existingEmail.isRead = isRead
                            }
                            Log.i("Email with id \(id) updated successfully")
                            DispatchQueue.main.async {
                                completion(.success(existingEmail))
                            }
                        } else {
                            Log.e("Email with id \(id) not found")
                            DispatchQueue.main.async {
                                completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Email not found"])))
                            }
                        }
                    } catch {
                        Log.e("Failed to update email with id \(id): \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    Log.e("Failed to open Realm for updating email with id \(id): \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
