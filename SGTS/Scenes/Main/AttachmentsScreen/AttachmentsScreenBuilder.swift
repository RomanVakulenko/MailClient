//
//  AttachmentsScreenBuilder.swift
//  SGTS
//
//  Created by Roman Vakulenko on 12.06.2024.
//

import UIKit

protocol AttachmentsScreenBuilderProtocol: AnyObject {
    func getController() -> UIViewController
}

final class AttachmentsScreenBuilder: AttachmentsScreenBuilderProtocol {

    func getController() -> UIViewController {
        let viewController = AttachmentsScreenController()
        let interactor = AttachmentsScreenInteractor()
        let presenter = AttachmentsScreenPresenter()
        let worker = AttachmentsScreenWorker()
        let router = AttachmentsScreenRouter()
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
