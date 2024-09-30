//
//  EnterQRPasswordBuilder.swift
//  SGTS
//
//  Created by Roman Vakulenko on 09.04.2024.
//

import UIKit

protocol EnterQRPasswordBuilderProtocol: AnyObject {
    func getController() -> UIViewController
}

final class EnterQRPasswordBuilder: EnterQRPasswordBuilderProtocol {

    func getController() -> UIViewController {
        let viewController = EnterQRPasswordController()
        let interactor = EnterQRPasswordInteractor()
        let presenter = EnterQRPasswordPresenter()
        let worker = EnterQRPasswordWorker()
        let router = EnterQRPasswordRouter()
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
