//
//  NewEmailCreateInteractor.swift
//  SGTS
//
//  Created by Roman Vakulenko on 02.05.2024.
//

import Foundation
import UIKit

protocol NewEmailCreateBusinessLogic {
    func onDidLoadViews(request: NewEmailCreateFlow.OnDidLoadViews.Request)

    func didPickFotoFromGallaryOrFileFromDocumentsAt(urls: [URL])

    func didTapBackBarButton(request: AddressBookFlow.RoutePayload.Request)
    func requestForSavingDraft(request: AddressBookFlow.RoutePayload.Request)
    func saveDraftAtBackButtonTapIfNoEmpty(request: AddressBookFlow.RoutePayload.Request)

    func didTapSomeRightNavBarButton(request: NewEmailCreateFlow.OnDropdownMenu.Request)
    func didTapSomeDropdownMenuTitle(request: NewEmailCreateFlow.OnDropdownMenuTitle.Request)

    func useTextOfTextViewCell(request: NewEmailCreateFlow.OnTextViewDidChange.Request)
    func useTextAtToCopyThemeFields(request: NewEmailCreateFlow.Update.Request)
    func didTapChevronOpenCloseMoreAdressesButton(request: NewEmailCreateFlow.OnChevronTapped.Request)

    func didTapXButtonAttachedCloud(request: NewEmailCreateFlow.OnXButtonAttachedCloud.Request)
    func didTapAtFileOrFoto(request: NewEmailCreateFlow.OnAttachedFileOrImageTapped.Request)
    func didTapDownloadIcon(request: NewEmailCreateFlow.OnDownloadIconOrToSaveAttachedFile.Request)
    func didTapQuattroIcon(request: NewEmailCreateFlow.OnQuattroIcon.Request)

    func didTapSendButton(request: NewEmailCreateFlow.OnSendButton.Request)

    func didTapAddressBookIcon(request: NewEmailCreateFlow.OnAddressIcon.Request)
    func addPickedEmailsFromAddressBook(toOrCopyField: NewEmailCreateUpperModel.AddressField,
                                        pickedEmailAdresses: [String])
}

protocol NewEmailCreateDataStore: AnyObject {
    var imageToOpen: UIImage { get }
    var fileSize: Int? { get }
    var fileDataForOpen: Data { get }
    var fileNameWithExt: String { get }
    var arrayOfAttachmentsWithDataForRouter: [[String : Data]] { get }

    var isUserNowTakingAddressesForCopyField: Bool { get }
    var arrayFromRecipientEmails:  [String] { get }
    var emailAddressesAtCopyField:  [String]  { get }
    var shouldReturnToSearchContactsFromServer: Bool { get }
}


final class NewEmailCreateInteractor: NewEmailCreateBusinessLogic, NewEmailCreateDataStore {

    // MARK: - Public properties

    var presenter: NewEmailCreatePresentationLogic?
    var worker: NewEmailCreateWorkingLogic?

    var imageToOpen = UIImage()
    var fileSize: Int?
    var fileDataForOpen = Data() //будет нужна при нажатии "Отправить", да??
    var fileNameWithExt = String()
    var arrayOfAttachmentsWithDataForRouter = [[String : Data]]()

    var isUserNowTakingAddressesForCopyField = true
    var arrayFromRecipientEmails = [String]()
    var emailAddressesAtCopyField = [String]()
    var shouldReturnToSearchContactsFromServer = false

    // MARK: - Private properties

    private var isEmptyViewVisible = false

    private var userFullName = "Асылбеков Асенбай Сарленович"
    private var userEmail = "Asilbekov.Asenbai@gmail.com"
    private var recipientEmailsStringFromToField = ""
    private var stringOfEmailsFromCopyField = ""
    private var emailSubject = ""
    private var isAllEmailsValid: Bool?

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
    private var updatedHtmlBody = ""
    private var messageModel: EmailMessageModel?
    private var emailType: NewEmailCreateModels.NewReOrFwdEmailType = .newEmail

