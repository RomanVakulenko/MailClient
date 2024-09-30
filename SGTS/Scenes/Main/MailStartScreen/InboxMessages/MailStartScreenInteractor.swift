//
//  MailStartScreenInteractor.swift
//  SGTS
//
//  Created by Roman Vakulenko on 17.04.2024.
//

import Foundation
import UIKit

protocol MailStartScreenBusinessLogic {
    func onDidLoadViews(request: MailStartScreenFlow.OnDidLoadViews.Request)
    func updateMailListWithReceiveNewMail(request: MailStartScreenFlow.Update.Request)


    func onSelectItem(request: MailStartScreenFlow.OnSelectItem.Request)
    func onPullToReftesh(request: MailStartScreenFlow.OnPullToRefresh.Request)

    func didLongPressAtEmail(request: MailStartScreenFlow.OnLongPressGestureTap.Request)
    func checkIfAllMailsFetched(request: MailStartScreenFlow.Update.Request)
    func didTapCreateNewEmailBarButton(request: MailStartScreenFlow.OnBarButtonTap.Request)
    func didTapSideMenuBarButton(request: MailStartScreenFlow.OnBarButtonTap.Request)
}

protocol MailStartScreenDataStore: AnyObject {
    var mailsForDisplay: [EmailMessageWithNeededProperties] { get }
    var idOfSelectedMail: String { get }
    var someMessagesFromTotal: Int { get }
    var totalMessages: Int { get }
    var messageTypeFromSideMenu: TabBarManager.MessageType { get set }
}

final class MailStartScreenInteractor: MailStartScreenBusinessLogic, MailStartScreenDataStore {

    // MARK: - Public properties

    var presenter: MailStartScreenPresentationLogic?
    var worker: MailStartScreenWorkingLogic?

    var idOfSelectedMail = String()
    var someMessagesFromTotal = Int()
    var totalMessages = Int()
    var mailsForDisplay = [EmailMessageWithNeededProperties]()
    var messageTypeFromSideMenu: TabBarManager.MessageType = .incoming

    // MARK: - Private properties
    private let mailManager = DIManager.shared.container.resolve(EmailManagerProtocol.self)!

    private var isPersonalToUser = false //isPrivate
    private var isImportantEmail = false
    private var isExternalEmail = false



    // MARK: - Public methods

    func onDidLoadViews(request: MailStartScreenFlow.OnDidLoadViews.Request) {
        Log.i("View did load, starting setup")
        subscribeToNotification()
    }

    func onPullToReftesh(request: MailStartScreenFlow.OnPullToRefresh.Request) {
        Log.i("Pull to refresh triggered")
        updateMailListWithReceiveNewMail(request: MailStartScreenFlow.Update.Request())
    }

