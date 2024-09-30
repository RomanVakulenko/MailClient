//
//  EnterQRPasswordInteractor.swift
//  SGTS
//
//  Created by Roman Vakulenko on 09.04.2024.
//

import Foundation
import UIKit

protocol EnterQRPasswordBusinessLogic {
    func onDidLoadViews(request: EnterQRPasswordFlow.OnDidLoadViews.Request)
    func onSelectItem(request: EnterQRPasswordFlow.OnSelectItem.Request)
    func changeInputText(request: EnterQRPasswordFlow.OnSelectItem.Request)
}

protocol EnterQRPasswordDataStore: AnyObject {

}

final class EnterQRPasswordInteractor: EnterQRPasswordBusinessLogic, EnterQRPasswordDataStore {

    private enum Constants {
        static let minPasswordCount = 2
    }

    // MARK: - Public properties

    var presenter: EnterQRPasswordPresentationLogic?
    var worker: EnterQRPasswordWorkingLogic?

    // MARK: - Lifecycle
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Private properties

    private var currentPassword = String()
    private var isNextStepButtonActive: Bool {
        return currentPassword.count > Constants.minPasswordCount
    }

    // MARK: - Public methods

    func onDidLoadViews(request: EnterQRPasswordFlow.OnDidLoadViews.Request) {
        observeThemeChanging()
        observeLangChanging()
        update()
    }

    func changeInputText(request: EnterQRPasswordFlow.OnSelectItem.Request) {
        currentPassword = request.selectedString ?? ""
        presenter?.presentChangeNextStepButtonState(response: EnterQRPasswordFlow.ChangeButtonState.Response(isActive: isNextStepButtonActive))
    }

    func onSelectItem(request: EnterQRPasswordFlow.OnSelectItem.Request) {
        guard let id = request.id as? EnterQRPasswordModel.MenuItems else {return}

        switch id {
        case .title:
            break
        case .passwordInput:
            break
        case .nextStep:
            onNextStepPressed()
        }
    }

    //MARK: - Private methods

    private func onNextStepPressed() {
        presenter?.presentRouteToEnterKeyFilePasswordScreen(
            response: EnterQRPasswordFlow.RoutePayload.Response())
    }

    private func update() {
        let response = EnterQRPasswordFlow.Update.Response(isNextStepButtonActive: isNextStepButtonActive)
        presenter?.presentUpdate(response: response)
    }

    ///Light or Dark theme
    private func observeThemeChanging() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.screenThemeWasChanged,
            object: nil, queue: nil) { _ in
                self.presenter?.presentUpdate(response: EnterQRPasswordFlow.Update.Response(isNextStepButtonActive: self.isNextStepButtonActive))
            }
    }

    private func observeLangChanging() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.languageWasChangedNotification,
            object: nil, queue: nil) { _ in
                self.presenter?.presentUpdate(response: EnterQRPasswordFlow.Update.Response(isNextStepButtonActive: self.isNextStepButtonActive))
            }
    }

}
