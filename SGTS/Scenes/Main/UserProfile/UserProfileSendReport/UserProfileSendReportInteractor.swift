//
//  UserProfileSendReportInteractor.swift
//  SGTS
//
//  Created by Roman Vakulenko on 02.07.2024.
//

import Foundation
import UIKit

protocol UserProfileSendReportBusinessLogic {
    func onDidLoadViews(request: UserProfileSendReportFlow.OnDidLoadViews.Request)

    func didPickFotoFromGallaryOrFileFromDocumentsAt(urls: [URL])
    func didTapSendButton(request: UserProfileSendReportFlow.OnSendButton.Request)
    func didTapSendNavBarIcon(request: UserProfileSendReportFlow.OnSendButton.Request)

    func didTapAttachNavBarIcon(request: UserProfileSendReportFlow.OnDropdownMenu.Request)
    func didTapSomeDropdownMenuTitle(request: UserProfileSendReportFlow.OnDropdownMenuTitle.Request)

    func useTextOfTextViewCell(request: UserProfileSendReportFlow.OnTextViewDidChange.Request)
    func useTextAtSubjectToCopyFields(request: UserProfileSendReportFlow.Update.Request)

    func didTapXButtonAttachedCloud(request: UserProfileSendReportFlow.OnXButtonAttachedCloud.Request)
    func didTapAtFileOrFoto(request: UserProfileSendReportFlow.OnAttachedFileOrImageTapped.Request)
    func didTapDownloadIcon(request: UserProfileSendReportFlow.OnDownloadIconOrToSaveAttachedFile.Request)
    func didTapQuattroIcon(request: UserProfileSendReportFlow.OnQuattroIcon.Request)

    func didTapAddressBookIcon(request: UserProfileSendReportFlow.OnAddressIcon.Request)
}

protocol UserProfileSendReportDataStore: AnyObject {
    var imageToOpen: UIImage { get }
    var fileSize: Int? { get }
    var fileDataForOpen: Data { get }
    var fileNameWithExt: String { get }
    var arrayOfAttachmentsWithDataForRouter: [[String : Data]] { get }

    var isUserNowTakingAddressesForCopyField: Bool { get }
    var emailAddressesAtToField: Array<String> { get }
}


final class UserProfileSendReportInteractor: UserProfileSendReportBusinessLogic, UserProfileSendReportDataStore {

    // MARK: - Public properties

    var presenter: UserProfileSendReportPresentationLogic?
    var worker: UserProfileSendReportWorkingLogic?

    var imageToOpen = UIImage()
    var fileSize: Int?
    var fileDataForOpen = Data() //будет нужна при нажатии "Отправить", да??
    var fileNameWithExt = String()
    var arrayOfAttachmentsWithDataForRouter = [[String : Data]]()

    var isUserNowTakingAddressesForCopyField = true
    var emailAddressesAtToField = [String]()

    // MARK: - Private properties
    private var isAllEmailsValid: Bool?
    private var userFullName = "Асылбеков Асенбай Сарленович"
    private var userEmail = "Asilbekov.Asenbai@gmail.com"

    private var senderEmail = "some@gmail.com"
    private var recipientEmailAddressesString = "pochta@mail.ru"
    private var emailAddressesInCopy = ""
    private var updatedHtmlBody = ""
    private var emailSubject = getString(.userProfileSendReportTitleAndSubject)

    private var textInEmailTextViewCell: String?

    private lazy var signature: String = {
        let signature = UserDefaults.standard.string(forKey: GlobalConstants.userSignature) ?? ""
        return signature
    }()

    private var attachmentNamesWithExtsSet = Set<String>()
    private var hasAttachment = false
    private var isFotoAttached = false

    private var attachmentNamesAndExtForClouds = [String]()//for displaying cloud only
    private var arrayOfDictionaryNameAndDataPreviewable = [[String : Data]]() //for preview foto
    private var attachmentModelArray = [AttachmentModel]()
    private var selfHtmlInlineAttachments = [AttachmentModel]()

