//
//  SetPinCodeInteractor.swift
//  SGTS
//
//  Created by Roman Vakulenko on 09.04.2024.
//

import Foundation
import UIKit
protocol SetPinCodeBusinessLogic {
    func onDidLoadViews(request: SetPinCodeFlow.OnDidLoadViews.Request)
    func onSelectItem(request: SetPinCodeFlow.OnSelectItem.Request)
//    func changeInputText(request: SetPinCodeFlow.OnSelectItem.Request)
    func didTapAtBiometrySwitch(request: SetPinCodeFlow.OnSwitchTap.Request)
}

protocol SetPinCodeDataStore: AnyObject {

}

final class SetPinCodeInteractor: SetPinCodeBusinessLogic, SetPinCodeDataStore {

   private  enum Constants {
        static let acceptablePasswordCount = 4
        static let digitRegex = "^[0-9]{4}$"
    }

    // MARK: - Public properties

    var presenter: SetPinCodePresentationLogic?
    var worker: SetPinCodeWorkingLogic?

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

    func onDidLoadViews(request: SetPinCodeFlow.OnDidLoadViews.Request) {
        observeThemeChanging()
        observeLangChanging()
        updateOnDidLoad()
    }

    func didTapAtBiometrySwitch(request: SetPinCodeFlow.OnSwitchTap.Request) {
        if didGetUserPermissionForBiometry {
            self.isSwitchOn = request.isOn
            self.didGetUserPermissionForBiometry = false //ЧТОБЫ если отключил, то снова бы запрашивалось разрешение юзера - надо ли? в ТЗ нет, но по логике надо
        } else {
            trySetBiometryOn()
        }

        presenter?.presentUpdate(response: SetPinCodeFlow.Update.Response(
            isConfirmPasswordActive: isConfirmPasswordActive,
            isBiometrySwitchActive: arePasswordsEqual,
            isBiometrySwitchOn: isSwitchOn,
            isFinishButtonActive: arePasswordsEqual,
            passwordText: currentPassword)
        )
    }

    func onSelectItem(request: SetPinCodeFlow.OnSelectItem.Request) {
        guard let id = request.id as? SetPinCodeModel.MenuItems else {return}

        switch id {
        case .title:
            break

        case .passwordInput:
            currentPassword = request.selectedString ?? ""
            presenter?.presentConfirmPasswordFieldState(
                response: SetPinCodeFlow.ChangeConfirmPswrdState.Response(isActive: isConfirmPasswordActive))

        case .confirmPasswordInput:
            confirmPasswordText = request.selectedString ?? ""
            presenter?.presentBiometrySwitchState(
                response: SetPinCodeFlow.ChangeSwitchState.Response(isActive: isBiometrySwitchActive))
            presenter?.presentFinishRegistrationButtonState(response: SetPinCodeFlow.ChangeButtonState.Response(isActive: isBiometrySwitchActive))

        case .finishButton:
            self.onFinishPressed()
        }
    }

    //MARK: - Private methods
//При переключении биометрии в активное состояние необходимо спросить у пользователя разрешение, при помощи системного диалога (текст сообщения будет позже), в случае успеха - оставить переключатель во включенном состоянии, в случае отказа - в выключенном.
    private func trySetBiometryOn() {
        worker?.requestBiometryPermission() { [weak self] result in
            guard let self else {return}

            switch result {
            case .success(_):
                Log.i("BiometryPermission success")
                self.didGetUserPermissionForBiometry = true
                self.isSwitchOn = true //в случае успеха - оставить переключатель во включенном состоянии
                self.presenter?.presentUpdate(
                    response: SetPinCodeFlow.Update.Response(
                        isConfirmPasswordActive: isConfirmPasswordActive,
                        isBiometrySwitchActive: arePasswordsEqual,
                        isBiometrySwitchOn: isSwitchOn,
                        isFinishButtonActive: arePasswordsEqual,
                        passwordText: currentPassword) //нужен ли?
                )
            case .failure(_):
                //полагаю тут нужен алерт? какой текст?
                self.didGetUserPermissionForBiometry = false
                Log.i("BiometryPermission failure")
                isSwitchOn = false //в случае отказа - в выключенном.
            }
        }
    }

    private func onFinishPressed() {
        worker?.savePinCode(currentPassword)
        presenter?.presentRouteToTabBarScreen(
            response: SetPinCodeFlow.RoutePayload.Response())
    }

    private func updateOnDidLoad() {
        presenter?.presentUpdate(response: SetPinCodeFlow.Update.Response(
            isConfirmPasswordActive: isConfirmPasswordActive,
            isBiometrySwitchActive: arePasswordsEqual,
            isBiometrySwitchOn: isSwitchOn,
            isFinishButtonActive: arePasswordsEqual,
            passwordText: currentPassword)
        )
    }

    ///Light or Dark theme
    private func observeThemeChanging() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.screenThemeWasChanged,
            object: nil, queue: nil) { _ in
                self.presenter?.presentUpdate(
                    response: SetPinCodeFlow.Update.Response(
                        isConfirmPasswordActive: self.isConfirmPasswordActive,
                        isBiometrySwitchActive: self.arePasswordsEqual,
                        isBiometrySwitchOn: self.isSwitchOn,
                        isFinishButtonActive: self.arePasswordsEqual,
                        passwordText: self.currentPassword)
                    )
            }
    }

    private func observeLangChanging() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.languageWasChangedNotification,
            object: nil, queue: nil) { _ in
                self.presenter?.presentUpdate(
                    response: SetPinCodeFlow.Update.Response(
                        isConfirmPasswordActive: self.isConfirmPasswordActive,
                        isBiometrySwitchActive: self.arePasswordsEqual,
                        isBiometrySwitchOn: self.isSwitchOn,
                        isFinishButtonActive: self.arePasswordsEqual,
                        passwordText: self.currentPassword)
                    )
            }
    }

    private func matchesRegex(_ regex: String, in text: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: text)
    }
}

