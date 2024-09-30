//
//  UserProfileChangeNameBuilder.swift
//  SGTS
//
//  Created by Roman Vakulenko on 24.06.2024.
//

import UIKit

protocol UserProfileChangeNameBuilderProtocol: AnyObject {
    func getControllerWith(userFullName: String) -> UIViewController
}

final class UserProfileChangeNameBuilder: UserProfileChangeNameBuilderProtocol {

    func getControllerWith(userFullName: String) -> UIViewController {
        let viewController = UserProfileChangeNameController()
        let interactor = UserProfileChangeNameInteractor(userFullName: userFullName)
        let presenter = UserProfileChangeNamePresenter()
        let worker = UserProfileChangeNameWorker()
        let router = UserProfileChangeNameRouter()
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
