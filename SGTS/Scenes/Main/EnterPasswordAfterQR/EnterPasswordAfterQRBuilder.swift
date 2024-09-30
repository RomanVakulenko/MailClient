//
//  EnterPasswordAfterQRBuilder.swift
//  SGTS
//
//  Created by Roman Vakulenko on 09.04.2024.
//

import UIKit

protocol EnterPasswordAfterQRBuilderProtocol: AnyObject {
    func getController() -> UIViewController
}

final class EnterPasswordAfterQRBuilder: EnterPasswordAfterQRBuilderProtocol {

    func getController() -> UIViewController {
        let viewController = EnterPasswordAfterQRController()
        let interactor = EnterPasswordAfterQRInteractor()
        let presenter = EnterPasswordAfterQRPresenter()
        let worker = EnterPasswordAfterQRWorker()
        let router = EnterPasswordAfterQRRouter()
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
