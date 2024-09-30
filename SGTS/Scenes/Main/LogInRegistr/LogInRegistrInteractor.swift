//
//  LogInRegistrInteractor.swift
//  SGTS
//
//  Created by Roman Vakulenko on 03.04.2024.
//

import Foundation

protocol LogInRegistrBusinessLogic {
    func onDidLoadViews(request: LogInRegistrFlow.OnDidLoadViews.Request)
    func onDidTapButtonLoadKeys(request: LogInRegistrFlow.OnTapLoadKeys.Request)
    func onDidTapButtonQRScan(request: LogInRegistrFlow.OnTapQRScan.Request)
}

protocol LogInRegistrDataStore: AnyObject {

}


final class LogInRegistrInteractor: LogInRegistrBusinessLogic, LogInRegistrDataStore {

    // MARK: - Public properties
    var presenter: LogInRegistrPresentationLogic?
    var worker: LogInRegistrWorkingLogic?

    // MARK: - Lifecycle
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Public methods

    func onDidLoadViews(request: LogInRegistrFlow.OnDidLoadViews.Request) {
        observeThemeChanging()
        observeLangChanging()
        presenter?.presentUpdate(response: LogInRegistrFlow.Update.Response(version: getAppVersionAndBuild().0))
    }

    func onDidTapButtonLoadKeys(request: LogInRegistrFlow.OnTapLoadKeys.Request) {
        presenter?.presentRouteToSecretKeySelectorScreen(response: LogInRegistrFlow.RoutePayload.Response())
        Log.i("pressed load key file button")
    }

    func onDidTapButtonQRScan(request: LogInRegistrFlow.OnTapQRScan.Request) {
        presenter?.presentRouteToQRScanScreen(response: LogInRegistrFlow.RoutePayload.Response())
        Log.i("pressed scan QR code button")
    }

    private func getAppVersionAndBuild() -> (version: String, build: String) {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
        return (version, build)
    }

    // MARK: - Private methods

    ///Light or Dark theme
    private func observeThemeChanging() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.screenThemeWasChanged,
            object: nil, queue: nil) { [weak self] _ in
                guard let self else {return}
                presenter?.presentUpdate(response: LogInRegistrFlow.Update.Response(version: getAppVersionAndBuild().0))
            }
    }

    private func observeLangChanging() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.languageWasChangedNotification,
            object: nil, queue: nil) { [weak self] _ in
                guard let self else {return}
                presenter?.presentUpdate(response: LogInRegistrFlow.Update.Response(version: getAppVersionAndBuild().0))
            }
    }
}