    func updateMailListWithReceiveNewMail(request: MailStartScreenFlow.Update.Request) {
        Log.i("Update mail list with receive new mail")
        mailsForDisplay = []
        presenter?.presentWaitIndicator(response: MailStartScreenFlow.OnWaitIndicator.Response(isShow: true))

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else {return}
            mailManager.fetchNewMails { result in
                self.presenter?.presentWaitIndicator(response: MailStartScreenFlow.OnWaitIndicator.Response(isShow: false))
                self.workerFetchMailDataArr()
            }
        }
    }

    func checkIfAllMailsFetched(request: MailStartScreenFlow.Update.Request) {
        Log.i("Checking if all mails are fetched")
        if worker?.isAllMailsFetched == false {
            Log.i("Not all mails fetched, fetching more")
            workerFetchMailDataArr()
        }
    }

    func didLongPressAtEmail(request: MailStartScreenFlow.OnLongPressGestureTap.Request) {
        Log.i("Long pressed email with id: \(request.id)")
        idOfSelectedMail = request.id
        presenter?.presentLongPressMoveToEmailPickingScreen(
            response: MailStartScreenFlow.OnLongPressGestureTap.Response())
    }

    func onSelectItem(request: MailStartScreenFlow.OnSelectItem.Request) {
        Log.i("Selected email with id: \(request.id)")
        idOfSelectedMail = request.id
        presenter?.presentRouteToOneEmailDetailsScreen(
            response: MailStartScreenFlow.OnSelectItem.Response())
        worker?.updateIsRead(id: request.id,
                             isRead: true,
                             completion: { [weak self] result in
            switch result {
            case .success(_):
                self?.markLocalAsRead(id: request.id)
                self?.update()
            case .failure(let failure):
                Log.e("mark as read id \(request.id) \(failure.localizedDescription)")
            }
        })
    }

    func didTapCreateNewEmailBarButton(request: MailStartScreenFlow.OnBarButtonTap.Request) {
        Log.i("Tapped create new email button")
        presenter?.presentRouteToNewEmailCreate(
            response: MailStartScreenFlow.RoutePayload.Response())
    }

    func didTapSideMenuBarButton(request: MailStartScreenFlow.OnBarButtonTap.Request) {
        Log.i("Tapped side menu button")
        presenter?.presentRouteToSideMenu(response: MailStartScreenFlow.RoutePayload.Response())
    }

    //MARK: - Private methods
    private func markLocalAsRead(id: String) {
        guard let index = mailsForDisplay.firstIndex(where: { $0.id == id }) else { return }
        mailsForDisplay[index].isNewEmailIconDisplaying = false
    }
    
    private func workerFetchMailDataArr() {
        Log.i("Fetching mail data array")
        presenter?.presentWaitIndicator(response: MailStartScreenFlow.OnWaitIndicator.Response(isShow: true))
        
        worker?.getAllStoredEmailsFromFolder(GlobalConstants.inboxEmails) { [weak self] result in
            guard let self = self else { return }
            presenter?.presentWaitIndicator(response: MailStartScreenFlow.OnWaitIndicator.Response(isShow: false))
            switch result {
            case .success(let mails):
                Log.i("Successfully got email data")
                someMessagesFromTotal = mails.filter { !$0.isRead }.count
                totalMessages = mails.count
                
                mailsForDisplay = mails.compactMap { oneEmailMessage in
                    var arrayOfAttachmentNamesAndExt = [String]() //for cloud
                    var hasAttachment = false
                    
                    for oneAttachment in oneEmailMessage.attachments {
                        if !oneAttachment.filename.isEmpty {
                            hasAttachment = true
                            arrayOfAttachmentNamesAndExt.append(oneAttachment.filename)
                        }
                    }

                    let email = EmailMessageWithNeededProperties(
                        id: oneEmailMessage.id,
                        senderEmail: oneEmailMessage.sender,
                        subject: oneEmailMessage.subject,
                        body: oneEmailMessage.body,
                        receivedDate: oneEmailMessage.date,
                        isNewEmailIconDisplaying: !oneEmailMessage.isRead, // !isRead == newIconDisplaying
                        isPersonalToUserIconDisplaying: oneEmailMessage.isPrivate,
                        isEmportantEmailIndicatorDisplaying: self.isImportantEmail,
                        isExternalEmailIconDisplaying: self.isExternalEmail,
                        isAttachmentIconDisplaying: hasAttachment,
                        arrayOfAttachmentNamesAndExt: arrayOfAttachmentNamesAndExt,
                        hasFotos: false)
                    return email
                }
                update()
            case .failure(let error):
                Log.e("Failed to get email data: \(error.localizedDescription)")
                presenter?.presentAlert(response: MailStartScreenFlow.AlertInfo.Response(error: error))
            }
        }

    }

    private func update() {
        presenter?.presentUpdate(response: MailStartScreenFlow.Update.Response(
            mailsFromDatabase: mailsForDisplay,
            someMessagesFromTotal: someMessagesFromTotal,
            totalMessages: totalMessages,
            typeOfMessage: .incoming))
    }
    
    ///Light or Dark theme
    private func observeThemeChanging() {
        Log.i("Observing theme changes")
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.screenThemeWasChanged,
            object: nil, queue: nil) { [weak self] _ in
                guard let self = self else { return }
                Log.i("Theme changed, updating UI")
                self.update()
            }
    }

    private func observeLangChanging() {
        Log.i("Observing language changes")
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.languageWasChangedNotification,
            object: nil, queue: nil) { [weak self] _ in
                guard let self = self else { return }
                Log.i("Language changed, updating UI")
                self.update()
            }
    }
    
    private func subscribeToNotification() {
        observeThemeChanging()
        observeLangChanging()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNewMail),
                                               name: .inputMailListDidUpdate,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self, 
                                               selector: #selector(handleWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)

    }

    @objc func handleWillEnterForeground() {
        Log.i("MailStartScreenInteractor receive App will enter foreground")
        updateMailListWithReceiveNewMail(request: MailStartScreenFlow.Update.Request())
    }
    
    @objc private func handleNewMail() {
        Log.i("MailStartScreenInteractor receive new mail notification")
        updateMailListFromDatabase()
    }
    
    private func updateMailListFromDatabase() {
        Log.i("Update mail list from database")
        mailsForDisplay = []
        workerFetchMailDataArr()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
