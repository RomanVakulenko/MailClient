//
//  MovePickedEmailsInteractor.swift
//  SGTS
//
//  Created by Roman Vakulenko on 24.05.2024.
//

import Foundation
import UIKit

protocol MovePickedEmailsBusinessLogic {
    func onDidLoadViews(request: MovePickedEmailsFlow.OnDidLoadViews.Request)

    func didTapAtAlreadySent(request: MovePickedEmailsFlow.RoutePayload.Request)
    func didTapToDraft(request: MovePickedEmailsFlow.RoutePayload.Request)
    func didTapToArchive(request: MovePickedEmailsFlow.RoutePayload.Request)
    func didTapToDeleted(request: MovePickedEmailsFlow.RoutePayload.Request)

    func didTapCancel(request: MovePickedEmailsFlow.RoutePayload.Request)
}

protocol MovePickedEmailsDataStore: AnyObject {

}

final class MovePickedEmailsInteractor: MovePickedEmailsBusinessLogic, MovePickedEmailsDataStore {

    // MARK: - Public properties

    var presenter: MovePickedEmailsPresentationLogic?
    var worker: MovePickedEmailsWorkingLogic?

    // MARK: - Private properties

    private var pickedEmailIdsSet: Set<AnyHashable>


    // MARK: - Lifecycle
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    init(pickedEmailIds: Set<AnyHashable>) {
        self.pickedEmailIdsSet = pickedEmailIds
    } 

    // MARK: - Public methods

    func onDidLoadViews(request: MovePickedEmailsFlow.OnDidLoadViews.Request) {
        observeThemeChanging()
        observeLangChanging()
        presenter?.presentUpdate(response: MovePickedEmailsFlow.Update.Response())
    }
                                 
    func didTapAtAlreadySent(request: MovePickedEmailsFlow.RoutePayload.Request) {

    }

    func didTapToDraft(request: MovePickedEmailsFlow.RoutePayload.Request) {

    }

    func didTapToArchive(request: MovePickedEmailsFlow.RoutePayload.Request) {

    }

    func didTapToDeleted(request: MovePickedEmailsFlow.RoutePayload.Request) {
        
    }

    func didTapCancel(request: MovePickedEmailsFlow.RoutePayload.Request) {
        presenter?.presentRouteBackToEmailPickingScreen(response: MovePickedEmailsFlow.RoutePayload.Response())
    }


    //MARK: - Private methods

    ///Light or Dark theme
    private func observeThemeChanging() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.screenThemeWasChanged,
            object: nil, queue: nil) { [weak self] _ in
                guard let self else {return}
                self.presenter?.presentUpdate(response: MovePickedEmailsFlow.Update.Response())
            }
    }

    private func observeLangChanging() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.languageWasChangedNotification,
            object: nil, queue: nil) { [weak self] _ in
                guard let self else {return}
                self.presenter?.presentUpdate(response: MovePickedEmailsFlow.Update.Response())
            }
    }

}
