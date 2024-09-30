//
//  InitialBuilder.swift
// 01.04.2024.
//

import UIKit

protocol InitialBuilderProtocol: AnyObject {
    func getController() -> UIViewController
}

final class InitialBuilder: InitialBuilderProtocol {

    func getController() -> UIViewController {
        let viewController = InitialController()
        let interactor = InitialInteractor()
        let presenter = InitialPresenter()
        let worker = InitialWorker()
        let router = InitialRouter()
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
