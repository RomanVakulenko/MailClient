//
//  PinCodeBuilder.swift
//  SGTS
//
//  Created by Roman Vakulenko on 04.04.2024.
//

import UIKit

protocol PinCodeBuilderProtocol: AnyObject {
    func getController() -> UIViewController
}

final class PinCodeBuilder: PinCodeBuilderProtocol {

    func getController() -> UIViewController {
        let viewController = PinCodeController()
        let interactor = PinCodeInteractor()
        let presenter = PinCodePresenter()
        let worker = PinCodeWorker()
        let router = PinCodeRouter()
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
