//
//  SecretKeySelectorInteractor.swift
//  SGTS
//
//  Created by Roman Vakulenko on 12.04.2024.
//

import Foundation
import UIKit

protocol SecretKeySelectorBusinessLogic {
    func onDidLoadViews(request: SecretKeySelectorFlow.OnDidLoadViews.Request)
    func onSelectItem(request: SecretKeySelectorFlow.OnSelectItem.Request)
    func changeInputText(request: SecretKeySelectorFlow.OnSelectItem.Request)
    func didChooseFileWith(url: URL)
    func onBrowserAuthError(request: SecretKeySelectorFlow.OnBrowserAuthError.Request)
}

protocol SecretKeySelectorDataStore: AnyObject {
    var urlToBrowserAuth: String? { get }
}

final class SecretKeySelectorInteractor: SecretKeySelectorBusinessLogic, SecretKeySelectorDataStore {
    
    enum Constants {
        static let minPasswordCount = 2
    }
    // MARK: - Public properties
    
    var presenter: SecretKeySelectorPresentationLogic?
    var worker: SecretKeySelectorWorkingLogic?
    var secretFileData: Data?
    var urlToBrowserAuth: String?
    
    // MARK: - Private properties
    private let storage = DIManager.shared.container.resolve(StorageProtocol.self)!
    private let secretStorage = DIManager.shared.container.resolve(SecretStorageProtocol.self)!
    private let cryptoLayer = DIManager.shared.container.resolve(CryptoLayerProtocol.self)!
    private let userProfileStore = DIManager.shared.container.resolve(UserProfileStoreProtocol.self)!
    
    private var isFileChoosen = false
    private var currentPassword = String()
    private var isNextStepButtonActive: Bool {
        return currentPassword.count > Constants.minPasswordCount
    }

    // MARK: - Lifecycle
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Public methods
    
    func didChooseFileWith(url: URL) {
        presenter?.presentWaitIndicator(
            response: SecretKeySelectorFlow.OnWaitIndicator.Response(isShow: true))
        
        worker?.openFile(url: url) { [weak self] result in
            guard let self else {return}
            presenter?.presentWaitIndicator(
                response: SecretKeySelectorFlow.OnWaitIndicator.Response(isShow: false))
            
            switch result {
            case .success(let data):
                isFileChoosen = true
                let fileNameWithoutExtension = url.deletingPathExtension().lastPathComponent
                
                DispatchQueue.main.async {
                    self.saveData(data: data)
                    
                    self.presenter?.presentUpdate(
                        response: SecretKeySelectorFlow.Update.Response(
                            isNextStepButtonActive: false,
                            isFileChoosen: true,
                            nameOfChoosenFile: fileNameWithoutExtension)
                    )
                }
            case .failure(_):
                presenter?.presentAlert(response: SecretKeySelectorFlow.AlertInfo.Response())
            }
        }
    }
    
    func onDidLoadViews(request: SecretKeySelectorFlow.OnDidLoadViews.Request) {
        observeThemeChanging()
        observeLangChanging()
        updateOnDidLoadViews()
    }
    
    func changeInputText(request: SecretKeySelectorFlow.OnSelectItem.Request) {
        currentPassword = request.selectedString ?? ""
        presenter?.presentChangeNextStepButtonState(response: SecretKeySelectorFlow.ChangeButtonState.Response(isActive: isNextStepButtonActive))
    }
    
    func onSelectItem(request: SecretKeySelectorFlow.OnSelectItem.Request) {
        guard let id = request.id as? SecretKeySelectorModel.MenuItems else {return}
        
        switch id {
        case .title:
            break
        case .cloud:
            onXButtonCloudPressed()
        case .browse:
            chooseKeysFile()
        case .passwordInput:
            break
        case .nextStep:
            onNextStepPressed()
        }
    }
    
    func onBrowserAuthError(request: SecretKeySelectorFlow.OnBrowserAuthError.Request) {
        presenter?.presentAlert(response: SecretKeySelectorFlow.AlertInfo.Response())
    }
    
