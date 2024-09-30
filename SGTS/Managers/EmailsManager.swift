//
//  EmailsManager.swift
//  SGTS
//
//  Created by Roman Vakulenko on 11.06.2024.
//

import Foundation
import UIKit

protocol EmailsManagerProtocol {

    func fillAllEmailCellsModelWithMailData(completion: @escaping (Result<[EmailCellModelFromDatabase], MailStartScreenModel.Errors>) -> Void)

    func fillEmailDetailsModelWithMailData(completion: @escaping (Result<[OneEmailDetailsModelFromDatabase], OneEmailDetailsModel.Errors>) -> Void)

    func uploadReplyEmailDataToDatabase(replyEmailModel: [ReplyEmailModelFromDatabase])

    func getListOfAllAttachments(page: Int, pageSize: Int, completion: @escaping (Result<[AttachmentCellModelFromDatabase], AttachmentsScreenModel.Errors>) -> Void)
}


class EmailsManager: EmailsManagerProtocol {  // и на прием и на отпрпавку
    static let shared = EmailsManager()

    func fillAllEmailCellsModelWithMailData(completion: @escaping (Result<[EmailCellModelFromDatabase], MailStartScreenModel.Errors>) -> Void) {
        ()
    }

    func fillEmailDetailsModelWithMailData(completion: @escaping (Result<[OneEmailDetailsModelFromDatabase], OneEmailDetailsModel.Errors>) -> Void) {
        ()
    }

    func uploadReplyEmailDataToDatabase(replyEmailModel: [ReplyEmailModelFromDatabase]) {
        ()
    }

    func getListOfAllAttachments(page: Int, pageSize: Int, completion: @escaping (Result<[AttachmentCellModelFromDatabase], AttachmentsScreenModel.Errors>) -> Void) {

    }


    func getAttachmentFileDataWith(id: String, completion: @escaping (Result<Data, AttachmentsScreenModel.Errors>) -> Void) {
#warning("из-за завершения проекта этот код не был дописан по согласованию")
//        DatabaseManager.shared.getAttachmentFileDataWith(id: id) { [weak self] result in
//            guard let self else {return}
//
//            switch result {
//            case .success(let fileDataOfOneAttachment):
//                ()
//            completion(.success(fileDataOfOneAttachment))
//
//            case .failure(_):
//                completion(.failure(.cantFetchData))
//            }
//        }
    }

}

// MARK: - For MailStartScreen

struct EmailCellModelFromDatabase {
    let mailLUID: String // id mail'a
    let avatarImageStringURL: String?
    let senderName: String
    let emailTitle: String
    let emailText: String
    let emailDate: String

    let isNewEmail: Bool
    let isPersonalToUser: Bool
    let isEmportant: Bool
    let isExternalEmail: Bool
    let hasAttachment: Bool

    let cloudAttachments: [CloudMailAttachmentEmailCellModel]?
}

struct CloudMailAttachmentEmailCellModel {
    let fileName: String
    let fileExt: String
}


// MARK: - For OneEmailDetails

struct OneEmailDetailsModelFromDatabase {
    let mailLUID: String // id mail'a
    let emailTitle: String
    let dateTimeReceivedSubTitle: String
    let avatarImageStringURL: String?
    let senderName: String
    let senderEmailAddress: String
    let recipientEmailAddresses: [String]
    let dateTimeSend: String
    let hasAttachments: Bool

    let cloudAttachments: [CloudMailAttachmentEmailDetailsModel]?
    let emailText: String

}

struct CloudMailAttachmentEmailDetailsModel {
    let fileName: String
    let fileExt: String
//    let file: Data? //для фото?
}


// MARK: - For ReplyEmail

struct ReplyEmailModelFromDatabase {//верно ли понимаю, что будем писать в БД, а не читать, а email'ы тех, кому отвечаем - можем передать между модулями/экранами
    let mailLUID: String? // id mail'a
    let senderEmailAddress: String
    let recipientEmailAddresses: [String]
    let recipientCopyEmailAddresses: [String]?
    let dateTimeSend: String
    let hasAttachments: Bool

    let cloudAttachments: [CloudMailAttachmentReplyEmailModel]?
    let emailText: String

}

struct CloudMailAttachmentReplyEmailModel {
    let fileName: String
    let fileExt: String
    let file: Data
//    let file: Data //?
}


// MARK: - For ReplyEmail

struct AttachmentCellModelFromDatabase {
    let attachmentLUID: String?
    var urlInProgrammsDirectory: URL?
    var fileData: Data?
    let fileNameWithExt: String
    let nameAndSurname: String

    let downloadingDate: String//Date
    let downloadingSize: String
}
