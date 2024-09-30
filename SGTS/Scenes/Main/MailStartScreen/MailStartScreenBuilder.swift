//
//  MailStartScreenBuilder.swift
//  SGTS
//
//  Created by Roman Vakulenko on 17.04.2024.
//

import UIKit

protocol MailStartScreenBuilderProtocol: AnyObject {
    func getControllerFor(messageType: TabBarManager.MessageType) -> UIViewController
}


final class MailStartScreenBuilder: MailStartScreenBuilderProtocol {
    func getControllerFor(messageType: TabBarManager.MessageType) -> UIViewController {
        let viewController = MailStartScreenController(messageType: messageType)
        let presenter = MailStartScreenPresenter()
        let router = MailStartScreenRouter()

        viewController.router = router
        presenter.viewController = viewController
        router.viewController = viewController

        switch messageType {
        case .incoming:
            let interactor = MailStartScreenInteractor()
            let worker: MailStartScreenWorkingLogic = MailStartScreenWorker()

            viewController.interactor = interactor
            interactor.presenter = presenter
            interactor.worker = worker
            router.dataStore = interactor

        case .sent:
            let interactor = SentInteractor()
            let worker: SentWorkingLogic = SentWorker()

            viewController.interactor = interactor
            interactor.presenter = presenter
            interactor.worker = worker
            router.dataStore = interactor

        case .outgoing:
            let interactor = OutgoingInteractor()
            let worker: OutgoingWorkingLogic = OutgoingWorker()

            viewController.interactor = interactor
            interactor.presenter = presenter
            interactor.worker = worker
            router.dataStore = interactor

        case .drafts:
            let interactor = DraftsInteractor()
            let worker: DraftsWorkingLogic = DraftsWorker()

            viewController.interactor = interactor
            interactor.presenter = presenter
            interactor.worker = worker
            router.dataStore = interactor

        case .archived:
            let interactor = ArchivedInteractor()
            let worker: ArchivedWorkingLogic = ArchivedWorker()

            viewController.interactor = interactor
            interactor.presenter = presenter
            interactor.worker = worker
            router.dataStore = interactor

        case .deleted:
            let interactor = DeletedInteractor()
            let worker: DeletedWorkingLogic = DeletedWorker()

            viewController.interactor = interactor
            interactor.presenter = presenter
            interactor.worker = worker
            router.dataStore = interactor
        default:
            let interactor = MailStartScreenInteractor()
            let worker = MailStartScreenWorker()

            viewController.interactor = interactor
            interactor.presenter = presenter
            interactor.worker = worker
            router.dataStore = interactor
        }
        return viewController
    }
}
