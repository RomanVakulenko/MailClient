//
//  LogInRegistrPresenter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 03.04.2024.
//

import UIKit
import DifferenceKit

protocol LogInRegistrPresentationLogic {
    func presentUpdate(response: LogInRegistrFlow.Update.Response)
//    func presentWaitIndicator(response: LogInRegistrFlow.OnWaitIndicator.Response)
//    func presentAlert(response: LogInRegistrFlow.AlertInfo.Response)
    func presentRouteToSecretKeySelectorScreen(response: LogInRegistrFlow.RoutePayload.Response)
    func presentRouteToQRScanScreen(response: LogInRegistrFlow.RoutePayload.Response)
}

final class LogInRegistrPresenter: LogInRegistrPresentationLogic {

    enum Constants {}

    // MARK: - Public properties
    weak var viewController: LogInRegistrDisplayLogic?

    // MARK: - Public methods
    func presentUpdate(response: LogInRegistrFlow.Update.Response) {
        let title = NSAttributedString(
            string: getString(.registrationTitle),
            attributes: Theme.shared.isLight ? UIHelper.Attributed.blackStrongLRobotoMedium18 : UIHelper.Attributed.whiteStrongRobotoMedium18)

        let backColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD
        let separatorColor = Theme.shared.isLight ? UIHelper.Color.grayLightL : UIHelper.Color.grayStrongD

        let imgLogo = UIHelper.Image.initialLogoBlue
        let companyNameLabel = NSMutableAttributedString(
            string: getString(.initialTitle),
            attributes: Theme.shared.isLight ? UIHelper.Attributed.blackMiddleRobotoBold18 : UIHelper.Attributed.whiteRobotoBold18)
        let version = NSMutableAttributedString(
            string: "v \(response.version)",
            attributes: Theme.shared.isLight ? UIHelper.Attributed.blackMiddleRobotoBold18 : UIHelper.Attributed.whiteRobotoBold18)

        let scanQRTitleButton = makeScanQRTitle()
        let loadKeysButton = NSAttributedString(
            string: getString(.logInRegistrLoadKeysFromPhone),
            attributes: UIHelper.Attributed.whiteRobotoMedium14)


        let navBar = CustomNavBar(title: title,
                                  isLeftBarButtonEnable: false,
                                  isLeftBarButtonCustom: false,
                                  leftBarButtonCustom: nil,
                                  rightBarButtons: [])

        let viewModel = LogInRegistrFlow.Update.ViewModel(
            navBarBackground: backColor,
            navBar: navBar,
            backColor: backColor,
            separatorColor: separatorColor,
            imgLogo: imgLogo,
            companyName: companyNameLabel,
            version: version,
            scanQRTitleButton: scanQRTitleButton,
            loadKeysButton: loadKeysButton
        )

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayUpdate(viewModel: viewModel)
        }
    }

    //    func presentAlert(response: LogInRegistrFlow.AlertInfo.Response) {
    //        let title = getString(.errorOccurred)
    //        let text = getString(.contactTechnicalSupport)
    //        let buttonTitle = getString(.closeAction)
    //
    //        DispatchQueue.main.async { [weak self] in
    //            self?.viewController?.displayAlert(viewModel: LogInRegistrFlow.AlertInfo.ViewModel(title: title,
    //                                                                                                           text: text,
    //                                                                                                           buttonTitle: buttonTitle))
    //        }
    //    }

    //    func presentWaitIndicator(response: LogInRegistrFlow.OnWaitIndicator.Response) {
    //        DispatchQueue.main.async { [weak self] in
    //            self?.viewController?.displayWaitIndicator(viewModel: LogInRegistrFlow.OnWaitIndicator.ViewModel(isShow: response.isShow))
    //        }
    //    }

    func presentRouteToSecretKeySelectorScreen(response: LogInRegistrFlow.RoutePayload.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToSecretKeySelectorScreen(
                viewModel: LogInRegistrFlow.RoutePayload.ViewModel())
        }
    }

    func presentRouteToQRScanScreen(response: LogInRegistrFlow.RoutePayload.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToQRScanScreen(
                viewModel: LogInRegistrFlow.RoutePayload.ViewModel())
        }
    }
    // MARK: - Private methods
    private func makeScanQRTitle() -> NSAttributedString {
        let attachment = NSTextAttachment()
        attachment.image = UIHelper.Image.logInRegistrQRSmall
        attachment.bounds = CGRect(x: 0,
                                   y: -UIHelper.Margins.small2px,
                                   width: UIHelper.Margins.medium16px,
                                   height: UIHelper.Margins.medium16px)

        let attachmentString = NSAttributedString(attachment: attachment)
        let mutableAttributedString = NSMutableAttributedString(
            string: getString(.logInRegistrScanQRKode),
            attributes: UIHelper.Attributed.blueRobotoMedium14)

        mutableAttributedString.append(attachmentString)
        return mutableAttributedString
    }
}
