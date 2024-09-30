//
//  UserProfileChangeNamePresenter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 24.06.2024.
//

import UIKit
import DifferenceKit
import SnapKit

protocol UserProfileChangeNamePresentationLogic {
    func presentUpdate(response: UserProfileChangeNameFlow.Update.Response)
    func presentWaitIndicator(response: UserProfileChangeNameFlow.OnWaitIndicator.Response)
    func presentAlert(response: UserProfileChangeNameFlow.AlertInfo.Response)
    func presentRouteBack(response: UserProfileChangeNameFlow.RoutePayload.Response)
}


final class UserProfileChangeNamePresenter: UserProfileChangeNamePresentationLogic {
    
    //    enum Constants {
    //    }
    
    // MARK: - Public properties
    
    weak var viewController: UserProfileChangeNameDisplayLogic?
    
    // MARK: - Public methods
    
    func presentRouteBack(response: UserProfileChangeNameFlow.RoutePayload.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteBack(viewModel: UserProfileChangeNameFlow.RoutePayload.ViewModel())
        }
    }

    func presentWaitIndicator(response: UserProfileChangeNameFlow.OnWaitIndicator.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayWaitIndicator(viewModel: UserProfileChangeNameFlow.OnWaitIndicator.ViewModel(isShow: response.isShow))
        }
    }

    func presentAlert(response: UserProfileChangeNameFlow.AlertInfo.Response) {
        let title = getString(.error)
        let text = "response.error.localizedDescription" //todo: later
        let buttonTitle = getString(.closeAction)

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayAlert(viewModel: UserProfileChangeNameFlow.AlertInfo.ViewModel(
                title: title,
                text: text,
                buttonTitle: buttonTitle))
        }
    }

    func presentUpdate(response: UserProfileChangeNameFlow.Update.Response) {
        
        let grayViewBackColor = Theme.shared.isLight ? UIHelper.Color.grayAlpha06 : UIHelper.Color.blackAlpha06D

        let backColorOfChangeNameView = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.darkBackD

        let titleOfChangeNameView = NSAttributedString(
            string: getString(.changeUserNameTitle),
            attributes: Theme.shared.isLight ? UIHelper.Attributed.blackMiddleLRobotoSemibold20 : UIHelper.Attributed.whiteStrongRobotoSemibold20)

        let userNameSubtitle = NSAttributedString(
            string: getString(.userNameSubtitle),
            attributes: Theme.shared.isLight ? UIHelper.Attributed.grayLRobotoRegular14 : UIHelper.Attributed.grayRegularDRobotoRegular14)

        let userFullName = NSAttributedString(
            string: response.userFullName,
            attributes:Theme.shared.isLight ? UIHelper.Attributed.grayAlpha06RobotoRegular16 : UIHelper.Attributed.whiteStrongDRobotoRegular16)

        let senderTitleAtBorder = NSAttributedString(
            string: getString(.senderNameTitleAtBorded),
            attributes: Theme.shared.isLight ? UIHelper.Attributed.grayLRobotoRegular14 : UIHelper.Attributed.grayRegularDRobotoRegular14)

        let borderTitleBackColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.darkBackD

        let cancelTitle = NSAttributedString(string: getString(.сancelTitle),
                                             attributes: UIHelper.Attributed.redRobotoRegular14)
        let saveTitle = NSAttributedString(string: getString(.saveTitle),
                                             attributes: UIHelper.Attributed.blueRobotoRegular14)

        let borderColor = Theme.shared.isLight ? UIHelper.Color.grayLightL : UIHelper.Color.grayStrongD

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayUpdate(viewModel: UserProfileChangeNameFlow.Update.ViewModel(
                grayViewBackColor: grayViewBackColor,
                backColorOfChangeNameView: backColorOfChangeNameView,
                titleOfChangeNameView: titleOfChangeNameView,
                userNameSubtitle: userNameSubtitle,
                userFullName: userFullName,
                senderTitleAtBorder: senderTitleAtBorder,
                borderTitleBackColor: borderTitleBackColor,
                borderColor: borderColor,
                senderName: response.senderName, //по аналогии с полями кому/копия/тема сделал просто string
                cancelTitle: cancelTitle,
                saveTitle: saveTitle))
        }
    }
}


