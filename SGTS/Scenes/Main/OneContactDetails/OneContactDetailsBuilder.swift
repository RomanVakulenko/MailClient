//
//  OneContactDetailsBuilder.swift
//  SGTS
//
//  Created by Roman Vakulenko on 31.07.2024.
//

import UIKit

protocol OneContactDetailsBuilderProtocol: AnyObject {
    func getControllerWith(contactStruct: ContactListItem,
//                           allEmailsInDataBase: [String],//нужно, если будем возвращаться сразу в поле кому/копия
                           delegate: OneContactDetailsDelegate?,
                           isMultiPickingMode: Bool) -> UIViewController
}


final class OneContactDetailsBuilder: OneContactDetailsBuilderProtocol {

    func getControllerWith(contactStruct: ContactListItem,
//                           allEmailsInDataBase: [String],//нужно, если будем возвращаться сразу в поле кому/копия
                           delegate: OneContactDetailsDelegate?,
                           isMultiPickingMode: Bool) -> UIViewController {

        let viewController = OneContactDetailsController(delegate: delegate)
        let interactor = OneContactDetailsInteractor(contactStruct: contactStruct,
//                                                     allEmailsInDataBase: allEmailsInDataBase,
                                                     isMultiPickingMode: isMultiPickingMode)
        let presenter = OneContactDetailsPresenter()
        let worker = OneContactDetailsWorker()
        let router = OneContactDetailsRouter()
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
