//
//  NewEmailCreateWorker.swift
//  SGTS
//
//  Created by Roman Vakulenko on 02.05.2024.
//

import Foundation

protocol NewEmailCreateWorkingLogic {
    //    func getMail(byLUID luid: String, completion: @escaping (Result<EmailMessage, OneEmailDetailsModel.Errors>) -> Void)

    func sendMail(_ mailData: EmailMessageModel, completion: @escaping (Result<Void, NewEmailCreateModels.Errors>) -> Void)
    func getFileData(url: URL, completion: @escaping (Result<Data, FileUploadErrors>) -> Void)
    func createFolder(name: String, completion: @escaping (Result<Void, NewEmailCreateModels.Errors>) -> Void)
    func addMail(_ mailData: EmailMessageModel, toFolder folderName: String, completion: @escaping (Result<Void, NewEmailCreateModels.Errors>) -> Void)
    func deleteMail(_ mailUIDL: String, completion: @escaping (Result<Void, NewEmailCreateModels.Errors>) -> Void)
    func getAllContacts(completion: @escaping (Result<[ContactListItem], OneContactDetailsModel.Errors>) -> Void)
}

enum FileUploadErrors: Error {
    case fileSizeLimitExceeded(maxSize: Int)
    case other(error: Error)
}

final class NewEmailCreateWorker: NewEmailCreateWorkingLogic {

    // MARK: - Public properties

    // MARK: - Private properties
    //возможно понадобится
    private let concurrentQueue = DispatchQueue(label: "com.SGTS.fileQueue", attributes: .concurrent)
    private let mailManager = DIManager.shared.container.resolve(EmailManagerProtocol.self)!
    private let contactManager = ContactManager.shared.self

    // MARK: - Public methods

    func getFileData(url: URL, completion: @escaping (Result<Data, FileUploadErrors>) -> Void) {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: url.path) //отсюда ли будет браться файл?
            if let fileSize = fileAttributes[.size] as? NSNumber {
                let maxFileSize = 50 * 1024 * 1024 // 50 MB
                if fileSize.intValue > maxFileSize {
                    completion(.failure(.fileSizeLimitExceeded(maxSize: maxFileSize)))
                    return
                }
            }
        } catch {
            completion(.failure(.other(error: error)))
            return
        }

        // Если размер файла <50Mb
        concurrentQueue.async {
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.other(error: error)))
                }
            }
        }
    }

    func sendMail(_ mailData: EmailMessageModel, completion: @escaping (Result<Void, NewEmailCreateModels.Errors>) -> Void) {
        mailManager.sendMail(mailData) { result in
            switch result {
            case .success():
                completion(.success(Void()))

            case .failure(_):
                completion(.failure(.errorAtSending))
            }
        }
    }

    func createFolder(name: String, completion: @escaping (Result<Void, NewEmailCreateModels.Errors>) -> Void) {
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

    func addMail(_ mailData: EmailMessageModel, toFolder folderName: String, completion: @escaping (Result<Void, NewEmailCreateModels.Errors>) -> Void) {

        Log.i("Adding mail to folder: \(folderName)")
        mailManager.addMail(mailData, toFolder: folderName) {  result in
            switch result {
            case .success():
                completion(.success(Void()))

            case .failure(_):
                completion(.failure(.errorAtAddingToFolder))
            }
        }
    }

    func deleteMail(_ mailUIDL: String, completion: @escaping (Result<Void, NewEmailCreateModels.Errors>) -> Void) {
        Log.i("Deleting mail by mailUIDL: \(mailUIDL)")

        mailManager.deleteMail(mailUIDL) { result in
            switch result {
            case .success():
                completion(.success(Void()))

            case .failure(_):
                completion(.failure(.errorAtDeletingFolder))
            }
        }
    }

    func getAllContacts(completion: @escaping (Result<[ContactListItem], OneContactDetailsModel.Errors>) -> Void) {
        contactManager.getAllContacts() { result in
            switch result {
            case .success(let arrayOfContacts):
                completion(.success(arrayOfContacts))

            case .failure(_):
                completion(.failure(.cantFetchAllContacts))
            }
        }
    }

}
