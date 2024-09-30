//
//  AboutAppScreenBuilder.swift
//  SGTS
//
//  Created by Roman Vakulenko on 24.06.2024.
//

import UIKit

protocol AboutAppScreenBuilderProtocol: AnyObject {
    func getController() -> UIViewController
}

final class AboutAppScreenBuilder: AboutAppScreenBuilderProtocol {

    func getController() -> UIViewController {
        let viewController = AboutAppScreenController()
        let interactor = AboutAppScreenInteractor()
        let presenter = AboutAppScreenPresenter()
        let worker = AboutAppScreenWorker()
        let router = AboutAppScreenRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        return viewController
    }
}
