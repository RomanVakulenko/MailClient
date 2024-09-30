//
//  EmailPickingScreenInteractor.swift
//  SGTS
//
//  Created by Roman Vakulenko on 20.05.2024.
//

import Foundation
import UIKit

protocol EmailPickingScreenBusinessLogic {
    func onDidLoadViews(request: EmailPickingScreenFlow.OnDidLoadViews.Request)
    func onSelectItem(request: EmailPickingScreenFlow.OnSelectItem.Request)

    func didTapBackArrow()
    func didTapPickAllBox(request: EmailPickingScreenFlow.Update.Request)

    func didTapArchiveNavBarIcon(request: EmailPickingScreenFlow.MovingTo.Request)
    func didTapTrashOrArchiveNavBarIcon(request: EmailPickingScreenFlow.MovingTo.Request)
    func transferEmails(request: EmailPickingScreenFlow.MovingTo.Request)

    func markAsUnread(request: EmailPickingScreenFlow.OnEnvelopNavBarButton.Request)

    func didTapThreeDotsNavBarIcon(request: EmailPickingScreenFlow.OnDropdownMenu.Request)
    func didTapTitleOfThreeDotsDropdownMenu(request: EmailPickingScreenFlow.OnDropdownMenuTitle.Request)
}

protocol EmailPickingScreenDataStore: AnyObject {
    var storedIdsOfPickedEmails: Set<String>? { get }
}

final class EmailPickingScreenInteractor: EmailPickingScreenBusinessLogic, EmailPickingScreenDataStore {

    // MARK: - Public properties

    var presenter: EmailPickingScreenPresentationLogic?
    var worker: EmailPickingScreenWorkingLogic?
    var storedIdsOfPickedEmails: Set<String>? {
        get { pickedEmailIdsSet }
        set { pickedEmailIdsSet = newValue ?? Set() }
    }

    // MARK: - Private properties
//    private var isNewLetter = true // default, untill not read
//    private var isPersonalToUserIconDisplaying = true
//    private var isEmportantEmailIndicatorDisplaying = true
//    private var isExternalEmailIconDisplaying = true
//    private var hasAttachment = true

    private var pickedMailsFromDataBase = [EmailMessageModel]()
//    private var oneMailFromDB: EmailMessageModel?

    private var mailsForDisplay: [EmailMessageWithNeededProperties]
    private var messageTypeFromSideMenu: TabBarManager.MessageType
    private var pickedEmailIdsSet = Set<String>()
    private var isAllEmailsPicked = false
    private var isOnlyOneEmailPicked: Bool {
        if pickedEmailIdsSet.count == 1 {
            return true
        } else {
            return false
        }
    }

    private let dropDownMenuTitleCasesForOnePickedEmail: [EmailPickingScreenModel.DropdownMenuTitle] = [.reply, .replyToAll, .forward, .moveTo]
    private let dropDownMenuTitleCasesForSomePickedEmail: [EmailPickingScreenModel.DropdownMenuTitle] = [.markAsRead, .markAsUnread, .moveTo]
    private var dropDownMenuTitleCases: [EmailPickingScreenModel.DropdownMenuTitle] = []


    // MARK: - Lifecycle
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    init(pickedEmailId: String,
         mailsForDisplay: [EmailMessageWithNeededProperties],
         messageTypeFromSideMenu: TabBarManager.MessageType) {
        self.pickedEmailIdsSet.insert(pickedEmailId)
        self.mailsForDisplay = mailsForDisplay
        self.messageTypeFromSideMenu = messageTypeFromSideMenu
    }

    // MARK: - Public methods

    func onDidLoadViews(request: EmailPickingScreenFlow.OnDidLoadViews.Request) {
        observeThemeChanging()
        observeLangChanging()
        dropDownMenuTitleCases = dropDownMenuTitleCasesForOnePickedEmail

        presenterUpdate()
    }

