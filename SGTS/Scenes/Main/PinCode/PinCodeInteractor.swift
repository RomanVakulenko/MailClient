//
//  PinCodeInteractor.swift
//  SGTS
//
//  Created by Roman Vakulenko on 04.04.2024.
//

import Foundation
import LocalAuthentication

protocol PinCodeBusinessLogic {
    func onDidLoadViews(request: PinCodeFlow.OnDidLoadViews.Request)
//    func onSelectItem(request: PinCodeFlow.OnSelectItem.Request)
    func didTapFaceID(request: PinCodeFlow.OnFaceDetection.Request)
    func accessDeinedOrRestricted(request: PinCodeFlow.AlertInfo.Request)
    func didTapDigit(digit: Int)
    func didTapBackspace()
}

protocol PinCodeDataStore: AnyObject {

}

final class PinCodeInteractor: PinCodeBusinessLogic, PinCodeDataStore {

    enum Constants {}

    // MARK: - Public properties

    var presenter: PinCodePresentationLogic?
    var worker: PinCodeWorkingLogic?
    let storage = DIManager.shared.container.resolve(StorageProtocol.self)!

    // MARK: - Private properties

    private var enteredPinDigitsArr = [Int]()


    // MARK: - Lifecycle
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Public methods

    func didTapFaceID(request: PinCodeFlow.OnFaceDetection.Request) {
        DispatchQueue.main.async { [weak self] in
            guard let self else {return}
            if storage.loadIsFaceIdEnable() {
                if self.isFaceIDAllowedBySystem() == true && storage.loadIsFaceIdEnable() {
                    self.presenter?.prepareFaceIdScreening(
                        response: PinCodeFlow.OnFaceDetection.Response())
                }
            } else {
                self.presenter?.presentUpdate(
                    response: PinCodeFlow.Update.Response(pinState: .notEntering,
                                                          amountOfEnteredDigits: 0)
                )
            }
        }
    }

    func accessDeinedOrRestricted(request: PinCodeFlow.AlertInfo.Request) {
        presenter?.presentAlert(
            response: PinCodeFlow.AlertInfo.Response(error: request.error))
    }

    func didTapDigit(digit: Int) {
        enteredPinDigitsArr.append(digit)

        guard enteredPinDigitsArr.count < 5 else {
            enteredPinDigitsArr.removeLast()
            return
        }
        if enteredPinDigitsArr.count == 4 {
            checkPinCode()
        } else {
            let amountOfEnteredDigits = enteredPinDigitsArr.count
            presenter?.presentUpdate(
                response: PinCodeFlow.Update.Response(
                    pinState: .entering,
                    amountOfEnteredDigits: amountOfEnteredDigits)
            )
        }
    }

    func didTapBackspace() {
        if !enteredPinDigitsArr.isEmpty {
            enteredPinDigitsArr.removeLast()
            let amountOfEnteredDigits = enteredPinDigitsArr.count
            presenter?.presentUpdate(
                response: PinCodeFlow.Update.Response(
                    pinState: .deleteOneDigit,
                    amountOfEnteredDigits: amountOfEnteredDigits)
            )
        }
    }

    func onDidLoadViews(request: PinCodeFlow.OnDidLoadViews.Request) {
        observeThemeChanging()
        observeLangChanging()
        didTapFaceID(request: PinCodeFlow.OnFaceDetection.Request())
    }

//    func onSelectItem(request: PinCodeFlow.OnSelectItem.Request) {
//
//    }

    // MARK: - Private methods

    private func checkPinCode() {
        guard let pinCode = Storage.shared.loadPinCode(),
            let storedPinCode = stringToDigitArray(pinCode)
        else { return }
        
        let userName = KeychainService.getBoolValue(forKey: "yourAppID_storedUserName")

        if enteredPinDigitsArr == storedPinCode {
            Log.i("user \(String(describing: userName)) entered pin code - success")
            // 1. Закрасить 4й кружок чёрным, записать в лог "user \username enter pin code successfully" (username брать из keychain идентификатор id приложения + storedUsername).
            presenter?.presentUpdate(
                response: PinCodeFlow.Update.Response(
                    pinState: .ok,
                    amountOfEnteredDigits: enteredPinDigitsArr.count)
            )
            presenter?.presentRouteToNextScreen(response: PinCodeFlow.RoutePayload.Response())
        } else  {
            Log.i("user \(String(describing: userName)) entered pin code - failure")
            //1. Все кружочки закрашиваются красным цветом
            presenter?.presentUpdate(
                response: PinCodeFlow.Update.Response(
                    pinState: .bad,
                    amountOfEnteredDigits: enteredPinDigitsArr.count)
            )
        }
    }

    private func isFaceIDAllowedBySystem() -> Bool {
        let context = LAContext()
        let isFaceIDAvailable = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        let isFaceIDAllowed = context.biometryType == .faceID
        return isFaceIDAllowed && isFaceIDAvailable
    }

    ///Light or Dark theme
    private func observeThemeChanging() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.screenThemeWasChanged,
            object: nil, queue: nil) { _ in
                self.presenter?.presentUpdate(response: PinCodeFlow.Update.Response(
                    pinState: .notEntering,
                    amountOfEnteredDigits: 0))
            }
    }

    private func observeLangChanging() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.languageWasChangedNotification,
            object: nil, queue: nil) { _ in
                self.presenter?.presentUpdate(response: PinCodeFlow.Update.Response(
                    pinState: .notEntering,
                    amountOfEnteredDigits: 0))
            }
    }

    private func stringToDigitArray(_ input: String) -> [Int]? {
        // Преобразование строки в массив символов
        let characters = Array(input)
        
        // Преобразование символов в цифры
        let digitArray = characters.compactMap { character -> Int? in
            if let digit = Int(String(character)) {
                return digit
            }
            return nil
        }
        
        return digitArray
    }
}
