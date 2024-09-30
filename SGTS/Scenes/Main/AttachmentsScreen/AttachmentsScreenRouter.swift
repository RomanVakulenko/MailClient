//
//  AttachmentsScreenRouter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 12.06.2024.
//

import Foundation
import UIKit

protocol AttachmentsScreenRoutingLogic {
    func openInOtherApp()
    func routeToSideMenu()

//    func routeToEmailPickingScreen(viewModel: AttachmentsScreenFlow.OnLongPressGestureTap.ViewModel)
}

protocol AttachmentsScreenDataPassing {
    var dataStore: AttachmentsScreenDataStore? { get }
}


final class AttachmentsScreenRouter: AttachmentsScreenRoutingLogic, AttachmentsScreenDataPassing {

    weak var viewController: AttachmentsScreenController?
    weak var dataStore: AttachmentsScreenDataStore?

    // MARK: - Public methods

//    func routeToEmailPickingScreen(viewModel: AttachmentsScreenFlow.OnLongPressGestureTap.ViewModel) {
//        let controller = EmailPickingScreenBuilder().getControllerWith(pickedEmailId: viewModel.id)
//        DispatchQueue.main.async { [weak self] in
//            self?.viewController?.navigationController?.pushViewController(controller, animated: true)
//        }
//    }
    func routeToSideMenu() {
        let sideMenuController = SideMenuBuilder().getController()

        sideMenuController.modalPresentationStyle = .custom
        sideMenuController.modalTransitionStyle = .coverVertical

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.present(sideMenuController, animated: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self?.viewController?.tabBarController?.tabBar.layer.zPosition = -1
                self?.viewController?.tabBarController?.tabBar.isUserInteractionEnabled = false
            }
        }
    }

    func openInOtherApp()  {
        guard let fileURL = dataStore?.oneAttachmentToOpenInOtheApp?.urlInProgrammsDirectory,
              let vc = viewController else { return }

        let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        // Устранение проблемы на iPad
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = vc.view
            popoverController.sourceRect = CGRect(x: vc.view.bounds.midX, y: vc.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        vc.present(activityViewController, animated: true, completion: nil)
    }

}
