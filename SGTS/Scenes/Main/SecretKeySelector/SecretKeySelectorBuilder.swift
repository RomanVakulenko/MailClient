//
//  SecretKeySelectorBuilder.swift
//  SGTS
//
//  Created by Roman Vakulenko on 12.04.2024.
//

import UIKit

protocol SecretKeySelectorBuilderProtocol: AnyObject {
    func getController() -> UIViewController
}

final class SecretKeySelectorBuilder: SecretKeySelectorBuilderProtocol {
    private let storage: StorageProtocol = DIManager.shared.container.resolve(StorageProtocol.self)!
    
    func getController() -> UIViewController {
        let viewController = SecretKeySelectorController()
        let interactor = SecretKeySelectorInteractor()
        let presenter = SecretKeySelectorPresenter()
        let worker = SecretKeySelectorWorker()
        let router = SecretKeySelectorRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
        storage.setCurrentControllerLink(viewController)
        return viewController
    }
}
