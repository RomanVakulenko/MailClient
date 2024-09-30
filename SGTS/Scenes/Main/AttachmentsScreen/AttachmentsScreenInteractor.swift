//
//  AttachmentsScreenInteractor.swift
//  SGTS
//
//  Created by Roman Vakulenko on 12.06.2024.
//

import Foundation
import UIKit

protocol AttachmentsScreenBusinessLogic {
    func onDidLoadViews(request: AttachmentsScreenFlow.OnDidLoadViews.Request)
    func onSelectItem(request: AttachmentsScreenFlow.OnSelectItem.Request)
    func didTapSearchBarIcon(request: AttachmentsScreenFlow.OnSearchBarIconTap.Request)
    func didTapSideMenuBarButton(request: AttachmentsScreenFlow.OnBurgerMenuTap.Request)
    func filterAttachmentsWithSearchText(request: AttachmentsScreenFlow.OnSearchBarIconTap.Request)

    var urlsOfDataForAttachmentsInCache: [URL] { get }
}

protocol AttachmentsScreenDataStore: AnyObject {
    var oneAttachmentToOpenInOtheApp: AttachmentCellModelFromDatabase? { get }
    var urlsOfDataForAttachmentsInCache: [URL] { get }
}

final class AttachmentsScreenInteractor: AttachmentsScreenBusinessLogic, AttachmentsScreenDataStore {

    // MARK: - Public properties

    var presenter: AttachmentsScreenPresentationLogic?
    var worker: AttachmentsScreenWorkingLogic?
    
    // MARK: - Lifecycle
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Private properties

    private var isSearchBarDisplaying = false

    private var attachments = [AttachmentCellModelFromDatabase]()
    private var filteredAttachments: [AttachmentCellModelFromDatabase] = []

    var oneAttachmentToOpenInOtheApp: AttachmentCellModelFromDatabase?
    var urlsOfDataForAttachmentsInCache: [URL] = []

    // MARK: - Public methods

    func onDidLoadViews(request: AttachmentsScreenFlow.OnDidLoadViews.Request) {
        observeThemeChanging()
        observeLangChanging()

        getAttachmentsList ()
    }

    func onSelectItem(request: AttachmentsScreenFlow.OnSelectItem.Request) {
        getOneAttachmentFileDataWith(attachmentId: request.id)
    }

    func didTapSearchBarIcon(request: AttachmentsScreenFlow.OnSearchBarIconTap.Request) {
        self.isSearchBarDisplaying = request.isSearchBarDisplaying

        presenter?.presentSearchBar(response: AttachmentsScreenFlow.OnSearchBarIconTap.Response(
            searchText: nil,
            isSearchBarDisplaying: isSearchBarDisplaying,
            filteredAttachments: nil))
    }

    func didTapSideMenuBarButton(request: AttachmentsScreenFlow.OnBurgerMenuTap.Request) {
        presenter?.presentRouteToSideMenu(response: AttachmentsScreenFlow.RoutePayload.Response())
    }

    func filterAttachmentsWithSearchText(request: AttachmentsScreenFlow.OnSearchBarIconTap.Request) {
        let text = request.searchText
        guard let searchingText = text else { return }

        if !searchingText.isEmpty {
            filteredAttachments = attachments.filter { attachment in //возвращает новую коллекцию
                let filterByFileNameAndExtension = attachment.fileNameWithExt.lowercased().contains(searchingText)
                let filterByAuthorNameAndSurnname = attachment.nameAndSurname.lowercased().contains(searchingText)
                return filterByFileNameAndExtension || filterByAuthorNameAndSurnname
            }
            presenter?.presentUpdate(response: AttachmentsScreenFlow.Update.Response(attachments: filteredAttachments))
        } else if searchingText == "" {
            presenter?.presentUpdate(response: AttachmentsScreenFlow.Update.Response(attachments: attachments))
        }
    }



    //MARK: - Private methods

