//
//  UserProfileSetSignatureInteractor.swift
//  SGTS
//
//  Created by Roman Vakulenko on 28.06.2024.
//

import Foundation
import UIKit
protocol UserProfileSetSignatureBusinessLogic {
    func onDidLoadViews(request: UserProfileSetSignatureFlow.OnDidLoadViews.Request)
    func onSelectItem(request: UserProfileSetSignatureFlow.OnSelectItem.Request)
    func disableSaveButton()
}

protocol UserProfileSetSignatureDataStore: AnyObject {
    var newSignature: String { get }
}

final class UserProfileSetSignatureInteractor: UserProfileSetSignatureBusinessLogic, UserProfileSetSignatureDataStore {

    // MARK: - Public properties

    var presenter: UserProfileSetSignaturePresentationLogic?
    var worker: UserProfileSetSignatureWorkingLogic?
    var newSignature = String()

    // MARK: - Private properties

    private var currentSignature = String() //may be will be inited with some value or tken from Database
    private var isNewSignatureDifferent: Bool { //input for finishBtn
        currentSignature != newSignature
    }

    // MARK: - Lifecycle
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Public methods

    func onDidLoadViews(request: UserProfileSetSignatureFlow.OnDidLoadViews.Request) {
        observeThemeChanging()
        observeLangChanging()
        if let savedSignature = UserDefaults.standard.string(forKey: GlobalConstants.userSignature) {
            currentSignature = savedSignature
        }
        presenter?.presentUpdate(response: UserProfileSetSignatureFlow.Update.Response(
            isFinishButtonActive: false,
            signature: currentSignature))
    }

    func onSelectItem(request: UserProfileSetSignatureFlow.OnSelectItem.Request) {
        guard let id = request.id as? UserProfileSetSignatureModel.MenuItems else {return}

        switch id {
        case .signField:
            newSignature = request.enteredText ?? ""
            presenter?.presentFinishRegistrationButtonState(response: UserProfileSetSignatureFlow.ChangeButtonState.Response(isActive: isNewSignatureDifferent))
        case .saveButton:
            if isNewSignatureDifferent {
                presenter?.presentRouteToSavePincode(response: UserProfileSetSignatureFlow.RoutePayload.Response())
            }
        case .cancelButton:
            presenter?.presentRouteBackToUserProfile(response: UserProfileSetSignatureFlow.RoutePayload.Response())
        }
    }

    func disableSaveButton() {
        presenter?.presentFinishRegistrationButtonState(response: UserProfileSetSignatureFlow.ChangeButtonState.Response(isActive: false))
    }

    //MARK: - Private methods

    ///Light or Dark theme
    private func observeThemeChanging() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.screenThemeWasChanged,
            object: nil, queue: nil) { _ in
                self.presenter?.presentUpdate(
                    response: UserProfileSetSignatureFlow.Update.Response(
                        isFinishButtonActive: self.isNewSignatureDifferent,
                                                signature: self.newSignature))
            }
    }

    private func observeLangChanging() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.languageWasChangedNotification,
            object: nil, queue: nil) { _ in
                self.presenter?.presentUpdate(
                    response: UserProfileSetSignatureFlow.Update.Response(
                        isFinishButtonActive: self.isNewSignatureDifferent,
                                                signature: self.newSignature))
            }
    }

}

