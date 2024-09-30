//
//  UserProfileBuilder.swift
//  SGTS
//
//  Created by Roman Vakulenko on 16.06.2024.
//

import UIKit

protocol UserProfileBuilderProtocol: AnyObject {
    func getController() -> UIViewController
}

final class UserProfileBuilder: UserProfileBuilderProtocol {

    func getController() -> UIViewController {
        let viewController = UserProfileController()
        let interactor = UserProfileInteractor()
        let presenter = UserProfilePresenter()
        let worker = UserProfileWorker()
        let router = UserProfileRouter()
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
