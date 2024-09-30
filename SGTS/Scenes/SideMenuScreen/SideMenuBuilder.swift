//
//  SideMenuBuilder.swift
//  SGTS
//
//  Created by Roman Vakulenko on 03.07.2024.
//

import UIKit

protocol SideMenuBuilderProtocol: AnyObject {
    func getController() -> UIViewController
}

final class SideMenuBuilder: SideMenuBuilderProtocol {
    
    func getController() -> UIViewController {
        let viewController = SideMenuController()
        let interactor = SideMenuInteractor()
        let presenter = SideMenuPresenter()
        let worker = SideMenuWorker()
        let router = SideMenuRouter()
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
