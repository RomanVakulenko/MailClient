//
//  ImageFullScreenWorker.swift
//  SGTS
//
//  Created by Roman Vakulenko on 02.05.2024.
//

import Foundation

protocol ImageFullScreenWorkingLogic {
    func getMail(byUIDL uidl: String,
                 completion: @escaping (Result<EmailMessageModel, OneEmailDetailsModel.Errors>) -> Void)
}

final class ImageFullScreenWorker: ImageFullScreenWorkingLogic {

    enum Constants {
        static let amountOfMailsAtPage = 10
    }
    // MARK: - Public properties

    // MARK: - Private properties
    //возможно понадобится
    private let concurrentQueue = DispatchQueue(label: "com.SGTS.fileQueue", attributes: .concurrent)

    private let network: NetworkManaging = NetworkManager()

    // MARK: - Public methods

    func getMail(byUIDL uidl: String,
                 completion: @escaping (Result<EmailMessageModel, OneEmailDetailsModel.Errors>) -> Void) {

        MailManager.shared.getMail(byUIDL: uidl) { [weak self] result in
            guard self != nil else {return}

            switch result {
            case .success(let oneEmailMessage):

                let email = EmailMessageModel(
                    id: oneEmailMessage.id,
                    from: oneEmailMessage.from,
                    sender: oneEmailMessage.sender,
                    to: oneEmailMessage.to,
                    subject: oneEmailMessage.subject,
                    mimeVersion: oneEmailMessage.mimeVersion,
                    contentType: oneEmailMessage.contentType,
                    boundary: oneEmailMessage.boundary,
                    contentTransferEncoding: oneEmailMessage.contentTransferEncoding,
                    body: oneEmailMessage.body,
                    htmlBody: oneEmailMessage.htmlBody,
                    received: oneEmailMessage.received,
                    references: oneEmailMessage.references,
                    messageId: oneEmailMessage.messageId,
                    isPrivate: oneEmailMessage.isPrivate,
                    isRead: oneEmailMessage.isRead,
                    cc: oneEmailMessage.cc,
                    bcc: oneEmailMessage.bcc,
                    replyTo: oneEmailMessage.replyTo,
                    attachments: oneEmailMessage.attachments,
                    userAgent: oneEmailMessage.userAgent,
                    htmlInlineAttachments: oneEmailMessage.htmlInlineAttachments,
                    requiredPartsForRendering: oneEmailMessage.requiredPartsForRendering)

                completion(.success(email))

            case .failure(_):
                completion(.failure(.cantFetchOneEmail))
            }
        }
    }
}

