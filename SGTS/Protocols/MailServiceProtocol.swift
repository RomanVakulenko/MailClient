//
//  MailServiceProtocol.swift
// 30.07.2024.
//

protocol MailServiceProtocol {
    func fetchNewEmails(createsIds: [String], completion: @escaping ([EmailMessage]) -> Void)
    func fetchAllEMails(completion: @escaping (Result<Void, Error>) -> Void)
    func fetchEmailInfoBy(uidl: String, folder: MailFolder, completion: @escaping (Result<MailDTO, Error>) -> Void)
    func getContactInfo(senderMail: String, completion: @escaping (Result <Void, Error>) -> Void)
    func fetchEmail(uidl: String, folder: MailFolder, completion: @escaping (EmailMessageModel?) -> Void)
    func getTotalEmailCount(completion: @escaping (Result<(total: Int, unread: Int), Error>) -> Void)
//    func getMailsCountFrom(_ folderName: String, completion: @escaping (Result<Int, Error>) -> Void)
    func getMailsCountFrom(_ folderName: String, completion: @escaping (Result<(total: Int, unread: Int?), Error>) -> Void)
    func updateIsRead(id: String, isRead: Bool, folder: MailFolder, completion: @escaping (Result<EmailMessageModel, Error>) -> Void)
    
    // Database Control
    // Mail
    func moveMail(_ mailUIDL: String, toFolder folderName: String, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteMail(_ mailUIDL: String, completion: @escaping (Result<Void, Error>) -> Void)
    func getAllEmailIDs(completion: @escaping (Result<[String], Error>) -> Void)
    func getMail(byUIDL uidl: String, completion: @escaping (Result<EmailMessageModel, Error>) -> Void)
    func getMails(fromFolder folderName: String, page: Int, pageSize: Int, completion: @escaping (Result<[EmailMessageModel], Error>) -> Void)
    func getAllMails(page: Int, pageSize: Int, completion: @escaping (Result<[EmailMessageModel], Error>) -> Void)
    func getAllStoredEmails(completion: @escaping (Result<[EmailMessageModel], Error>) -> Void)
    func getAllStoredEmailsFromFolder(_ folderName: String, completion: @escaping (Result<[EmailMessageModel], Error>) -> Void)
    func addMail(_ mailData: EmailMessageModel, toFolder folderName: String, completion: @escaping (Result<Void, Error>) -> Void)
   
    // Folder
    func createFolder(name: String, completion: @escaping (Result<Void, Error>) -> Void)
    func getAllFolders(completion: @escaping (Result<[FolderData], Error>) -> Void)
    func deleteFolder(_ folderName: String, completion: @escaping (Result<Void, Error>) -> Void)
    func clearFolder(_ folderName: String, completion: @escaping (Result<Void, Error>) -> Void)
}