    // MARK: - Lifecycle
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Public methods

    func didPickFotoFromGallaryOrFileFromDocumentsAt(urls: [URL]) {
        presenter?.presentWaitIndicator(
            response: UserProfileSendReportFlow.OnWaitIndicator.Response(isShow: true))
        let group = DispatchGroup()

        for url in urls {
            group.enter()
            worker?.getFileData(url: url) { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .success(let data):
                    Log.i("Data (pickedFile) got successfully for file: \(url.lastPathComponent)")
                    appendPickedFile(fileData: data, url: url)

                case .failure(let error):
                    switch error {
                    case .fileSizeLimitExceeded(let maxSize):
                        Log.e("File size is bigger than limit - \(maxSize)")
                        presenter?.presentAlert(response: UserProfileSendReportFlow.AlertInfo.Response(
                            error: error,
                            alertAt: .attachingFiles))
                    case .other(let error):
                        Log.e("Failed to get pickedFile/data: \(error.localizedDescription)")
                        presenter?.presentAlert(response: UserProfileSendReportFlow.AlertInfo.Response(
                            error: error,
                            alertAt: nil)) //to default block (common error)
                    }
                }
                group.leave()
            }
        }

        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            presenter?.presentWaitIndicator(
                response: UserProfileSendReportFlow.OnWaitIndicator.Response(isShow: false))

            presenterPresentUpdate()
        }
    }


    func onDidLoadViews(request: UserProfileSendReportFlow.OnDidLoadViews.Request) {
        observeThemeChanging()
        observeLangChanging()

        presenterPresentUpdate()
    }

    func useTextAtSubjectToCopyFields(request: UserProfileSendReportFlow.Update.Request) {
        self.emailSubject = request.subject ?? ""
        presenterPresentUpdate()
    }

    func didTapAddressBookIcon(request: UserProfileSendReportFlow.OnAddressIcon.Request) {
        if request.isUserNowTakingAddressesForCopyField {
            isUserNowTakingAddressesForCopyField = true
        } else {
            isUserNowTakingAddressesForCopyField = false
        }
        presenter?.presentRouteToAddressBookScreen(response: UserProfileSendReportFlow.OnAddressIcon.Response())
    }

    func useTextOfTextViewCell(request: UserProfileSendReportFlow.OnTextViewDidChange.Request) {
        self.textInEmailTextViewCell = request.textInEmailTextViewCell
        makeUpdatedHtmlBody()
    }

    func didTapXButtonAttachedCloud(request: UserProfileSendReportFlow.OnXButtonAttachedCloud.Request) {
        //deleting by fileNameWithExt
        if !attachmentNamesAndExtForClouds.isEmpty {
            attachmentNamesAndExtForClouds.removeAll { $0 == request.id }
            arrayOfDictionaryNameAndDataPreviewable.removeAll { $0[request.id] != nil }

            // deleting from attachmentNames
            attachmentNamesWithExtsSet.remove(request.id)
            //for HTMLBody
            attachmentModelArray.removeAll { $0.filename == request.id }
            makeUpdatedHtmlBody()

            if attachmentNamesAndExtForClouds.isEmpty {
                hasAttachment = false
                isFotoAttached = false
            }
        } else {
            hasAttachment = false
            isFotoAttached = false
        }

        presenterPresentUpdate()
    }
    
    func didTapAtFileOrFoto(request: UserProfileSendReportFlow.OnAttachedFileOrImageTapped.Request) {
        if let image = request.fotoViewModel?.fotoImage { //tap at FotoCell
            imageToOpen = image
            fileNameWithExt = request.fotoViewModel?.fileNameWithExt.string ?? ""
            if let fotoData = arrayOfDictionaryNameAndDataPreviewable.first(where: { $0.keys.contains(fileNameWithExt) })?[fileNameWithExt] {
                fileSize = Int(Double(fotoData.count) / 1024.0)
            }
            presenter?.presentRouteToFullScreenImage(response: UserProfileSendReportFlow.OnAttachedFileOrImageTapped.Response())
        }
        //tap at CloudAttachment and check is image inside to open FullScreenImage
        if let nameAndExt = request.cloudEmailViewModel?.filenameWithExt,
           let fotoData = arrayOfDictionaryNameAndDataPreviewable.first(where: { $0.keys.contains(nameAndExt) })?[nameAndExt],
           let image = UIImage(data: fotoData) {
            imageToOpen = image
            fileNameWithExt = nameAndExt
            fileSize = Int(Double(fotoData.count) / 1024.0)

            presenter?.presentRouteToFullScreenImage(response: UserProfileSendReportFlow.OnAttachedFileOrImageTapped.Response())
        } else if let nameAndExt = request.cloudEmailViewModel?.filenameWithExt,
                  let fileData = arrayOfAttachmentsWithDataForRouter.first(where: { $0.keys.contains(nameAndExt) })?[nameAndExt] {
            fileNameWithExt = nameAndExt
            fileDataForOpen = fileData
            presenter?.presentRouteToOpenData(response: UserProfileSendReportFlow.OnAttachedFileOrImageTapped.Response())
        }
    }
    //newEmail, приложил файл, тапнул на облачко - нужно открыть файл в ином приложении? да? ведь смысла сохранять нет для письма, которое создает и хочет отправить???
    //            presenter?.presentRouteToSaveDialog(response: NewEmailCreateFlow.OnDownloadIconOrToSaveAttachedFile.Response())
