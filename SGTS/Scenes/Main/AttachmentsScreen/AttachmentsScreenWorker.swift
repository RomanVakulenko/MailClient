//
//  AttachmentsScreenWorker.swift
//  SGTS
//
//  Created by Roman Vakulenko on 12.06.2024.
//

import Foundation

protocol AttachmentsScreenWorkingLogic {
    func getAllAttachmentsList(completion: @escaping (Result<[AttachmentCellModelFromDatabase], AttachmentsScreenModel.Errors>) -> Void)

    func getAttachmentFileDataWith(attachmentLUID: String,
                                   completion: @escaping (Result<Data, AttachmentsScreenModel.Errors>) -> Void)

    var isAllAttachmentsLoaded: Bool { get }
}


final class AttachmentsScreenWorker: AttachmentsScreenWorkingLogic {
    
    enum Constants {
        static let amountOfAttachmentsPerOneDownload = 15
    }
    // MARK: - Public properties

    var isAllAttachmentsLoaded = false

    // MARK: - Private properties

    private let network: NetworkManaging = NetworkManager()
    private var pageNumber = 0
    private var allAttachmentsList = [AttachmentCellModelFromDatabase]()

    // MARK: - Public methods

    func getAllAttachmentsList(completion: @escaping (Result<[AttachmentCellModelFromDatabase], AttachmentsScreenModel.Errors>) -> Void) {

        EmailsManager.shared.getListOfAllAttachments(page: pageNumber,
                                                     pageSize: Constants.amountOfAttachmentsPerOneDownload) { [weak self] result in
            guard let self else {return}
            switch result {
            case .success(let allAttachmentsListFromDatabase):

                allAttachmentsList = allAttachmentsListFromDatabase.map { AttachmentCellModelFromDatabase(
                    attachmentLUID: $0.attachmentLUID,
                    urlInProgrammsDirectory: nil,
                    fileData: nil, //"теряю часть данных, что не нужны, здесь - это fileData"
                    fileNameWithExt: $0.fileNameWithExt,
                    nameAndSurname: $0.nameAndSurname,
                    downloadingDate: $0.downloadingDate,
                    downloadingSize: $0.downloadingSize)
                }

                isAllAttachmentsLoaded = allAttachmentsListFromDatabase.count < Constants.amountOfAttachmentsPerOneDownload
                pageNumber += 1
                completion(.success(allAttachmentsList))

            case .failure(_):
                completion(.failure(.cantFetchData))
            }
        }

    }


    func getAttachmentFileDataWith(attachmentLUID: String, completion: @escaping (Result<Data, AttachmentsScreenModel.Errors>) -> Void) {
        EmailsManager.shared.getAttachmentFileDataWith(id: attachmentLUID) { result in
            
            switch result {
            case .success(let fileDataOfOneAttachment):
                completion(.success(fileDataOfOneAttachment))

            case .failure(_):
                completion(.failure(.cantFetchData))
            }
        }
    }
}
