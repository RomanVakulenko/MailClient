//
//  UserProfileSetSignatureBuilder.swift
//  SGTS
//
//  Created by Roman Vakulenko on 28.06.2024.
//

import UIKit

protocol UserProfileSetSignatureBuilderProtocol: AnyObject {
    func getController() -> UIViewController
}

final class UserProfileSetSignatureBuilder: UserProfileSetSignatureBuilderProtocol {

    func getController() -> UIViewController {
        let viewController = UserProfileSetSignatureController()
        let interactor = UserProfileSetSignatureInteractor()
        let presenter = UserProfileSetSignaturePresenter()
        let worker = UserProfileSetSignatureWorker()
        let router = UserProfileSetSignatureRouter()
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
