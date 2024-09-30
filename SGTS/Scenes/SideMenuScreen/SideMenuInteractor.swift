//
//  SideMenuInteractor.swift
//  SGTS
//
//  Created by Roman Vakulenko on 03.07.2024.
//

import Foundation
import UIKit
protocol SideMenuBusinessLogic {
    func onDidLoadViews(request: SideMenuFlow.OnDidLoadViews.Request)
    func onSelectItem(request: SideMenuFlow.OnSelectItem.Request)
    func swipedOrTappedAtGrayViewForClose(request: SideMenuFlow.RoutePayload.Request)
}

protocol SideMenuDataStore: AnyObject {
    var selectedScreen: SideMenuModel.MenuItems { get }
}

final class SideMenuInteractor: SideMenuBusinessLogic, SideMenuDataStore {
    // MARK: - Public properties
    var presenter: SideMenuPresentationLogic?
    var worker: SideMenuWorkingLogic?
    var selectedScreen: SideMenuModel.MenuItems = .userNameAndEmail

    // MARK: - Private properties
    private var userFullName = "Асылбеков Асенбай Сарленович" //временно
    private var userEmail = "Asilbekov.Asenbai@gmail.com" //временно

    private var incomingMessagesAmountOfTotal = "0"
    private var incomingMessagesTotal = "0"
    private var sendMessagesTotal = "0"
    private var outgoingMessagesTotal = "0"
    private var draftsMessagesTotal = "0"
    private var archivedMessagesTotal = "0"
    private var deletedMessagesTotal = "0"

    private let serialQueue = DispatchQueue(label: "com.SGTS.countQueue")
    private let folders: [String] = [
        GlobalConstants.sentEmails,
        GlobalConstants.outgoingEmails,
        GlobalConstants.drafts,
        GlobalConstants.archivedEmails,
        GlobalConstants.deletedEmails
    ]

    // MARK: - Public methods

    func onDidLoadViews(request: SideMenuFlow.OnDidLoadViews.Request) {
        observeThemeChanging()
        observeLangChanging()

        self.presentUpdate(typeOfUpdate: .withZeros)

        let firstGroup = DispatchGroup()
        firstGroup.enter()
        self.worker?.getMailsCountFor(folderName: GlobalConstants.inboxEmails) { result in
            switch result {
            case .success(let amountOf):
                self.incomingMessagesAmountOfTotal = String(amountOf.unread)
                self.incomingMessagesTotal = String(amountOf.total)

                self.presentUpdate(typeOfUpdate: .incomingCount)
            case .failure(let error):
                Log.e("Failure to get amount of incoming \(error.localizedDescription)")
                self.presenter?.presentAlert(response: SideMenuFlow.AlertInfo.Response(error: error))
            }
            firstGroup.leave()
        }

        firstGroup.notify(queue: .global(qos: .userInitiated)) { [weak self] in
            guard let self = self else { return }

            let lastGroup = DispatchGroup()
            for folder in folders {
                lastGroup.enter()
                self.worker?.getMailsCountFor(folderName: folder) { result in
                    switch result {
                    case .success(let folderMessagesCount):
                        switch folder {
                        case GlobalConstants.sentEmails:
                            self.sendMessagesTotal = folderMessagesCount.total

                        case GlobalConstants.outgoingEmails:
                            self.outgoingMessagesTotal = folderMessagesCount.total

                        case GlobalConstants.drafts:
                            self.draftsMessagesTotal = folderMessagesCount.total

                        case GlobalConstants.archivedEmails:
                            self.archivedMessagesTotal = folderMessagesCount.total

                        case GlobalConstants.deletedEmails:
                            self.deletedMessagesTotal = folderMessagesCount.total

                        default: break
                        }
                    case .failure(let error):
                        Log.e("Failed to get mail count: \(error.localizedDescription)")
                        self.presenter?.presentAlert(response: SideMenuFlow.AlertInfo.Response(error: error))
                    }
                    lastGroup.leave()
                }
            }


            lastGroup.notify(queue: .global(qos: .userInitiated)) { [weak self] in
                guard let self = self else { return }
                self.presentUpdate(typeOfUpdate: .otherCount)
            }

        }
    }

    func onSelectItem(request: SideMenuFlow.OnSelectItem.Request) {
        guard let id = request.id as? SideMenuModel.MenuItems else {return}
        selectedScreen = id
        presenter?.presentRouteToSelectedScreen(response: SideMenuFlow.OnSelectItem.Response())
    }

    func swipedOrTappedAtGrayViewForClose(request: SideMenuFlow.RoutePayload.Request) {
        presenter?.presentRouteBack(request: SideMenuFlow.RoutePayload.Response())
    }


    //MARK: - Private methods

    private func presentUpdate(typeOfUpdate: SideMenuModel.TypeOfUpdate) {
        presenter?.presentUpdate(response: SideMenuFlow.Update.Response(
            userFullName: self.userFullName,
            userEmail: self.userEmail,
            incomingMessagesAmountOfTotal: self.incomingMessagesAmountOfTotal,
            incomingMessagesTotal: self.incomingMessagesTotal,
            sentMessagesTotal: self.sendMessagesTotal,
            outgoingMessagesTotal: self.outgoingMessagesTotal,
            draftsMessagesTotal: self.draftsMessagesTotal,
            archivedMessagesTotal: self.archivedMessagesTotal,
            deletedMessagesTotal: self.deletedMessagesTotal,
            typeOfUpdate: typeOfUpdate))
    }

    ///Light or Dark theme
    private func observeThemeChanging() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.screenThemeWasChanged,
            object: nil, queue: nil) { _ in
                self.presentUpdate(typeOfUpdate: .allScreenWithAllCounts)
            }
    }

    private func observeLangChanging() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.languageWasChangedNotification,
            object: nil, queue: nil) { _ in
                self.presentUpdate(typeOfUpdate: .allScreenWithAllCounts)
            }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
