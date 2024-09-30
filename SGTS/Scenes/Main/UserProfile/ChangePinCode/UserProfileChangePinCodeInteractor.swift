//
//  UserProfileChangePinCodeInteractor.swift
//  SGTS
//
//  Created by Roman Vakulenko on 28.06.2024.
//

import Foundation
import UIKit
protocol UserProfileChangePinCodeBusinessLogic {
    func onDidLoadViews(request: UserProfileChangePinCodeFlow.OnDidLoadViews.Request)
    func onSelectItem(request: UserProfileChangePinCodeFlow.OnSelectItem.Request)
//    func changeInputText(request: UserProfileChangePinCodeFlow.OnSelectItem.Request)
    func didTapAtBiometrySwitch(request: UserProfileChangePinCodeFlow.OnSwitchTap.Request)
}

protocol UserProfileChangePinCodeDataStore: AnyObject {

}

final class UserProfileChangePinCodeInteractor: UserProfileChangePinCodeBusinessLogic, UserProfileChangePinCodeDataStore {

    private enum Constants {
        static let acceptablePasswordCount = 4
        static let digitRegex = "^[0-9]{4}$"
    }

    // MARK: - Public properties

    var presenter: UserProfileChangePinCodePresentationLogic?
    var worker: UserProfileChangePinCodeWorkingLogic?

    // MARK: - Private properties

    private var currentPassword = String()
    private var isConfirmPasswordActive: Bool {
        currentPassword.count == Constants.acceptablePasswordCount &&
        matchesRegex(Constants.digitRegex, in: currentPassword)
    }
    private var confirmPasswordText: String? = nil
    private var arePasswordsEqual: Bool { //input for isBiometrySwitchActive, finishBtn
        currentPassword == confirmPasswordText &&
        currentPassword.count == Constants.acceptablePasswordCount
    }
    private var isBiometrySwitchActive: Bool {
        currentPassword == confirmPasswordText &&
        currentPassword.count == Constants.acceptablePasswordCount
    }

    private var isSwitchOn = false
    private var didGetUserPermissionForBiometry = false

    // MARK: - Lifecycle
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Public methods

    func onDidLoadViews(request: UserProfileChangePinCodeFlow.OnDidLoadViews.Request) {
        observeThemeChanging()
        observeLangChanging()
        updateOnDidLoad()
    }

    func didTapAtBiometrySwitch(request: UserProfileChangePinCodeFlow.OnSwitchTap.Request) {
        if didGetUserPermissionForBiometry {
            self.isSwitchOn = request.isOn
            self.didGetUserPermissionForBiometry = false //ЧТОБЫ если отключил, то снова бы запрашивалось разрешение юзера - надо ли? в ТЗ нет, но по логике - нужно
        } else {
            trySetBiometryOn()
        }
        #warning("по согласнованию логика не была завершена")
        presenter?.presentUpdate(response: UserProfileChangePinCodeFlow.Update.Response(
            isConfirmPasswordActive: isConfirmPasswordActive,
            isBiometrySwitchActive: arePasswordsEqual,
            isBiometrySwitchOn: isSwitchOn,
            isFinishButtonActive: arePasswordsEqual,
            currentPassword: currentPassword,
            newPassword: currentPassword)
        )
    }

    func onSelectItem(request: UserProfileChangePinCodeFlow.OnSelectItem.Request) {
        guard let id = request.id as? UserProfileChangePinCodeModel.MenuItems else {return}

        switch id {
        case .enterCurrentPinCode:
            currentPassword = request.selectedString ?? ""
//            presenter?.presentConfirmPasswordFieldState(response: SetPinCodeFlow.ChangeConfirmPswrdState.Response(isActive: isConfirmPasswordActive))

        case .enterNewPinCode:
            currentPassword = request.selectedString ?? ""
//            presenter?.presentConfirmPasswordFieldState(response: UserProfileChangePinCodeFlow.ChangeConfirmPswrdState.Response(isActive: isConfirmPasswordActive))

        case .confirmNewPinCode:
            confirmPasswordText = request.selectedString ?? ""
//            presenter?.presentBiometrySwitchState(response: UserProfileChangePinCodeFlow.ChangeSwitchState.Response(isActive: isBiometrySwitchActive))
//            presenter?.presentFinishRegistrationButtonState(response: UserProfileChangePinCodeFlow.ChangeButtonState.Response(isActive: isBiometrySwitchActive))

        case .saveButton:
            presenter?.presentRouteToSavePincode(response: UserProfileChangePinCodeFlow.RoutePayload.Response())

        case .cancelButton:
            presenter?.presentRouteBackToUserProfile(response: UserProfileChangePinCodeFlow.RoutePayload.Response())
        }
    }