    private var allContactMailModelSet: Set<ContactMailModel> = []
    private var dictOfContactMailModelForCC: Dictionary<String, String> = [:]
    private var cc = [ContactMailModel]()
    private var bcc = [ContactMailModel]()

    // MARK: - Lifecycle
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    init(messageModel: EmailMessageModel?,
         pickedEmailAddresses: [String]?,
         emailType: NewEmailCreateModels.NewReOrFwdEmailType) {
        self.messageModel = messageModel

        if let emailsAtCopyField = pickedEmailAddresses {
            self.recipientEmailsStringFromToField = emailsAtCopyField.compactMap { $0 }.joined(separator: ", ")
        } else {
            switch emailType {
            case .newEmail:
                ()
            case .reply:
                self.recipientEmailsStringFromToField = messageModel?.sender ?? ""
            case .replyAll:
                self.recipientEmailsStringFromToField = messageModel?.sender ?? ""
                if let emailsArrayFromCopyField = messageModel?.cc.map({ $0.mailbox }) {
                    self.stringOfEmailsFromCopyField = makeStringOfFineEmailsFrom(validatedArray: emailsArrayFromCopyField) //From "Copy" to "Copy"
                }
            case .forward:
                self.recipientEmailsStringFromToField = ""
                transferAttachmentsToThisEmail()
            }
        }

        self.emailSubject = messageModel?.subject ?? ""
        self.emailType = emailType
    }

    // MARK: - Public methods

    func didTapBackBarButton(request: AddressBookFlow.RoutePayload.Request) {
        arrayFromRecipientEmails = recipientEmailsStringFromToField.convertToArray()
        shouldReturnToSearchContactsFromServer = true
        presenter?.presentRouteToAddressBookScreen(response: NewEmailCreateFlow.OnAddressIcon.Response())
    }

    func requestForSavingDraft(request: AddressBookFlow.RoutePayload.Request) {
        if recipientEmailsStringFromToField != "" ||
           stringOfEmailsFromCopyField != "" ||
           emailSubject != "" ||
            textInEmailTextViewCell != getString(.newEmailCreateTextViewPlaceholder) || textInEmailTextViewCell != "" {
            self.presenter?.presentAlert(response: NewEmailCreateFlow.AlertInfo.Response(
                error: nil,
                alertAt: .saveAsDraftOrNot))
        }
    }

