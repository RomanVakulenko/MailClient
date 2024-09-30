//
//  SetPinCodeBuilder.swift
//  SGTS
//
//  Created by Roman Vakulenko on 16.04.2024.
//

import UIKit

protocol SetPinCodeBuilderProtocol: AnyObject {
    func getController() -> UIViewController
}

final class SetPinCodeBuilder: SetPinCodeBuilderProtocol {

    func getController() -> UIViewController {
        let viewController = SetPinCodeController()
        let interactor = SetPinCodeInteractor()
        let presenter = SetPinCodePresenter()
        let worker = SetPinCodeWorker()
        let router = SetPinCodeRouter()
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
