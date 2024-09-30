//
//  AboutAppScreenPresenter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 24.06.2024.
//

import UIKit
import DifferenceKit
import SnapKit

protocol AboutAppScreenPresentationLogic {
    func presentUpdate(response: AboutAppScreenFlow.Update.Response)
    //    func presentAlert(response: AboutAppScreenFlow.AlertInfo.Response)
    func presentRouteBack(response: AboutAppScreenFlow.RoutePayload.Response)
    func presentRouteSendLogs(response: AboutAppScreenFlow.RoutePayload.Response)
}


final class AboutAppScreenPresenter: AboutAppScreenPresentationLogic {

    // MARK: - Public properties
    
    weak var viewController: AboutAppScreenDisplayLogic?
    
    // MARK: - Public methods
    
    func presentRouteBack(response: AboutAppScreenFlow.RoutePayload.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteBack(viewModel: AboutAppScreenFlow.RoutePayload.ViewModel())
        }
    }
    
    func presentRouteSendLogs(response: AboutAppScreenFlow.RoutePayload.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToSendLog(viewModel: AboutAppScreenFlow.RoutePayload.ViewModel())
        }
    }
    
    func presentUpdate(response: AboutAppScreenFlow.Update.Response) {
        let grayViewBackColor = Theme.shared.isLight ? UIHelper.Color.grayAlpha06 : UIHelper.Color.blackAlpha06D
        let backColorOfWhiteView = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.darkBackD

        let titleOfWhiteView = NSAttributedString(
            string: getString(.aboutAppTitle),
            attributes: Theme.shared.isLight ? UIHelper.Attributed.blackMiddleLRobotoSemibold20 : UIHelper.Attributed.whiteStrongRobotoSemibold20)

        let firstLogo = UIHelper.Image.initialLogoBlue

        let branNameAndAppVersion = NSAttributedString(
            string: getString(.aboutAppCERTEX) + GlobalConstants.appVersion,
            attributes: Theme.shared.isLight ? UIHelper.Attributed.grayAlpha06RobotoRegular14 : UIHelper.Attributed.whiteStrongRobotoRegular14)

        let separatorColor = Theme.shared.isLight ? UIHelper.Color.grayLightL : UIHelper.Color.grayStrongD
        let separatorBorderWidth = UIHelper.Margins.small1px

        let secondLogo = UIHelper.Image.secondLogo85x56

        let copyRightsText = NSAttributedString(
            string: getString(.aboutAppCopyRights),
            attributes: Theme.shared.isLight ? UIHelper.Attributed.grayAlpha06RobotoRegular14WithparagraphStyle : UIHelper.Attributed.whiteStrongRobotoRegular14WithparagraphStyle)

        let cancelTitle = NSAttributedString(string: getString(.closeTitle),
                                             attributes: UIHelper.Attributed.blueRobotoRegular14)

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayUpdate(viewModel: AboutAppScreenFlow.Update.ViewModel(
                grayViewBackColor: grayViewBackColor,
                backColorOfWhiteView: backColorOfWhiteView,
                titleOfWhiteView: titleOfWhiteView,
                firstLogo: firstLogo,
                branNameAndAppVersion: branNameAndAppVersion,
                separatorColor: separatorColor,
                separatorBorderWidth: separatorBorderWidth,
                secondLogo: secondLogo,
                copyRightsText: copyRightsText,
                cancelTitle: cancelTitle))
        }
    }
}


