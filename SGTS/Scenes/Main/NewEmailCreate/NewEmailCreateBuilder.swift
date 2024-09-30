//
//  NewEmailCreateBuilder.swift
//  SGTS
//
//  Created by Roman Vakulenko on 02.05.2024.
//

import UIKit

protocol NewEmailCreateBuilderProtocol: AnyObject {
//    func getControllerWith(id: String?,
//                           senderEmailAddressOfIncomingEmail: String?,
//                           pickedEmailAddresses: [String]?,
//                           emailSubject: String?,
//                           emailType: NewEmailCreateModels.NewReOrFwdEmailType) -> UIViewController

    func getControllerWith(messageModel: EmailMessageModel?,
                           pickedEmailAddresses: [String]?,
                           emailType: NewEmailCreateModels.NewReOrFwdEmailType) -> UIViewController
}

final class NewEmailCreateBuilder: NewEmailCreateBuilderProtocol {

    func getControllerWith(messageModel: EmailMessageModel?,
                           pickedEmailAddresses: [String]?,
                           emailType: NewEmailCreateModels.NewReOrFwdEmailType) -> UIViewController {
        let viewController = NewEmailCreateController()
        let interactor = NewEmailCreateInteractor(
            messageModel: messageModel,
            pickedEmailAddresses: pickedEmailAddresses,
            emailType: emailType)
//        let interactor = NewEmailCreateInteractor(
//            mailLUID: id,
//            senderEmailAddressOfIncomingEmail: senderEmailAddressOfIncomingEmail,
//            pickedEmailAddresses: pickedEmailAddresses,
//            emailSubject: emailSubject,
//            emailType: emailType)
        let presenter = NewEmailCreatePresenter()
        let worker = NewEmailCreateWorker()
        let router = NewEmailCreateRouter()
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
