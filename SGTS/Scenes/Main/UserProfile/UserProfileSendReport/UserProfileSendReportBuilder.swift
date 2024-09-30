//
//  UserProfileSendReportBuilder.swift
//  SGTS
//
//  Created by Roman Vakulenko on 02.07.2024.
//

import UIKit

protocol UserProfileSendReportBuilderProtocol: AnyObject {
    func getController() -> UIViewController
}

final class UserProfileSendReportBuilder: UserProfileSendReportBuilderProtocol {

    func getController() -> UIViewController {
        let viewController = UserProfileSendReportController()
        let interactor = UserProfileSendReportInteractor()
        let presenter = UserProfileSendReportPresenter()
        let worker = UserProfileSendReportWorker()
        let router = UserProfileSendReportRouter()
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