//        }
    
    func didTapDownloadIcon(request: UserProfileSendReportFlow.OnDownloadIconOrToSaveAttachedFile.Request) {
        //тоже полагаю нет смысла в этой кнопке для нового письма - так? заглушить просто или убрать для нового письма???
        presenter?.presentRouteToSaveDialog(response: UserProfileSendReportFlow.OnDownloadIconOrToSaveAttachedFile.Response())
    }

    func didTapQuattroIcon(request: UserProfileSendReportFlow.OnQuattroIcon.Request) {}

    func didTapSendButton(request: UserProfileSendReportFlow.OnSendButton.Request) {
// если поле Кому не меняем, то оно устанавлено хардом и валидация на пустое поле Кому не нужна
        presenterPresentUpdate()
        makeUpdatedHtmlBody()

        if let messageModelReadyToSend = makeMessageModel(){
            worker?.createFolder(name: GlobalConstants.outgoingEmails) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success():
                    Log.i("Folder \(GlobalConstants.outgoingEmails) has been created successfully")

                    worker?.addMail(messageModelReadyToSend, toFolder: GlobalConstants.outgoingEmails) { result in
                        switch result {
                        case .success():
                            Log.i("Mail has been added to folder \(GlobalConstants.outgoingEmails) successfully")

                            self.worker?.sendMail(messageModelReadyToSend) { result in
                                switch result {
                                case .success():
                                    Log.i("func mailManager.sendMail finished successfully")

                                    self.presenter?.presentAlert(response: UserProfileSendReportFlow.AlertInfo.Response(
                                        error: nil,
                                        alertAt: .sendingEmailIsOk))

                                case .failure(let error):
                                    Log.e("func mailManager.sendMail failed, description: \(error.localizedDescription)")
                                    self.presenter?.presentAlert(response: UserProfileSendReportFlow.AlertInfo.Response(
                                        error: error,
                                        alertAt: .sendingEmailFailed))
                                }
                            }
                        case .failure(let error):
                            print("Failed to add email to folder \(GlobalConstants.outgoingEmails), description: \(error.localizedDescription)")
                        }
                    }
                case .failure(let error):
                    print("Failed to create folder \(GlobalConstants.outgoingEmails), description: \(error.localizedDescription)")
                }
            }
            presenter?.presentSending(response: UserProfileSendReportFlow.RoutePayload.Response())
        } else {
            presenter?.presentAlert(response: UserProfileSendReportFlow.AlertInfo.Response(
                error: nil,
                alertAt: .sendingEmailEmptyToField))
        }

    }

    func didTapSendNavBarIcon(request: UserProfileSendReportFlow.OnSendButton.Request) {
        didTapSendButton(request: request)
    }

    func didTapAttachNavBarIcon(request: UserProfileSendReportFlow.OnDropdownMenu.Request) {
        presenter?.presentDropdownMenu(response: UserProfileSendReportFlow.OnDropdownMenu.Response(dropDownMenuTitleCases: request.dropDownMenuTitleCases))
    }

    func didTapSomeDropdownMenuTitle(request: UserProfileSendReportFlow.OnDropdownMenuTitle.Request) {
        switch request.enumCase {
        case .attachFile:
            presenter?.presentFileDialog(response: UserProfileSendReportFlow.OnAttachBarButtonIcon.Response())
        case .pickFotoFromGallary:
            () //calling ImagePicker in Controller
        }
    }

    //MARK: - Private methods

    private func makeMessageModel() -> EmailMessageModel? {
        return EmailMessageModel(
            id: UUID().uuidString,
            from: userFullName,
            sender: userEmail,
            to: recipientEmailAddressesString,
            subject: emailSubject,
            mimeVersion: "",
            contentType: "",
            boundary: "",
            contentTransferEncoding: "",
            body: textInEmailTextViewCell ?? "",
            htmlBody: updatedHtmlBody,
            received: Date(), //поле не подходит для исходящего
            references: "",
            messageId: "",
            isPrivate: false, //в UI этой отметки нет для исходящего
            isRead: false, //поле не подходит для исходящего
            cc: [ContactMailModel()],
            bcc: [ContactMailModel()],
            replyTo: [ContactMailModel()], //какие контакты должны быть в массиве?
            attachments: attachmentModelArray,
            userAgent: "",
            htmlInlineAttachments: attachmentModelArray, //совпадает с  attachments: attachmentModelArray ??
            requiredPartsForRendering: [""])
    }

    private func moveMailToDeleted() {
        if let oneEmailMessage = makeMessageModel() {
            worker?.createFolder(name: GlobalConstants.deletedEmails) { result in
                switch result {
                case .success():
                    Log.i("Folder \(GlobalConstants.deletedEmails) has been created successfully")

                    self.worker?.addMail(oneEmailMessage, toFolder: GlobalConstants.deletedEmails) { result in
                        switch result {
                        case .success():
                            Log.i("Mail has been added to folder \(GlobalConstants.deletedEmails) successfully")
                            self.presenter?.presentRouteBack(response: UserProfileSendReportFlow.RoutePayload.Response())

                        case .failure(let error):
                            print("Failed to add email to folder \(GlobalConstants.deletedEmails), description: \(error.localizedDescription)")
                        }
                    }
                case .failure(let error):
                    print("Failed to create folder \(GlobalConstants.deletedEmails), description: \(error.localizedDescription)")
                }
            }
        }
    }

    private func moveMailToDrafts() {
        if let oneEmailMessage = makeMessageModel() {
            worker?.createFolder(name: GlobalConstants.drafts) { result in
                switch result {
                case .success():
                    Log.i("Folder \(GlobalConstants.deletedEmails) has been created successfully")

                    self.worker?.addMail(oneEmailMessage, toFolder: GlobalConstants.drafts) { result in
                        switch result {
                        case .success():
                            Log.i("Mail has been added to folder \(GlobalConstants.drafts) successfully")
                            self.presenter?.presentRouteBack(response: UserProfileSendReportFlow.RoutePayload.Response())

                        case .failure(let error):
                            print("Failed to add email to folder \(GlobalConstants.drafts), description: \(error.localizedDescription)")
                        }
                    }
                case .failure(let error):
                    print("Failed to create folder \(GlobalConstants.drafts), description: \(error.localizedDescription)")
                }
            }
        }
    }

    private func makeUpdatedHtmlBody() {
        return updatedHtmlBody = embedInlineAttachments(
            in: convertToHTMLStringFrom(plainText: textInEmailTextViewCell ?? ""),
            attachments: selfHtmlInlineAttachments)
    }

    private func convertToHTMLStringFrom(plainText: String) -> String {
        let htmlStringFromPlainText = """
        <html>
        <head>
        <style>
        body { font-family: -apple-system; }
        </style>
        </head>
        <body>
        \(plainText)
        </body>
        </html>
        """
        return htmlStringFromPlainText
    }

    private func embedInlineAttachments(in htmlBody: String, attachments: [AttachmentModel]) -> String {
        var updatedHtmlBody = htmlBody

        for attachment in attachments {
            let base64String = attachment.content.base64EncodedString(options: .lineLength64Characters)

            let fileExtension = attachment.filename.components(separatedBy: ".").last ?? ""
            let mimeType = MimeTypeManager.getMimeType(forExtension: fileExtension) ?? "application/octet-stream"

            let dataUri = "data:\(mimeType);base64,\(base64String)"
            updatedHtmlBody = updatedHtmlBody.replacingOccurrences(of: "cid:\(attachment.filename)", with: dataUri)
        }

        return updatedHtmlBody
    }

    private func appendPickedFile(fileData: Data, url: URL) {
        hasAttachment = true
        let fileNameWithExt = url.lastPathComponent

        if !attachmentNamesWithExtsSet.contains(fileNameWithExt) {
            attachmentNamesWithExtsSet.insert(fileNameWithExt)
            attachmentNamesAndExtForClouds.append(fileNameWithExt) //for displyaing clouds

            let mimeType = MimeTypeManager.getMimeType(forExtension: fileNameWithExt.components(separatedBy: ".").last ?? "") //корректно ли ?

            let oneAttachmentModel = AttachmentModel(filename: fileNameWithExt,
                                                     filenameToTemporarySave: "", //что это?
                                                     mimeType: mimeType ?? "",
                                                     size: Int(Double(fileData.count)),
                                                     content: fileData)
            attachmentModelArray.append(oneAttachmentModel)

            let oneAttachmentWithData = [fileNameWithExt: fileData]
            arrayOfAttachmentsWithDataForRouter.append(oneAttachmentWithData) //for router for OpenData

            let fileExtension = fileNameWithExt.components(separatedBy: ".").last ?? ""
            if ImageManager.isFileImagePreviewable(fileExtension: fileExtension),
               //check if already existing fileName
               !arrayOfDictionaryNameAndDataPreviewable.contains(where: { $0.keys.contains(fileNameWithExt) }) {
                isFotoAttached = true
                let oneAttachmentImagePreviewable = [fileNameWithExt: fileData]
                arrayOfDictionaryNameAndDataPreviewable.append(oneAttachmentImagePreviewable) // for preview photo
                selfHtmlInlineAttachments.append(oneAttachmentModel)
            }

            makeUpdatedHtmlBody()
        } else {
            Log.i("Пытался добавить файл \(fileNameWithExt) повторно")
        }
    }

    func presenterPresentUpdate() {
        DispatchQueue.main.async { [weak self] in
            guard let self else {return}
            presenter?.presentUpdate(response: UserProfileSendReportFlow.Update.Response(
                isImageInsideAttachment: isFotoAttached,
                hasAttachment: hasAttachment,
                arrayOfAttachmentNamesWithExt: attachmentNamesAndExtForClouds,
                arrayOfDictionaryNameAndDataPreviewable: arrayOfDictionaryNameAndDataPreviewable,

                userEmailAddress: senderEmail,
                toEmailAddress: recipientEmailAddressesString,
                subjectOfMessage: emailSubject,
                textInEmailTextViewCell: textInEmailTextViewCell,
                signature: signature))
        }
    }

    ///Light or Dark theme
    private func observeThemeChanging() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.screenThemeWasChanged,
            object: nil, queue: nil) { [weak self] _ in
                guard let self else {return}
                self.presenterPresentUpdate()
            }
    }

    ///Light or Dark theme
    private func observeLangChanging() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.languageWasChangedNotification,
            object: nil, queue: nil) { [weak self] _ in
                guard let self else {return}
                self.presenterPresentUpdate()
            }
    }

}
