//
//  MovePickedEmailsPresenter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 24.05.2024.
//

import UIKit
import DifferenceKit
import SnapKit

protocol MovePickedEmailsPresentationLogic {
    func presentUpdate(response: MovePickedEmailsFlow.Update.Response)
    //    func presentWaitIndicator(response: MovePickedEmailsFlow.OnWaitIndicator.Response)
    //    func presentAlert(response: MovePickedEmailsFlow.AlertInfo.Response)
    func presentRouteBackToEmailPickingScreen(response: MovePickedEmailsFlow.RoutePayload.Response)
}


final class MovePickedEmailsPresenter: MovePickedEmailsPresentationLogic {
    
    //    enum Constants {
    //    }
    
    // MARK: - Public properties
    
    weak var viewController: MovePickedEmailsDisplayLogic?
    
    // MARK: - Public methods
    
    func presentRouteBackToEmailPickingScreen(response: MovePickedEmailsFlow.RoutePayload.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteBackToEmailPickingScreen(viewModel: MovePickedEmailsFlow.RoutePayload.ViewModel())
        }
    }
    
    func presentUpdate(response: MovePickedEmailsFlow.Update.Response) {
        
        let grayViewColor = Theme.shared.isLight ? UIHelper.Color.grayAlpha06 : UIHelper.Color.blackLightD
        
        let extendedMenuMoveToColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.almostBlackD
        
        let titleOfExtendedMenu = NSAttributedString(
            string: getString(.moveEmailTo),
            attributes: Theme.shared.isLight ? UIHelper.Attributed.blackMiddleLRobotoSemibold20 : UIHelper.Attributed.whiteStrongRobotoSemibold20)
        
        let fontAndColorAttributesForTitles = Theme.shared.isLight ? UIHelper.Attributed.grayAlpha06RobotoRegular14 : UIHelper.Attributed.whiteDarkDRobotoRegular14
        
        let toAlreadySentTitle = NSAttributedString(string: getString(.alreadySentMessage),
                                                    attributes: fontAndColorAttributesForTitles)
        let toDraftsTitle = NSAttributedString(string: getString(.draftMessages),
                                               attributes: fontAndColorAttributesForTitles)
        let toArchiveTitle = NSAttributedString(string: getString(.archivedMessages),
                                                attributes: fontAndColorAttributesForTitles)
        let toDeletedTitle = NSAttributedString(string: getString(.deletedMessages),
                                                attributes: fontAndColorAttributesForTitles)
        
        let cancelTitle = NSAttributedString(string: getString(.сancelTitle),
                                             attributes: UIHelper.Attributed.blueRobotoRegular14)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayUpdate(viewModel: MovePickedEmailsFlow.Update.ViewModel(
                grayViewColor: grayViewColor,
                extendedMenuMoveToColor: extendedMenuMoveToColor,
                titleOfExtendedMenu: titleOfExtendedMenu,
                toAlreadySentTitle: toAlreadySentTitle,
                toDraftsTitle: toDraftsTitle,
                toArchiveTitle: toArchiveTitle,
                toDeletedTitle: toDeletedTitle,
                cancelTitle: cancelTitle)
            )
        }
    }
}