    private func getAttachmentsList () {
        attachments = mockAttachments//TODO: временно
        presenter?.presentUpdate(response: AttachmentsScreenFlow.Update.Response(
            attachments: attachments))//TODO: временно

        worker?.getAllAttachmentsList() { [weak self] result in
            guard let self else {return}

            switch result {
            case .success(_): //listOfAttachments):
                Log.i("[attachmentsArray] got successfully")
//                attachments = listOfAttachments //TODO: когда будет метод в Database
                presenter?.presentUpdate(response: AttachmentsScreenFlow.Update.Response(
                    attachments: attachments))
            case .failure(let error):
                Log.e("Failed to get email data: \(error.localizedDescription)")
                presenter?.presentAlert(response: AttachmentsScreenFlow.AlertInfo.Response(error: error))
            }
        }
    }

    private func getOneAttachmentFileDataWith(attachmentId: String) {
        var attachmentWithData: AttachmentCellModelFromDatabase? //TODO: временно

        for attachment in attachments { //TODO: временно
            if attachment.attachmentLUID == attachmentId {
                attachmentWithData = attachment
                attachmentWithData?.fileData = Data()
                oneAttachmentToOpenInOtheApp = attachmentWithData
            }
        }

        if let attachmentForSave = oneAttachmentToOpenInOtheApp {
            oneAttachmentToOpenInOtheApp?.urlInProgrammsDirectory = saveFileInCache(attachment: attachmentForSave)
            if let urlInCache = oneAttachmentToOpenInOtheApp?.urlInProgrammsDirectory {
                urlsOfDataForAttachmentsInCache.append(urlInCache)
            }
        }

        presenter?.presentRouteToOpenAttachmentInOtherApp(response: AttachmentsScreenFlow.OnSelectItem.Response()) //TODO: временно
        #warning("из-за завершения проекта этот код не был дописан по согласованию")
//        worker?.getAttachmentFileDataWith(attachmentLUID: attachmentId) { [weak self] result in
//            guard let self else {return}
//
//            switch result {
//            case .success(let fileDataOfOneAttachment):
//                Log.i("[MailData] got successfully")
//                
//                var attachmentWithData: AttachmentCellModelFromDatabase?
//
//                for attachment in attachments {
//                    if attachment.attachmentLUID == attachmentId {
//                        attachmentWithData = attachment
//                        attachmentWithData?.fileData = fileDataOfOneAttachment
//                        oneAttachmentToOpenInOtheApp = attachmentWithData
//                    }
//                }
//                presenter?.presentRouteToOpenAttachmentInOtherApp(response: AttachmentsScreenFlow.OnSelectItem.Response())
//            case .failure(_):
//                Log.i("Some error")
//                //                presenter?.presentAlert(response: AttachmentsScreenFlow.AlertInfo.Response())
//            }
//        }
    }

    
    private func saveFileInCache(attachment: AttachmentCellModelFromDatabase) -> URL? {
        let fileManager = FileManager.default
        guard let cacheURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = cacheURL.appendingPathComponent(attachment.fileNameWithExt)

        do {
            try attachment.fileData?.write(to: fileURL)
            return fileURL
        } catch {
            Log.i("Error saving file to cache: \(error)")
        }
        return nil
    }

    ///Light or Dark theme
    private func observeThemeChanging() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.screenThemeWasChanged,
            object: nil, queue: nil) { [weak self] _ in
                guard let self else {return}
                self.presenter?.presentUpdate(response: AttachmentsScreenFlow.Update.Response(attachments: attachments)
                )
            }
    }

    private func observeLangChanging() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.languageWasChangedNotification,
            object: nil, queue: nil) { [weak self] _ in
                guard let self else {return}
                self.presenter?.presentUpdate(response: AttachmentsScreenFlow.Update.Response(attachments: attachments)
                )
            }
    }
}