    //MARK: - Private methods
    
    private func saveData(data: Data) {
        secretFileData = data
    }
    
    private func chooseKeysFile() {
        presenter?.presentFileDialog(response: SecretKeySelectorFlow.OnBrowseButton.Response())
    }
    
    private func onXButtonCloudPressed() {
        isFileChoosen = false
        let response = SecretKeySelectorFlow.Update.Response(
            isNextStepButtonActive: false,
            isFileChoosen: isFileChoosen,
            nameOfChoosenFile: nil)
        presenter?.presentUpdate(response: response)
    }
    
    private func onNextStepPressed() {
        guard let data = self.secretFileData,
              !self.currentPassword.isEmpty
        else {
            presenter?.presentAlert(response: SecretKeySelectorFlow.AlertInfo.Response())
            return
        }
        cryptoLayer.saveUserBin(container: data,
                                password: currentPassword)
        if cryptoLayer.hasUserBin() {
            print("User bin saved")
            presenter?.presentWaitIndicator(response: SecretKeySelectorFlow.OnWaitIndicator.Response(isShow: true))
            worker?.getCertificates(completion: { [weak self] result in
                self?.presenter?.presentWaitIndicator(response: SecretKeySelectorFlow.OnWaitIndicator.Response(isShow: false))
                switch result {
                case .success(let certificates):
                    guard let certSignData = Data(base64Encoded: certificates.cert_sign),
                          let certXchgData = Data(base64Encoded: certificates.cert_xchg)
                    else { return }
                    
                    self?.cryptoLayer.saveCerts(certSign: certSignData,
                                                certXchg: certXchgData)
                    self?.userProfileStore.save(certificate: certificates)
                    self?.openInBrowser()
                case .failure(let error):
                    print(error)
                    self?.presenter?.presentAlert(response: SecretKeySelectorFlow.AlertInfo.Response())
                }
            })
        }
        else {
            presenter?.presentAlert(response: SecretKeySelectorFlow.AlertInfo.Response())
        }
    }
    
    private func openInBrowser() {
        guard let uid = storage.loadContainerSerialNumber()
        else {
            presenter?.presentAlert(response: SecretKeySelectorFlow.AlertInfo.Response())
            return
        }
        let applicationInstance = secretStorage.applicationInstance
        let scope = uid + "%20" + applicationInstance
        let clientId = secretStorage.clientIdFromBrowserAuth
        
        self.urlToBrowserAuth = secretStorage.authWithBrowserLink + clientId + "&state=" + secretStorage.clientStateFromBrowserAuth + "&redirect_uri=" + secretStorage.deepLinkSheme + "://" + secretStorage.deepLinkHost + "&scope=" + scope
        presenter?.presentRouteToBrowserAuth(response: SecretKeySelectorFlow.RoutePayload.Response())
    }
    
    private func updateOnDidLoadViews() {
        let response = SecretKeySelectorFlow.Update.Response(
            isNextStepButtonActive: isNextStepButtonActive,
            isFileChoosen: isFileChoosen,
            nameOfChoosenFile: nil)
        presenter?.presentUpdate(response: response)
    }
    
    ///Light or Dark theme
    private func observeThemeChanging() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.screenThemeWasChanged,
            object: nil, queue: nil) { _ in
                self.presenter?.presentUpdate(response: SecretKeySelectorFlow.Update.Response(
                    isNextStepButtonActive: self.isNextStepButtonActive,
                    isFileChoosen: self.isFileChoosen,
                    nameOfChoosenFile: nil)
                )
            }
    }
    
    private func observeLangChanging() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.languageWasChangedNotification,
            object: nil, queue: nil) { _ in
                self.presenter?.presentUpdate(response: SecretKeySelectorFlow.Update.Response(
                    isNextStepButtonActive: self.isNextStepButtonActive,
                    isFileChoosen: self.isFileChoosen,
                    nameOfChoosenFile: nil)
                )
            }
    }
}