    func saveDraftAtBackButtonTapIfNoEmpty(request: AddressBookFlow.RoutePayload.Request) {
        for email in stringOfEmailsFromCopyField.convertToArray() {
            if let existingContact = allContactMailModelSet.first(where: { $0.mailbox == email }) {
                dictOfContactMailModelForCC[existingContact.mailbox] = existingContact.displayName
            } else {
                dictOfContactMailModelForCC[email] = ""
            }
        }
        presenterPresentUpdate()
        makeUpdatedHtmlBody()

        if let messageModelReadyToSend = makeMessageModel() {
            worker?.createFolder(name: GlobalConstants.drafts) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success():
                    Log.i("Folder \(GlobalConstants.drafts) has been created successfully")

                    worker?.addMail(messageModelReadyToSend, toFolder: GlobalConstants.drafts) { result in
                        switch result {
                        case .success():
                            Log.i("Mail has been added to folder \(GlobalConstants.drafts) successfully")

                            self.presenter?.presentRouteBack(response: NewEmailCreateFlow.RoutePayload.Response())

                        case .failure(let error):
                            print("Failed to add email to folder \(GlobalConstants.outgoingEmails), description: \(error.localizedDescription)")
                        }
                    }
                case .failure(let error):
                    print("Failed to create folder \(GlobalConstants.outgoingEmails), description: \(error.localizedDescription)")
                }
            }
        } else {
            presenter?.presentAlert(response: NewEmailCreateFlow.AlertInfo.Response(
                error: nil,
                alertAt: .savingAsDraft))
        }
    }



    func didPickFotoFromGallaryOrFileFromDocumentsAt(urls: [URL]) {
        presenter?.presentWaitIndicator(
            response: NewEmailCreateFlow.OnWaitIndicator.Response(isShow: true))
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
                        presenter?.presentAlert(response: NewEmailCreateFlow.AlertInfo.Response(
                            error: error,
                            alertAt: .attachingFiles))
                    case .other(let error):
                        Log.e("Failed to get pickedFile/data: \(error.localizedDescription)")
                        presenter?.presentAlert(response: NewEmailCreateFlow.AlertInfo.Response(
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
                response: NewEmailCreateFlow.OnWaitIndicator.Response(isShow: false))

            presenterPresentUpdate()
        }
    }

    func onDidLoadViews(request: NewEmailCreateFlow.OnDidLoadViews.Request) {
        observeThemeChanging()
        observeLangChanging()

        isEmptyViewVisible = request.isEmptyViewVisible //for lang & theme observing

        worker?.getAllContacts(){ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let contacts):
                Log.i("Contacts got successfully")

                // gives faster filter of entered contacts
                allContactMailModelSet = Set(contacts.map { contact in
                    ContactMailModel(
                        displayName: contact.cn,
                        mailbox: contact.email.lowercased())
                })

            case .failure(let failure):
                Log.e(failure.localizedDescription)
                presenter?.presentAlert(response: NewEmailCreateFlow.AlertInfo.Response(error: failure, alertAt: .gettingAllContactListItems))
            }
        }
        presenterPresentUpdate()
    }

    func useTextAtToCopyThemeFields(request: NewEmailCreateFlow.Update.Request) {
        self.recipientEmailsStringFromToField = request.toEmailAddress ?? ""
        self.stringOfEmailsFromCopyField = request.copyEmailAddresses ?? ""
        self.emailSubject = request.subjectOfMessage ?? ""

        arrayFromRecipientEmails = recipientEmailsStringFromToField.convertToArray()
        emailAddressesAtCopyField = stringOfEmailsFromCopyField.convertToArray()

        presenterPresentUpdate()
    }

    func didTapAddressBookIcon(request: NewEmailCreateFlow.OnAddressIcon.Request) {
        if request.isUserNowTakingAddressesForCopyField {
            isUserNowTakingAddressesForCopyField = true
        } else {
            arrayFromRecipientEmails = recipientEmailsStringFromToField.convertToArray()
            isUserNowTakingAddressesForCopyField = false
        }
        presenter?.presentRouteToAddressBookScreen(response: NewEmailCreateFlow.OnAddressIcon.Response())
    }

    func addPickedEmailsFromAddressBook(toOrCopyField: NewEmailCreateUpperModel.AddressField,
                                        pickedEmailAdresses: [String]) {
        switch toOrCopyField {
        case .toField:
            arrayFromRecipientEmails = pickedEmailAdresses
            isUserNowTakingAddressesForCopyField = false
            recipientEmailsStringFromToField = arrayFromRecipientEmails.compactMap { $0 }.joined(separator: ", ")

        case .copyField:
            emailAddressesAtCopyField = pickedEmailAdresses
            isUserNowTakingAddressesForCopyField = true
            stringOfEmailsFromCopyField = emailAddressesAtCopyField.compactMap { $0 }.joined(separator: ", ")

            //for making "cc" property of EmailMessageModel
            for pickedEmail in pickedEmailAdresses {
                if let contact = allContactMailModelSet.first(where: { $0.mailbox == pickedEmail }) {
                    dictOfContactMailModelForCC[contact.mailbox] = contact.displayName
                }
            }
        }

        presenterPresentUpdate()
    }

    func useTextOfTextViewCell(request: NewEmailCreateFlow.OnTextViewDidChange.Request) {
        self.textInEmailTextViewCell = request.textInEmailTextViewCell
        makeUpdatedHtmlBody()
    }

    func didTapChevronOpenCloseMoreAdressesButton(request: NewEmailCreateFlow.OnChevronTapped.Request) {
        self.isEmptyViewVisible = request.isEmptyViewVisible
        presenterPresentUpdate()
    }

    func didTapXButtonAttachedCloud(request: NewEmailCreateFlow.OnXButtonAttachedCloud.Request) {
        //deleting by fileNameWithExt
        if !attachmentNamesAndExtForClouds.isEmpty {
            attachmentNamesAndExtForClouds.removeAll { $0 == request.id }
            arrayOfDictionaryNameAndDataPreviewable.removeAll { $0[request.id] != nil }

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

    func didTapAtFileOrFoto(request: NewEmailCreateFlow.OnAttachedFileOrImageTapped.Request) {
        if let image = request.fotoViewModel?.fotoImage { //tap at FotoCell
            imageToOpen = image
            fileNameWithExt = request.fotoViewModel?.fileNameWithExt.string ?? ""
            if let fotoData = arrayOfDictionaryNameAndDataPreviewable.first(where: { $0.keys.contains(fileNameWithExt) })?[fileNameWithExt] {
                fileSize = Int(Double(fotoData.count) / 1024.0)
            }
            presenter?.presentRouteToFullScreenImage(response: NewEmailCreateFlow.OnAttachedFileOrImageTapped.Response())
        }

        //tap at CloudAttachment and check is image inside to open FullScreenImage
        if let nameAndExt = request.cloudEmailViewModel?.filenameWithExt,
           let fotoData = arrayOfDictionaryNameAndDataPreviewable.first(where: { $0.keys.contains(nameAndExt) })?[nameAndExt],
           let image = UIImage(data: fotoData) {
            imageToOpen = image
            fileNameWithExt = nameAndExt
            fileSize = Int(Double(fotoData.count) / 1024.0)

            presenter?.presentRouteToFullScreenImage(response: NewEmailCreateFlow.OnAttachedFileOrImageTapped.Response())
        } else if let nameAndExt = request.cloudEmailViewModel?.filenameWithExt,
                  let fileData = arrayOfAttachmentsWithDataForRouter.first(where: { $0.keys.contains(nameAndExt) })?[nameAndExt] {
            fileNameWithExt = nameAndExt
            fileDataForOpen = fileData
            presenter?.presentRouteToOpenData(response: NewEmailCreateFlow.OnAttachedFileOrImageTapped.Response())
        }
    }
    //newEmail, приложил файл, тапнул на облачко - нужно открыть файл в ином приложении? да? ведь смысла сохранять нет для письма, которое создает и хочет отправить???
    //            presenter?.presentRouteToSaveDialog(response: NewEmailCreateFlow.OnDownloadIconOrToSaveAttachedFile.Response())
    //        }

    func didTapDownloadIcon(request: NewEmailCreateFlow.OnDownloadIconOrToSaveAttachedFile.Request) {
        //тоже полагаю нет смысла в этой кнопке для нового письма - так? заглушить просто или убрать для нового письма?????
        presenter?.presentRouteToSaveDialog(response: NewEmailCreateFlow.OnDownloadIconOrToSaveAttachedFile.Response())
    }

    func didTapQuattroIcon(request: NewEmailCreateFlow.OnQuattroIcon.Request) {}

    func didTapSendButton(request: NewEmailCreateFlow.OnSendButton.Request) {
        //do array from string (from fields)
        let arrayFromRecipientEmails = recipientEmailsStringFromToField.convertToArray()
        let emailAddressesAtCopyField = stringOfEmailsFromCopyField.convertToArray()

        let fineRecipientEmailsArray = validateEmails(arrayFromRecipientEmails, at: .fillingFieldTo)
        let fineCopyEmailsArray = validateEmails(emailAddressesAtCopyField, at: .fillingFieldCopy)

        recipientEmailsStringFromToField = makeStringOfFineEmailsFrom(validatedArray: fineRecipientEmailsArray)
        stringOfEmailsFromCopyField = makeStringOfFineEmailsFrom(validatedArray: fineCopyEmailsArray)

        for email in stringOfEmailsFromCopyField.convertToArray() {
            if let existingContact = allContactMailModelSet.first(where: { $0.mailbox == email }) {
                dictOfContactMailModelForCC[existingContact.mailbox] = existingContact.displayName
            } else {
                dictOfContactMailModelForCC[email] = ""
            }
        }
        presenterPresentUpdate()
        makeUpdatedHtmlBody()

        if let messageModelReadyToSend = makeMessageModel(),
           isAllEmailsValid == true,
           !fineRecipientEmailsArray.isEmpty {
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

                                    self.presenter?.presentAlert(response: NewEmailCreateFlow.AlertInfo.Response(
                                        error: nil,
                                        alertAt: .sendingEmailIsOk))

                                case .failure(let error):
                                    Log.e("func mailManager.sendMail failed, description: \(error.localizedDescription)")
                                    self.presenter?.presentAlert(response: NewEmailCreateFlow.AlertInfo.Response(
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
            self.presenter?.presentSending(response: NewEmailCreateFlow.RoutePayload.Response())
        } else {
            presenter?.presentAlert(response: NewEmailCreateFlow.AlertInfo.Response(
                error: nil,
                alertAt: .sendingEmailEmptyToField))
        }
    }

    func didTapSendNavBarIcon(request: NewEmailCreateFlow.OnSendButton.Request) {
        didTapSendButton(request: request)
    }

    func didTapSomeRightNavBarButton(request: NewEmailCreateFlow.OnDropdownMenu.Request) {
        presenter?.presentDropdownMenu(response: NewEmailCreateFlow.OnDropdownMenu.Response(
            menuID: request.menuID,
            dropDownMenuTitleCases: request.dropDownMenuTitleCases))
    }

    func didTapSomeDropdownMenuTitle(request: NewEmailCreateFlow.OnDropdownMenuTitle.Request) {
        switch request.enumCase {
        case .attachFile:
            presenter?.presentFileDialog(response: NewEmailCreateFlow.OnAttachBarButtonIcon.Response())
        case .deleteMail:
            //if email is empty
            if recipientEmailsStringFromToField == "",
               stringOfEmailsFromCopyField == "",
               emailSubject == "" {
                presenter?.presentRouteBack(response: NewEmailCreateFlow.RoutePayload.Response())
            } else {
                moveMailToDeleted()
            }
        case .saveDraft:
            moveMailToDrafts()
        case .pickFotoFromGallary:
            () //calling ImagePicker in Controller
        }
    }

    //MARK: - Private methods
    private func createContactModelArray() -> [ContactMailModel] {
        for email in stringOfEmailsFromCopyField.convertToArray() {
            if let existingContact = allContactMailModelSet.first(where: { $0.mailbox == email }) {
                dictOfContactMailModelForCC[existingContact.mailbox] = existingContact.displayName
            } else {
                dictOfContactMailModelForCC[email] = ""
            }
        }

        let contactMailModelArrayForCC: [ContactMailModel] = dictOfContactMailModelForCC.map { (mailbox, displayName) in
            ContactMailModel(displayName: displayName, mailbox: mailbox)
        }
        return contactMailModelArrayForCC
    }

    private func makeMessageModel() -> EmailMessageModel? {
        return EmailMessageModel(
            id: UUID().uuidString,
            from: userFullName,
            sender: userEmail,
            to: recipientEmailsStringFromToField,
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
            cc: createContactModelArray(),
            bcc: [ContactMailModel()],
            replyTo: [ContactMailModel()], //какие контакты должны быть в массиве?
            attachments: attachmentModelArray,
            userAgent: "",
            htmlInlineAttachments: selfHtmlInlineAttachments,
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
                            self.presenter?.presentRouteBack(response: NewEmailCreateFlow.RoutePayload.Response())

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
                            self.presenter?.presentRouteBack(response: NewEmailCreateFlow.RoutePayload.Response())

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


    private func transferAttachmentsToThisEmail() {
        if let messageModel = messageModel {
            //fill attachmentModelArray, selfHtmlInlineAttachments, attachmentNamesWithExtsSet
            hasAttachment = !messageModel.attachments.isEmpty
            attachmentNamesAndExtForClouds = messageModel.attachments.map { $0.filename }

            attachmentModelArray = messageModel.attachments
            for attachment in attachmentModelArray {
                attachmentNamesWithExtsSet.insert(attachment.filename)

                let oneAttachmentImagePreviewable = [attachment.filename: attachment.content]
                arrayOfAttachmentsWithDataForRouter.append(oneAttachmentImagePreviewable)

                let fileExtension = attachment.filename.components(separatedBy: ".").last ?? ""
                if ImageManager.isFileImagePreviewable(fileExtension: fileExtension) {
                    arrayOfDictionaryNameAndDataPreviewable.append(oneAttachmentImagePreviewable) //for preview foto
                }
            }

            selfHtmlInlineAttachments = messageModel.htmlInlineAttachments
            for htmlInlineAttachment in selfHtmlInlineAttachments {
                let fileExtension = htmlInlineAttachment.filename.components(separatedBy: ".").last ?? ""
                if ImageManager.isFileImagePreviewable(fileExtension: fileExtension) {
                    isFotoAttached = true
                    break // because isFotoAttached = true
                }
            }

            for htmlInlineAttachment in messageModel.htmlInlineAttachments {
                attachmentNamesWithExtsSet.insert(htmlInlineAttachment.filename)

                let fileExtension = htmlInlineAttachment.filename.components(separatedBy: ".").last ?? ""
                if ImageManager.isFileImagePreviewable(fileExtension: fileExtension),
                   //check if already existing fileName
                   !arrayOfDictionaryNameAndDataPreviewable.contains(where: { $0.keys.contains(htmlInlineAttachment.filename) }) {
                    let oneAttachmentImagePreviewable = [htmlInlineAttachment.filename: htmlInlineAttachment.content]
                    arrayOfDictionaryNameAndDataPreviewable.append(oneAttachmentImagePreviewable) // for preview photo
                }
            }
        }
        presenterPresentUpdate()
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

    // Родион создавал ранее в OneEmailDetailsInteractor
    //    private  func embedInlineAttachments(in htmlBody: String, attachments: [AttachmentModel]) -> String {
    //        var updatedHtmlBody = htmlBody
    //
    //        for attachment in attachments {
    //            let base64String = attachment.content.base64EncodedString(options: .lineLength64Characters)
    //                let mimeType: String
    //                switch attachment.mimeType.lowercased() {
    //                case "image/png":
    //                    mimeType = "image/png"
    //                case "image/jpeg":
    //                    mimeType = "image/jpeg"
    //                default:
    //                    mimeType = "application/octet-stream"
    //                }
    //
    //                let dataUri = "data:\(mimeType);base64,\(base64String)"
    //                updatedHtmlBody = updatedHtmlBody.replacingOccurrences(of: "cid:\(attachment.filename)", with: dataUri)
    //
    //        }
    //
    //        return updatedHtmlBody
    //    }

    private func validateEmails(_ emails: [String], at field: NewEmailCreateModels.AlertAtOrCase) -> [String] {
        var validEmails = [String]()

        for email in emails {
            if email.isEmailValid {
                validEmails.append(email)
            } else {
                isAllEmailsValid = false
                presenter?.presentAlert(response: NewEmailCreateFlow.AlertInfo.Response(error: nil, alertAt: field))
                return emails
            }
        }
        isAllEmailsValid = true
        return validEmails
    }

    private func makeStringOfFineEmailsFrom(validatedArray: [String]) -> String {
        return validatedArray.joined(separator: ", ")
    }

    func presenterPresentUpdate() {
        DispatchQueue.main.async { [weak self] in
            guard let self else {return}
            presenter?.presentUpdate(response: NewEmailCreateFlow.Update.Response(
                isImagePreviewable: isFotoAttached,
                hasAttachment: hasAttachment,
                isEmptyViewVisible: isEmptyViewVisible,
                arrayOfAttachmentNamesWithExt: attachmentNamesAndExtForClouds,
                arrayOfDictionaryNameAndDataPreviewable: arrayOfDictionaryNameAndDataPreviewable,

                fromEmailAddressText: userEmail,
                toEmailAddress: recipientEmailsStringFromToField,
                copyEmailAdresses: stringOfEmailsFromCopyField,
                subjectOfMessage: emailSubject,
                textInEmailTextViewCell: textInEmailTextViewCell,
                emailType: emailType,
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
