//
//  EnterPasswordAfterQRInteractor.swift
//  SGTS
//
//  Created by Roman Vakulenko on 09.04.2024.
//

import Foundation
import UIKit

protocol EnterPasswordAfterQRBusinessLogic {
    func onDidLoadViews(request: EnterPasswordAfterQRFlow.OnDidLoadViews.Request)
    func onSelectItem(request: EnterPasswordAfterQRFlow.OnSelectItem.Request)
    func changeInputText(request: EnterPasswordAfterQRFlow.OnSelectItem.Request)
}

protocol EnterPasswordAfterQRDataStore: AnyObject {

}

final class EnterPasswordAfterQRInteractor: EnterPasswordAfterQRBusinessLogic, EnterPasswordAfterQRDataStore {

    private enum Constants {
        static let minPasswordCount = 2
    }
    
    var presenter: EnterPasswordAfterQRPresentationLogic?
    var worker: EnterPasswordAfterQRWorkingLogic?

    var currentPassword = String()
    var isNextStepButtonActive: Bool {
        return currentPassword.count > Constants.minPasswordCount
    }

    // MARK: - Lifecycle
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Public methods

    func onDidLoadViews(request: EnterPasswordAfterQRFlow.OnDidLoadViews.Request) {
        observeThemeChanging()
        observeLangChanging()
        update()
    }

    func changeInputText(request: EnterPasswordAfterQRFlow.OnSelectItem.Request) {
        currentPassword = request.selectedString ?? ""
        presenter?.presentChangeNextStepButtonState(response: EnterPasswordAfterQRFlow.ChangeButtonState.Response(isActive: isNextStepButtonActive))
    }

    func onSelectItem(request: EnterPasswordAfterQRFlow.OnSelectItem.Request) {
        guard let id = request.id as? EnterPasswordAfterQRModel.MenuItems else {return}

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
        presenter?.presentRouteToEnterQRPassword(
            response: EnterPasswordAfterQRFlow.RoutePayload.Response())
    }

    private func update() {
        let response = EnterPasswordAfterQRFlow.Update.Response(isNextStepButtonActive: isNextStepButtonActive)
        presenter?.presentUpdate(response: response)
    }

    ///Light or Dark theme
    private func observeThemeChanging() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.screenThemeWasChanged,
            object: nil, queue: nil) { _ in
                self.presenter?.presentUpdate(response: EnterPasswordAfterQRFlow.Update.Response(isNextStepButtonActive: self.isNextStepButtonActive))
            }
    }

    private func observeLangChanging() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.languageWasChangedNotification,
            object: nil, queue: nil) { _ in
                self.presenter?.presentUpdate(response: EnterPasswordAfterQRFlow.Update.Response(isNextStepButtonActive: self.isNextStepButtonActive))
            }
    }

}
