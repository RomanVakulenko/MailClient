//
//  UserProfileChangeNameInteractor.swift
//  SGTS
//
//  Created by Roman Vakulenko on 24.06.2024.
//

import Foundation
import UIKit

protocol UserProfileChangeNameBusinessLogic {
    func onDidLoadViews(request: UserProfileChangeNameFlow.OnDidLoadViews.Request)
    func changeInputText(request: UserProfileChangeNameFlow.OnTextFieldDidChange.Request)

    func didTapCancel(request: UserProfileChangeNameFlow.RoutePayload.Request)
    func didTapSave(request: UserProfileChangeNameFlow.RoutePayload.Request)
}

protocol UserProfileChangeNameDataStore: AnyObject {

}

final class UserProfileChangeNameInteractor: UserProfileChangeNameBusinessLogic, UserProfileChangeNameDataStore {

    // MARK: - Public properties

    var presenter: UserProfileChangeNamePresentationLogic?
    var worker: UserProfileChangeNameWorkingLogic?

    // MARK: - Private properties
    private var userFullName: String
    private var senderName: String?


    // MARK: - Lifecycle
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    init(userFullName: String) {
        self.userFullName = userFullName
    }

    // MARK: - Public methods

    func onDidLoadViews(request: UserProfileChangeNameFlow.OnDidLoadViews.Request) {
        observeThemeChanging()
        observeLangChanging()

        presenter?.presentUpdate(response: UserProfileChangeNameFlow.Update.Response(
            userFullName: self.userFullName,
            senderName: nil))
    }
                                 
    func changeInputText(request: UserProfileChangeNameFlow.OnTextFieldDidChange.Request) {
        self.senderName = request.enteredSenderName ?? ""

        presenter?.presentUpdate(response: UserProfileChangeNameFlow.Update.Response(
            userFullName: self.userFullName,
            senderName: self.senderName))
    }

    func didTapCancel(request: UserProfileChangeNameFlow.RoutePayload.Request) {
        presenter?.presentRouteBack(response: UserProfileChangeNameFlow.RoutePayload.Response())
    }

    func didTapSave(request: UserProfileChangeNameFlow.RoutePayload.Request) {
//        presenter?.present...(response: UserProfileChangeNameFlow.RoutePayload.Response())
    }



    //MARK: - Private methods

    ///Light or Dark theme
    private func observeThemeChanging() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.screenThemeWasChanged,
            object: nil, queue: nil) { [weak self] _ in
                guard let self else {return}
                self.presenter?.presentUpdate(response: UserProfileChangeNameFlow.Update.Response(
                    userFullName: self.userFullName,
                    senderName: self.senderName))
            }
    }

    private func observeLangChanging() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.languageWasChangedNotification,
            object: nil, queue: nil) { [weak self] _ in
                guard let self else {return}
                self.presenter?.presentUpdate(response: UserProfileChangeNameFlow.Update.Response(
                    userFullName: self.userFullName,
                    senderName: self.senderName))
            }
    }

}