    //MARK: - Private methods
//При переключении биометрии в активное состояние необходимо спросить у пользователя разрешение, при помощи системного диалога (текст сообщения будет позже), в случае успеха - оставить переключатель во включенном состоянии, в случае отказа - в выключенном.
    private func trySetBiometryOn() {
        presenter?.presentWaitIndicator(
            response: UserProfileChangePinCodeFlow.OnWaitIndicator.Response(isShow: true))

        worker?.requestBiometryPermission() { [weak self] result in
            Log.i("BiometryPermission success")
            guard let self else {return}
            presenter?.presentWaitIndicator(response: UserProfileChangePinCodeFlow.OnWaitIndicator.Response(isShow: false))

            switch result {
            case .success(_):
                self.didGetUserPermissionForBiometry = true
                self.isSwitchOn = true //в случае успеха - оставить переключатель во включенном состоянии
                self.presenter?.presentUpdate(
                    response: UserProfileChangePinCodeFlow.Update.Response(
                        isConfirmPasswordActive: isConfirmPasswordActive,
                        isBiometrySwitchActive: arePasswordsEqual,
                        isBiometrySwitchOn: isSwitchOn,
                        isFinishButtonActive: arePasswordsEqual,
                        currentPassword: currentPassword,
                        newPassword: currentPassword))

            case .failure(let error):
                Log.e("Failed to get BiometryPermission: \(error.localizedDescription)")
                self.didGetUserPermissionForBiometry = false
                isSwitchOn = false //в случае отказа - в выключенном.
                presenter?.presentAlert(response: UserProfileChangePinCodeFlow.AlertInfo.Response(error: error))

            }
        }
    }

    private func updateOnDidLoad() {
        presenter?.presentUpdate(response: UserProfileChangePinCodeFlow.Update.Response(
            isConfirmPasswordActive: isConfirmPasswordActive,
            isBiometrySwitchActive: arePasswordsEqual,
            isBiometrySwitchOn: isSwitchOn,
            isFinishButtonActive: arePasswordsEqual,
            currentPassword: currentPassword,
            newPassword: currentPassword)
        )
    }

    ///Light or Dark theme
    private func observeThemeChanging() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.screenThemeWasChanged,
            object: nil, queue: nil) { _ in
                self.presenter?.presentUpdate(
                    response: UserProfileChangePinCodeFlow.Update.Response(
                        isConfirmPasswordActive: self.isConfirmPasswordActive,
                        isBiometrySwitchActive: self.arePasswordsEqual,
                        isBiometrySwitchOn: self.isSwitchOn,
                        isFinishButtonActive: self.arePasswordsEqual,
                        currentPassword: self.currentPassword,
                        newPassword: self.currentPassword)
                    )
            }
    }

    private func observeLangChanging() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.languageWasChangedNotification,
            object: nil, queue: nil) { _ in
                self.presenter?.presentUpdate(
                    response: UserProfileChangePinCodeFlow.Update.Response(
                        isConfirmPasswordActive: self.isConfirmPasswordActive,
                        isBiometrySwitchActive: self.arePasswordsEqual,
                        isBiometrySwitchOn: self.isSwitchOn,
                        isFinishButtonActive: self.arePasswordsEqual,
                        currentPassword: self.currentPassword,
                        newPassword: self.currentPassword)
                    )
            }
    }

    private func matchesRegex(_ regex: String, in text: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: text)
    }
}