    func onSelectItem(request: EmailPickingScreenFlow.OnSelectItem.Request) {
        guard let pickedEmailId = request.pickedEmailId else {return}

        if pickedEmailIdsSet.contains(pickedEmailId) {
            pickedEmailIdsSet.remove(pickedEmailId) //TODO: - if all emails picked and one unpicked - it should uncheckMark from PickAllEmails
            self.isAllEmailsPicked = false
        } else {
            pickedEmailIdsSet.insert(pickedEmailId)
        }

        if pickedEmailIdsSet.count == 1 {
            dropDownMenuTitleCases = dropDownMenuTitleCasesForOnePickedEmail
        } else {
            dropDownMenuTitleCases = dropDownMenuTitleCasesForSomePickedEmail
        }

        presenterUpdate()
    }

    func didTapBackArrow() {
        presenter?.didTapBackArrow()
    }

    func didTapPickAllBox(request: EmailPickingScreenFlow.Update.Request) {
        isAllEmailsPicked = true
        presenterUpdate()
    }

    func didTapThreeDotsNavBarIcon(request: EmailPickingScreenFlow.OnDropdownMenu.Request) {
        presenter?.presentDropdownMenu(response: EmailPickingScreenFlow.OnDropdownMenu.Response(
            dropDownMenuTitleCases: self.dropDownMenuTitleCases,
            isOnlyOneEmailPicked: self.isOnlyOneEmailPicked))
    }


    func didTapTitleOfThreeDotsDropdownMenu(request: EmailPickingScreenFlow.OnDropdownMenuTitle.Request) {
        let response = EmailPickingScreenFlow.OnDropdownMenuTitle.Response()

        switch request.enumCase {
        case .reply:
            didTapThreeDotsReply(response: response)
        case .replyToAll:
            didTapThreeDotsReplyToAll(response: response)
        case .forward:
            didTapThreeDotsForward(response: response)
        case .markAsRead:
            markAsRead(request: EmailPickingScreenFlow.OnEnvelopNavBarButton.Request())
        case .markAsUnread:
            markAsUnread(request: EmailPickingScreenFlow.OnEnvelopNavBarButton.Request())
        case .moveTo:
            didTapThreeDotsMoveTo(response: response)
        }
    }

    // marks only read as unread
    func markAsUnread(request: EmailPickingScreenFlow.OnEnvelopNavBarButton.Request) {
        Log.i("Selected emails with ids: \(pickedEmailIdsSet)")

        for id in pickedEmailIdsSet {
            worker?.updateIsRead(id: id, isRead: false) { [weak self] result in
                switch result {
                case .success(_):
                    self?.markLocalAsUnread(id: id)
                case .failure(let failure):
                    Log.e("Marking as unread id \(id) \(failure.localizedDescription)")
                }
            }
        }
    }
    // marks only unread as read
    func markAsRead(request: EmailPickingScreenFlow.OnEnvelopNavBarButton.Request) {
        Log.i("Selected emails with ids: \(pickedEmailIdsSet)")

        for id in pickedEmailIdsSet {
            worker?.updateIsRead(id: id, isRead: true) { [weak self] result in
                switch result {
                case .success(_):
                    self?.markLocalAsRead(id: id)
                case .failure(let failure):
                    Log.e("Marking as read id \(id) \(failure.localizedDescription)")
                }
            }
        }
    }

    func didTapArchiveNavBarIcon(request: EmailPickingScreenFlow.MovingTo.Request) {
// как получу совет по Удалению - напишу этот метод
    }


// --------------------------------------

