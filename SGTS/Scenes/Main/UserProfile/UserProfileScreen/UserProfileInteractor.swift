//
//  UserProfileInteractor.swift
//  SGTS
//
//  Created by Roman Vakulenko on 16.06.2024.
//

import Foundation
import UIKit
protocol UserProfileBusinessLogic {
    func onDidLoadViews(request: UserProfileFlow.OnDidLoadViews.Request)
    func onSelectItem(request: UserProfileFlow.OnSelectItem.Request)
    func onSwitch(request: UserProfileFlow.OnSwitch.Request)
    func didTapSideMenuBarButton(request: UserProfileFlow.RoutePayload.Request)
}

protocol UserProfileDataStore: AnyObject {
    var userFullName: String { get }
    var userEmail: String { get }
}

final class UserProfileInteractor: UserProfileBusinessLogic, UserProfileDataStore {

    // MARK: - Public properties

    var presenter: UserProfilePresentationLogic?
    var worker: UserProfileWorkingLogic?

    var userFullName = String()
    var userEmail = String()

    // MARK: - Private properties

    private var isDeleteFromServerOn = false
    private var isUnsafeOutputAlertOn = false
    private var isDarkThemeOn = false

    // MARK: - Lifecycle
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Public methods

    func onDidLoadViews(request: UserProfileFlow.OnDidLoadViews.Request) {
        observeThemeChanging()
        observeLangChanging()

        userFullName = "Асылбеков Асенбай Сарленович"
        userEmail = "Asilbekov.Asenbai@gmail.com"

        presenter?.presentUpdate(response: UserProfileFlow.Update.Response(
            userFullName: userFullName,
            userEmail: userEmail,
            isDeleteFromServerOn: isDeleteFromServerOn,
            isUnsafeOutputAlertOn: isUnsafeOutputAlertOn,
            isDarkThemeOn: isDarkThemeOn))


        //        if let url = URL(string: "https://example.com/") {
        //            worker?.getUserDataAt(url: url) { [weak self] result in
//                guard let self else {return}
//
//                switch result {
//                case .success(let userData):
//                    Log.i("Data got successfully")
//                    
//                    presenter?.presentUpdate(response: UserProfileFlow.Update.Response(
//                        userFullName: self.userFullName,
//                        userEmail: self.userEmail,
//                        isDeleteFromServerOn: self.isDeleteFromServerOn,
//                        isUnsafeOutputAlertOn: self.isDeleteFromServerOn,
//                        isDarkThemeOn: self.isDeleteFromServerOn))
//                case .failure(_):
//                    Log.i("Some error")
//                    //                presenter?.presentAlert(response: UserProfileFlow.AlertInfo.Response())
//                }
//            }
//        }

    }

    func onSelectItem(request: UserProfileFlow.OnSelectItem.Request) {
        guard let id = request.id as? UserProfileModel.MenuItems else {return}

        switch id {
        case .userNameAndEmail:
            presenter?.presentRouteToNameEditingScreen(response: UserProfileFlow.OnSelectItem.Response())
        case .changePinCode:
            presenter?.presentRouteToPinCodeEditingScreen(response: UserProfileFlow.OnSelectItem.Response())
        case .signature:
            presenter?.presentRouteToSignatureScreen(response: UserProfileFlow.OnSelectItem.Response())
        case .report:
            presenter?.presentRouteToReportScreen(response: UserProfileFlow.OnSelectItem.Response())
        case .deleteMailForServer:
            () //switch
        case .unsafeOutputAlert:
            () //switch
        case .darkTheme:
            () //switch
        case .info:
            presenter?.presentRouteToInfoScreen(response: UserProfileFlow.OnSelectItem.Response())
        }
    }

    func onSwitch(request: UserProfileFlow.OnSwitch.Request) {
        guard let id = request.id as? UserProfileModel.MenuItems else {return}

        switch id {
        case .deleteMailForServer:
            isDeleteFromServerOn.toggle() // = request.isSwitchOn
            print(isUnsafeOutputAlertOn)
            presenter?.presentUpdate(response: UserProfileFlow.Update.Response(
                userFullName: userFullName,
                userEmail: userEmail,
                isDeleteFromServerOn: isDeleteFromServerOn,
                isUnsafeOutputAlertOn: isUnsafeOutputAlertOn,
                isDarkThemeOn: isDarkThemeOn))

        case .unsafeOutputAlert:
            isUnsafeOutputAlertOn.toggle() // = request.isSwitchOn
            print(isUnsafeOutputAlertOn)
            presenter?.presentUpdate(response: UserProfileFlow.Update.Response(
                userFullName: userFullName,
                userEmail: userEmail,
                isDeleteFromServerOn: isDeleteFromServerOn,
                isUnsafeOutputAlertOn: isUnsafeOutputAlertOn,
                isDarkThemeOn: isDarkThemeOn))

        case .darkTheme:
            isDarkThemeOn.toggle() // = request.isSwitchOn
            print(isDarkThemeOn)
            presenter?.presentUpdate(response: UserProfileFlow.Update.Response(
                userFullName: userFullName,
                userEmail: userEmail,
                isDeleteFromServerOn: isDeleteFromServerOn,
                isUnsafeOutputAlertOn: isUnsafeOutputAlertOn,
                isDarkThemeOn: isDarkThemeOn))
        default:
            return
        }
    }


    func didTapSideMenuBarButton(request: UserProfileFlow.RoutePayload.Request) {
        presenter?.presentRouteToSideMenu(response: UserProfileFlow.RoutePayload.Response())
    }

    //MARK: - Private methods
    private func getUserInfo() {

    }


    ///Light or Dark theme
    private func observeThemeChanging() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.screenThemeWasChanged,
            object: nil, queue: nil) { _ in
                self.presenter?.presentUpdate(
                    response: UserProfileFlow.Update.Response(
                        userFullName: self.userFullName,
                        userEmail: self.userEmail,
                        isDeleteFromServerOn: self.isDeleteFromServerOn,
                        isUnsafeOutputAlertOn: self.isUnsafeOutputAlertOn,
                        isDarkThemeOn: self.isDarkThemeOn))
            }
    }
    
    private func observeLangChanging() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.languageWasChangedNotification,
            object: nil, queue: nil) { _ in
                self.presenter?.presentUpdate(
                    response: UserProfileFlow.Update.Response(
                        userFullName: self.userFullName,
                        userEmail: self.userEmail,
                        isDeleteFromServerOn: self.isDeleteFromServerOn,
                        isUnsafeOutputAlertOn: self.isUnsafeOutputAlertOn,
                        isDarkThemeOn: self.isDarkThemeOn))
            }
    }
    
}

