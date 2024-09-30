//
//  MovePickedEmailsBuilder.swift
//  SGTS
//
//  Created by Roman Vakulenko on 24.05.2024.
//

import UIKit

protocol MovePickedEmailsBuilderProtocol: AnyObject {
    func getControllerWith(pickedEmailIds: Set<AnyHashable>) -> UIViewController
}

final class MovePickedEmailsBuilder: MovePickedEmailsBuilderProtocol {

    func getControllerWith(pickedEmailIds: Set<AnyHashable>) -> UIViewController {
        let viewController = MovePickedEmailsController()
        let interactor = MovePickedEmailsInteractor(pickedEmailIds: pickedEmailIds)
        let presenter = MovePickedEmailsPresenter()
        let worker = MovePickedEmailsWorker()
        let router = MovePickedEmailsRouter()
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
