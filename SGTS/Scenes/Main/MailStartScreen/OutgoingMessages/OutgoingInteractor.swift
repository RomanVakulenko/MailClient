//
//  OutgoingInteractor.swift
//  SGTS
//
//  Created by Roman Vakulenko on 11.07.2024.
//

import UIKit

final class OutgoingInteractor: MailStartScreenBusinessLogic, MailStartScreenDataStore {

    // MARK: - Public properties

    var presenter: MailStartScreenPresentationLogic?
    var worker: OutgoingWorkingLogic?

    var idOfSelectedMail = String()
    var someMessagesFromTotal = Int()
    var totalMessages = Int()
    var mailsForDisplay = [EmailMessageWithNeededProperties]()
    var messageTypeFromSideMenu: TabBarManager.MessageType = .outgoing

    // MARK: - Private properties
    private let mailManager = DIManager.shared.container.resolve(EmailManagerProtocol.self)!

    private var isPersonalToUser = false //isPrivate
    private var isImportantEmail = false
    private var isExternalEmail = false

    // MARK: - Lifecycle
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Public methods

    func onDidLoadViews(request: MailStartScreenFlow.OnDidLoadViews.Request) {
        Log.i("View did load, starting setup")
        observeThemeChanging()
        observeLangChanging()
    }

    func updateMailListWithReceiveNewMail(request: MailStartScreenFlow.Update.Request) {
        mailsForDisplay = []
        workerFetchMailDataArr()
    }

    func onPullToReftesh(request: MailStartScreenFlow.OnPullToRefresh.Request) {
        Log.i("Pull to refresh triggered")
        mailsForDisplay = []
        workerFetchMailDataArr()
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
    private func workerFetchMailDataArr() {
        Log.i("Fetching mail data array")
        presenter?.presentWaitIndicator(response: MailStartScreenFlow.OnWaitIndicator.Response(isShow: true))

        worker?.getAllStoredEmailsFromFolder(GlobalConstants.outgoingEmails) { [weak self] result in
            guard let self = self else { return }
            presenter?.presentWaitIndicator(response: MailStartScreenFlow.OnWaitIndicator.Response(isShow: false))

            switch result {
            case .success(let messages):
                Log.i("Successfully got email data")
                totalMessages = messages.count

                mailsForDisplay = messages.compactMap { oneEmailMessage in
                    var arrayOfAttachmentNamesAndExt = [String]() //for cloud
                    var hasAttachment = false

                    for oneAttachment in oneEmailMessage.attachments {
                        if !oneAttachment.filename.isEmpty {
                            hasAttachment = true
                            arrayOfAttachmentNamesAndExt.append(oneAttachment.filename )
                        }
                    }

                    let email = EmailMessageWithNeededProperties(
                        id: oneEmailMessage.id,
                        senderEmail: oneEmailMessage.sender,
                        subject: oneEmailMessage.subject,
                        body: oneEmailMessage.body,
                        receivedDate: oneEmailMessage.date,
                        isNewEmailIconDisplaying: false,
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
            typeOfMessage: .outgoing))
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

}