    func didTapTrashOrArchiveNavBarIcon(request: EmailPickingScreenFlow.MovingTo.Request) {
        presenter?.presentWaitIndicator(response: EmailPickingScreenFlow.OnWaitIndicator.Response(isShow: true))

        var loadedEmailCount = 0
        let totalEmailCount = pickedEmailIdsSet.count

        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else { return }
            var lock = os_unfair_lock_s()

            for id in self.pickedEmailIdsSet {
                self.getEmailMessageModel(byUIDL: id) { [weak self] emailMessage in
                    guard let self = self else { return }
                    os_unfair_lock_lock(&lock)
                    self.pickedMailsFromDataBase.append(emailMessage)
                    os_unfair_lock_unlock(&lock)
                    loadedEmailCount += 1

                    if loadedEmailCount == totalEmailCount {
                        DispatchQueue.main.async {
                            self.presenter?.presentWaitIndicator(response: EmailPickingScreenFlow.OnWaitIndicator.Response(isShow: false))

                            var alert = EmailPickingScreenModel.AlertAtOrCase.areYorReallyWantToArchive
                            if request.folder == GlobalConstants.deletedEmails {
                                alert = .areYorReallyWantToDelete
                            }
                            self.presenter?.presentAlert(response: EmailPickingScreenFlow.AlertInfo.Response(
                                error: nil,
                                alertAt: alert))
                        }
                    }
                }
            }
        }
    }

    func transferEmails(request: EmailPickingScreenFlow.MovingTo.Request) {
        let serialQueue = DispatchQueue(label: "serialQueue", qos: .userInteractive)
        let group = DispatchGroup()
        var successfullyMovedCount = 0
        presenter?.presentWaitIndicator(response: EmailPickingScreenFlow.OnWaitIndicator.Response(isShow: true))

        for oneMail in self.pickedMailsFromDataBase {
            group.enter()
            serialQueue.async { [weak self] in
                guard let self = self else { return }
                //унифицировать метод под перемещение в разные папки
                moveEmailToChoosenFolder(emailMessage: oneMail, folder: request.folder) { isMovedToOtherFolder in
                    defer { group.leave() }
                    if isMovedToOtherFolder {
                        successfullyMovedCount += 1
                    }
                }
            }
        }

        group.notify(queue: .main) {
            if successfullyMovedCount == self.pickedEmailIdsSet.count {
                self.presenter?.presentWaitIndicator(response: EmailPickingScreenFlow.OnWaitIndicator.Response(isShow: false))
                self.presenter?.presentAlert(response: EmailPickingScreenFlow.AlertInfo.Response(
                    error: nil,
                    alertAt: .movedSuccessfully))
            } else {
                print("Not all emails were moved successfully. Successfully moved: \(successfullyMovedCount), Total: \(self.pickedEmailIdsSet.count)")
            }
        }
    }
