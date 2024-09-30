//
//  AboutAppScreenInteractor.swift
//  SGTS
//
//  Created by Roman Vakulenko on 24.06.2024.
//

import Foundation
import UIKit

protocol AboutAppScreenBusinessLogic {
    func onDidLoadViews(request: AboutAppScreenFlow.OnDidLoadViews.Request)
    func didTapCancel(request: AboutAppScreenFlow.RoutePayload.Request)
    func onFiveTap(request: AboutAppScreenFlow.RoutePayload.Request)
}


final class AboutAppScreenInteractor: AboutAppScreenBusinessLogic {

    // MARK: - Public properties

    var presenter: AboutAppScreenPresentationLogic?
    var worker: AboutAppScreenWorkingLogic?

    // MARK: - Public methods

    func onDidLoadViews(request: AboutAppScreenFlow.OnDidLoadViews.Request) {
        observeThemeChanging()
        observeLangChanging()

        presenter?.presentUpdate(response: AboutAppScreenFlow.Update.Response())
    }

    func didTapCancel(request: AboutAppScreenFlow.RoutePayload.Request) {
        presenter?.presentRouteBack(response: AboutAppScreenFlow.RoutePayload.Response())
    }
    
    func onFiveTap(request: AboutAppScreenFlow.RoutePayload.Request) {
        presenter?.presentRouteSendLogs(response: AboutAppScreenFlow.RoutePayload.Response())
    }
    
    // MARK: - Lifecycle
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    //MARK: - Private methods

    ///Light or Dark theme
    private func observeThemeChanging() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.screenThemeWasChanged,
            object: nil, queue: nil) { [weak self] _ in
                guard let self else {return}
                self.presenter?.presentUpdate(response: AboutAppScreenFlow.Update.Response())
            }
    }

    private func observeLangChanging() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.languageWasChangedNotification,
            object: nil, queue: nil) { [weak self] _ in
                guard let self else {return}
                self.presenter?.presentUpdate(response: AboutAppScreenFlow.Update.Response())
            }
    }

}
