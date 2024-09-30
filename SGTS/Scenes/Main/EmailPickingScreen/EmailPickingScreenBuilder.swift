//
//  EmailPickingScreenBuilder.swift
//  SGTS
//
//  Created by Roman Vakulenko on 20.05.2024.
//

import UIKit

protocol EmailPickingScreenBuilderProtocol: AnyObject {
    func getControllerWith(pickedEmailId: String, 
                           mailsForDisplay: [EmailMessageWithNeededProperties],
                           messageTypeFromSideMenu: TabBarManager.MessageType) -> UIViewController
}

final class EmailPickingScreenBuilder: EmailPickingScreenBuilderProtocol {

    func getControllerWith(pickedEmailId: String,
                           mailsForDisplay: [EmailMessageWithNeededProperties],
                           messageTypeFromSideMenu: TabBarManager.MessageType) -> UIViewController {
        let viewController = EmailPickingScreenController()
        let interactor = EmailPickingScreenInteractor(pickedEmailId: pickedEmailId, 
                                                      mailsForDisplay: mailsForDisplay,
                                                      messageTypeFromSideMenu: messageTypeFromSideMenu)
        let presenter = EmailPickingScreenPresenter()
        let worker = EmailPickingScreenWorker()
        let router = EmailPickingScreenRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
        return viewController
    }
}