//старый код - работает с папками, но не показывает потом htmlInLineAttachments, если открыть письмо из той папку, куда перемещаем
//        self.getPickedEmailsFromDataBaseFor(chooseFolder(messageTypeFromSideMenu)) { pickedMailsFromDataBase in
//
//            for oneEmailMessage in self.pickedMailsFromDataBase {
//                group.enter() //1
//                serialQueue.async {
//                    self.worker?.deleteMail(oneEmailMessage.id) { [weak self] result in
//                        guard let self = self else { return }
//                        defer { group.leave() } //0
//
//                        switch result {
//                        case .success():
//                            Log.i("EmailMessage with \(oneEmailMessage.id) has been deleted successfully")
//
//                            if messageTypeFromSideMenu != .deleted {
//                                group.enter()
//                                self.worker?.createFolder(name: GlobalConstants.deletedEmails) { result in
//                                    defer { group.leave() }
//
//                                    switch result {
//                                    case .success():
//                                        Log.i("Folder \(GlobalConstants.deletedEmails) has been created successfully")
//
//                                        group.enter()
//                                        self.worker?.addMail(oneEmailMessage, toFolder: GlobalConstants.deletedEmails) { result in
//                                            defer { group.leave() }
//
//                                            switch result {
//                                            case .success():
//                                                Log.i("Mail has been added to folder \(GlobalConstants.deletedEmails) successfully")
//                                                successfullyMovedCount += 1
//
//                                            case .failure(let error):
//                                                print("Failed to add email to folder \(GlobalConstants.deletedEmails), description: \(error.localizedDescription)")
//                                                self.presenter?.presentAlert(response: EmailPickingScreenFlow.AlertInfo.Response(
//                                                    error: error,
//                                                    alertAt: .movingToDeletedFolder))
//                                            }
//                                        }
//                                    case .failure(let error):
//                                        print("Failed to create folder \(GlobalConstants.deletedEmails), description: \(error.localizedDescription)")
//                                    }
//                                }
//                            } else {
//                                self.presenter?.presentRouteToMailStartScreen(response: EmailPickingScreenFlow.RoutePayload.Response())
//                            }
//                        case .failure(let error):
//                            print("Failed to delete \(oneEmailMessage.id), description: \(error.localizedDescription)")
//                        }
//                    }
//                }
//            }
//
//            group.notify(queue: .main) { [weak self] in
//                guard let self = self else { return }
//                if successfullyMovedCount == pickedEmailIdsSet.count {
//                    presenter?.presentAlert(response: EmailPickingScreenFlow.AlertInfo.Response(
//                        error: nil,
//                        alertAt: .movedSuccessfully))
//                } else {
//                    print("Not all emails were moved successfully. Successfully moved: \(successfullyMovedCount), Total: \(pickedEmailIdsSet.count)")
//                }
//            }
//        }
//    }

    // MARK: - Private methods

    private func getEmailMessageModel(byUIDL id: String, completion: @escaping ((EmailMessageModel) -> Void)) {
        worker?.getMail(byUIDL: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let mailFromDB):
                Log.i("Successfully got email data for ID: \(id)")
                completion(mailFromDB)
            case .failure(let error):
                Log.e("Failed to get email data for ID: \(id) - Error: \(error.localizedDescription)")
                self.presenter?.presentAlert(response: EmailPickingScreenFlow.AlertInfo.Response(
                    error: error,
                    alertAt: .gettingMail))
            }
        }
    }

    private func deleteEmailMessage(byUIDL id: String, completion: @escaping ((Bool) -> Void)) {
        worker?.deleteMail(id) { result in
            switch result {
            case .success():
                Log.i("EmailMessage with \(id) has been deleted successfully")
                completion(true)
            case .failure(let error):
                Log.e("Failed to delete email with ID: \(id) - Error: \(error.localizedDescription)")
                completion(false)
            }
        }
    }

    private func createFolder(folder: String, completion: @escaping ((Bool) -> Void)) {
        worker?.createFolder(name: folder) { result in
            switch result {
            case .success():
                Log.i("Folder \(folder) has been created successfully")
                completion(true)
            case .failure(let error):
                Log.e("Failed to create folder \(folder) - Error: \(error.localizedDescription)")
                completion(false)
            }
        }
    }

    private func addEmailToFolder(emailMessage: EmailMessageModel, folder: String, completion: @escaping ((Bool) -> Void)) {
        worker?.addMail(emailMessage, toFolder: folder) { result in
            switch result {
            case .success():
                Log.i("Mail has been added to folder \(folder) successfully")
                completion(true)
            case .failure(let error):
                Log.e("Failed to add email to folder \(folder) - Error: \(error.localizedDescription)")
                completion(false)
            }
        }
    }

    private func moveEmailToChoosenFolder(emailMessage: EmailMessageModel, folder: String, completion: @escaping ((Bool) -> Void)) {
        deleteEmailMessage(byUIDL: emailMessage.id) { [weak self] isDeleted in
            guard let self = self else { return }
            if isDeleted {
                if messageTypeFromSideMenu != .deleted {
                    self.createFolder(folder: folder) { isCreated in
                        if isCreated {
                            self.addEmailToFolder(emailMessage: emailMessage, folder: folder) { isAdded in
                                completion(isAdded)
                            }
                        } else {
                            completion(false)
                        }
                    }
                } else {
                    completion(true)
                }
            } else {
                completion(false)
            }
        }
    }

    private func getPickedEmailsFromDataBaseFor(_ folder: String, completion: @escaping ([EmailMessageModel]) ->Void) {
        Log.i("Fetching mail data array")
        presenter?.presentWaitIndicator(response: EmailPickingScreenFlow.OnWaitIndicator.Response(isShow: true))

        worker?.getAllStoredEmailsFromFolder(folder) { [weak self] result in
            guard let self = self else { return }
            presenter?.presentWaitIndicator(response: EmailPickingScreenFlow.OnWaitIndicator.Response(isShow: false))
            switch result {
            case .success(let mails):
                Log.i("Successfully got email data")
                for mailFromDB in mails {
                    pickedMailsFromDataBase.append(mailFromDB)
                }
                completion(pickedMailsFromDataBase)

            case .failure(let error):
                Log.e("Failed to get email data: \(error.localizedDescription)")
                presenter?.presentAlert(response: EmailPickingScreenFlow.AlertInfo.Response(
                    error: error,
                    alertAt: .gettingMail))
            }
        }
    }

    private func markLocalAsUnread(id: String) {
        guard let index = mailsForDisplay.firstIndex(where: { $0.id == id }) else { return }
        mailsForDisplay[index].isNewEmailIconDisplaying = true
        presenterUpdate()
    }

    private func markLocalAsRead(id: String) {
        guard let index = mailsForDisplay.firstIndex(where: { $0.id == id }) else { return }
        mailsForDisplay[index].isNewEmailIconDisplaying = false
        presenterUpdate()
    }

    private func chooseFolder(_ messageTypeFromSideMenu: TabBarManager.MessageType) -> String {
        switch messageTypeFromSideMenu {
        case .incoming:
            return GlobalConstants.inboxEmails
        case .sent:
            return GlobalConstants.sentEmails
        case .outgoing:
            return GlobalConstants.outgoingEmails
        case .drafts:
            return GlobalConstants.drafts
        case .archived:
            return GlobalConstants.archivedEmails
        case .deleted:
            return GlobalConstants.deletedEmails
        default: return ""
        }
    }

    private func didTapThreeDotsReply(response: EmailPickingScreenFlow.OnDropdownMenuTitle.Response) {
        print("---didTapThreeDotsReply---")
    }

    private func didTapThreeDotsReplyToAll(response: EmailPickingScreenFlow.OnDropdownMenuTitle.Response) {
        print("---didTapThreeDotsReplyToAll---")
    }

    private func didTapThreeDotsForward(response: EmailPickingScreenFlow.OnDropdownMenuTitle.Response) {
        print("---didTapThreeDotsForward---")
    }

    private func didTapThreeDotsMoveTo(response: EmailPickingScreenFlow.OnDropdownMenuTitle.Response) {
        presenter?.presentRouteToMovePickedEmailsScreen(response: EmailPickingScreenFlow.OnMoveToTitleOfDropdownMenu.Response())
    }

    private func didTapThreeDotsMarkEmailsAsRead(response: EmailPickingScreenFlow.OnDropdownMenuTitle.Response) {
        print("---didTapThreeDotsMarkEmailsAsRead---")
    }

    private func didTapThreeDotsMarkEmailsAsUnread(response: EmailPickingScreenFlow.OnDropdownMenuTitle.Response) {
        print("---didTapThreeDotsMarkEmailsAsUnread---")
    }

    private func presenterUpdate() {
        presenter?.presentUpdate(response: EmailPickingScreenFlow.Update.Response(
            mailsForDisplay: self.mailsForDisplay,
            pickedEmailIds: self.pickedEmailIdsSet,
            isAllEmailsBoxDidTap: self.isAllEmailsPicked,
            isOnlyOneEmailPicked: self.isOnlyOneEmailPicked,
            typeOfMessage: self.messageTypeFromSideMenu))
    }


    ///Light or Dark theme
    private func observeThemeChanging() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.screenThemeWasChanged,
            object: nil, queue: nil) { [weak self] _ in
                guard let self else {return}
                self.presenterUpdate()

                didTapThreeDotsNavBarIcon(request: EmailPickingScreenFlow.OnDropdownMenu.Request())
            }
    }

    private func observeLangChanging() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.languageWasChangedNotification,
            object: nil, queue: nil) { [weak self] _ in
                guard let self else {return}
                self.presenterUpdate()

                didTapThreeDotsNavBarIcon(request: EmailPickingScreenFlow.OnDropdownMenu.Request())
            }
    }

}
