//
//  UserProfileChangePinCodeBuilder.swift
//  SGTS
//
//  Created by Roman Vakulenko on 28.06.2024.
//

import UIKit

protocol UserProfileChangePinCodeBuilderProtocol: AnyObject {
    func getController() -> UIViewController
}

final class UserProfileChangePinCodeBuilder: UserProfileChangePinCodeBuilderProtocol {

    func getController() -> UIViewController {
        let viewController = UserProfileChangePinCodeController()
        let interactor = UserProfileChangePinCodeInteractor()
        let presenter = UserProfileChangePinCodePresenter()
        let worker = UserProfileChangePinCodeWorker()
        let router = UserProfileChangePinCodeRouter()
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
