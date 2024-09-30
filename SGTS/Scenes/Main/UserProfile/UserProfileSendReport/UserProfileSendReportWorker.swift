//
//  UserProfileSendReportWorker.swift
//  SGTS
//
//  Created by Roman Vakulenko on 02.07.2024.
//

import Foundation

protocol UserProfileSendReportWorkingLogic {
    func getMail(byLUID luid: String, completion: @escaping (Result<EmailMessage, OneEmailDetailsModel.Errors>) -> Void)
    func createFolder(name: String, completion: @escaping (Result<Void, OneEmailDetailsModel.Errors>) -> Void)
    func moveMail(_ mailUIDL: String, toFolder folderName: String, completion: @escaping (Result<Void, OneEmailDetailsModel.Errors>) -> Void)
    func addMail(_ mailData: EmailMessageModel, toFolder folderName: String, completion: @escaping (Result<Void, OneEmailDetailsModel.Errors>) -> Void)
    func sendMail(_ mailData: EmailMessageModel, completion: @escaping (Result<Void, NewEmailCreateModels.Errors>) -> Void)
    func deleteMail(_ mailUIDL: String, completion: @escaping (Result<Void, OneEmailDetailsModel.Errors>) -> Void)

    func getFileData(url: URL, completion: @escaping (Result<Data, FileUploadErrors>) -> Void)
}

final class UserProfileSendReportWorker: UserProfileSendReportWorkingLogic {

    enum Constants {
        static let amountOfMailsAtPage = 10
    }
    // MARK: - Public properties

    // MARK: - Private properties
    //возможно понадобится
    private let concurrentQueue = DispatchQueue(label: "com.SGTS.fileQueue", attributes: .concurrent)

    private let mailManager = DIManager.shared.container.resolve(EmailManagerProtocol.self)!
    private let network: NetworkManaging = NetworkManager()

    // MARK: - Public methods
    
    func getMail(byLUID luid: String, completion: @escaping (Result<EmailMessage, OneEmailDetailsModel.Errors>) -> Void) {
        
        //        DatabaseManager.shared.getMail(byLUID: luid) { [weak self] result in
        //            guard let self else {return}
        //
        //            switch result {
        //            case .success(let oneEmailData):
        //                completion(.success(oneEmailData))
        //
        //            case .failure(_):
        //                completion(.failure(.cantFetchOneEmail))
        //            }
        //        }
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

    func moveMail(_ mailUIDL: String,
                  toFolder folderName: String,
                  completion: @escaping (Result<Void, OneEmailDetailsModel.Errors>) -> Void) {
        Log.i("Moving mail to folder: \(folderName)")

        mailManager.moveMail(mailUIDL, toFolder: folderName) { result in
            switch result {
            case .success():
                completion(.success(Void()))

            case .failure(_):
                completion(.failure(.errorAtMovingToFolder))
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
}
