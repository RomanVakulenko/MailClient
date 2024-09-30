//
//  ImageFullScreenBuilder.swift
//  SGTS
//
//  Created by Roman Vakulenko on 02.05.2024.
//

import UIKit

protocol ImageFullScreenBuilderProtocol: AnyObject {
    func getController(with image: UIImage,
                       fileNameWithExt: String,
                       mailUidl: String?,
                       size: Int?) -> UIViewController
}

final class ImageFullScreenBuilder: ImageFullScreenBuilderProtocol {

    func getController(with image: UIImage,
                       fileNameWithExt: String,
                       mailUidl: String? = nil,
                       size: Int? = nil) -> UIViewController {

        let viewController = ImageFullScreenController()
        let interactor = ImageFullScreenInteractor(imageToOpen: image,
                                                   fileName: fileNameWithExt,
                                                   mailUidl: mailUidl,
                                                   size: size)
        let presenter = ImageFullScreenPresenter()
        let worker = ImageFullScreenWorker()
        let router = ImageFullScreenRouter()
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