var mockAttachments: [AttachmentCellModelFromDatabase] = [
    AttachmentCellModelFromDatabase(
        attachmentLUID: "1234567890",
        urlInProgrammsDirectory: nil,
        fileData: nil,
        fileNameWithExt: "audio.mp3",
        nameAndSurname: "Иван Макаров",
        downloadingDate: "11 июля 2024",
        downloadingSize: "121"
    ),
    AttachmentCellModelFromDatabase(
        attachmentLUID: "1234567891",
        urlInProgrammsDirectory: nil,
        fileData: nil,
        fileNameWithExt: "doc.docx",
        nameAndSurname: "Петр Петров",
        downloadingDate: "12 июля 2024",
        downloadingSize: "1200"
    ),
    AttachmentCellModelFromDatabase(
        attachmentLUID: "1234567892",
        urlInProgrammsDirectory: nil,
        fileData: nil,
        fileNameWithExt: "fileData.doc",
        nameAndSurname: "Сергей Сергеев",
        downloadingDate: "13 июля 2024",
        downloadingSize: "102"
    ),
    AttachmentCellModelFromDatabase(
        attachmentLUID: "1234567893",
        urlInProgrammsDirectory: nil,
        fileData: nil,
        fileNameWithExt: "img.png",
        nameAndSurname: "Мария Маркова",
        downloadingDate: "14 июля 2024",
        downloadingSize: "1500"
    ),
    AttachmentCellModelFromDatabase(
        attachmentLUID: "1234567894",
        urlInProgrammsDirectory: nil,
        fileData: nil,
        fileNameWithExt: "jpg.jpg",
        nameAndSurname: "Василий Васильев",
        downloadingDate: "15 июля 2024",
        downloadingSize: "2100"
    ),
    AttachmentCellModelFromDatabase(
        attachmentLUID: "1234567895",
        urlInProgrammsDirectory: nil,
        fileData: nil,
        fileNameWithExt: "pdf.pdf",
        nameAndSurname: "Екатерина Екатерина",
        downloadingDate: "16 июля 2024",
        downloadingSize: "1800"
    ),
    AttachmentCellModelFromDatabase(
        attachmentLUID: "1234567896",
        urlInProgrammsDirectory: nil,
        fileData: nil,
        fileNameWithExt: "video.mp4",
        nameAndSurname: "Алексей Алексеев",
        downloadingDate: "17 июля 2024",
        downloadingSize: "3500"
    ),
    AttachmentCellModelFromDatabase(
        attachmentLUID: "1234567897",
        urlInProgrammsDirectory: nil,
        fileData: nil,
        fileNameWithExt: "xls.xls",
        nameAndSurname: "Николай Николаев",
        downloadingDate: "18 июля 2024",
        downloadingSize: "1100"
    ),
    AttachmentCellModelFromDatabase(
        attachmentLUID: "1234567898",
        urlInProgrammsDirectory: nil,
        fileData: nil,
        fileNameWithExt: "audio.mp3",
        nameAndSurname: "Иван Иванов",
        downloadingDate: "19 июля 2024",
        downloadingSize: "121"
    ),
    AttachmentCellModelFromDatabase(
        attachmentLUID: "1234567899",
        urlInProgrammsDirectory: nil,
        fileData: nil,
        fileNameWithExt: "doc.docx",
        nameAndSurname: "Петр Петров",
        downloadingDate: "20 июля 2024",
        downloadingSize: "1200"
    ),
    AttachmentCellModelFromDatabase(
        attachmentLUID: "12345678910",
        urlInProgrammsDirectory: nil,
        fileData: nil,
        fileNameWithExt: "fileData.doc",
        nameAndSurname: "Сергей Сергеев",
        downloadingDate: "21 июля 2024",
        downloadingSize: "102"
    ),
    AttachmentCellModelFromDatabase(
        attachmentLUID: "12345678911",
        urlInProgrammsDirectory: nil,
        fileData: nil,
        fileNameWithExt: "img.png",
        nameAndSurname: "Мария Маркова",
        downloadingDate: "22 июля 2024",
        downloadingSize: "1500"
    ),
    AttachmentCellModelFromDatabase(
        attachmentLUID: "12345678912",
        urlInProgrammsDirectory: nil,
        fileData: nil,
        fileNameWithExt: "jpg.jpg",
        nameAndSurname: "Василий Васильев",
        downloadingDate: "23 июля 2024",
        downloadingSize: "2100"
    ),
    AttachmentCellModelFromDatabase(
        attachmentLUID: "12345678913",
        urlInProgrammsDirectory: nil,
        fileData: nil,
        fileNameWithExt: "pdf.pdf",
        nameAndSurname: "Екатерина Екатерина",
        downloadingDate: "24 июля 2024",
        downloadingSize: "1800"
    ),
    AttachmentCellModelFromDatabase(
        attachmentLUID: "12345678914",
        urlInProgrammsDirectory: nil,
        fileData: nil,
        fileNameWithExt: "video.mp4",
        nameAndSurname: "Алексей Алексеев",
        downloadingDate: "25 июля 2024",
        downloadingSize: "3500"
    )
]
