//
//  EnterPasswordAfterQRPresenter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 09.04.2024.
//

import UIKit
import DifferenceKit

protocol EnterPasswordAfterQRPresentationLogic {
    func presentUpdate(response: EnterPasswordAfterQRFlow.Update.Response)
//    func presentWaitIndicator(response: EnterPasswordAfterQRFlow.OnWaitIndicator.Response)
//    func presentAlert(response: EnterPasswordAfterQRFlow.AlertInfo.Response)
    func presentRouteToEnterQRPassword(response: EnterPasswordAfterQRFlow.RoutePayload.Response)
    func presentChangeNextStepButtonState(response: EnterPasswordAfterQRFlow.ChangeButtonState.Response)
}


final class EnterPasswordAfterQRPresenter: EnterPasswordAfterQRPresentationLogic {

    enum Constants {
        static let isButtonActiveKey = "isActiveKey"
        static let isApplyButtonChangeStateNotificationName = Notification.Name("EnterPasswordAfterQRPresenterIsButtonChangeState")
    }

    // MARK: - Public properties

    weak var viewController: EnterPasswordAfterQRDisplayLogic?

    // MARK: - Public methods

    func presentRouteToEnterQRPassword(response: EnterPasswordAfterQRFlow.RoutePayload.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToEnterQRPassword(viewModel: EnterPasswordAfterQRFlow.RoutePayload.ViewModel())
        }
    }


    func presentUpdate(response: EnterPasswordAfterQRFlow.Update.Response) {

        let backColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD
        let title = NSMutableAttributedString(
            string: getString(.registrationTitle),
            attributes: Theme.shared.isLight ? UIHelper.Attributed.blackStrongLRobotoMedium18 : UIHelper.Attributed.whiteStrongRobotoMedium18)
        let separatorColor = Theme.shared.isLight ? UIHelper.Color.grayLightL : UIHelper.Color.grayStrongD

        var items: [AnyDifferentiable] = []
        items.append(makeTitleAndSubTitleVM())
        items.append(makePasswordVM())
        items.append(makeNextStepButtonVM(isActive: response.isNextStepButtonActive))

        
        let navBar = CustomNavBar(title: title,
                                  isLeftBarButtonEnable: true,
                                  isLeftBarButtonCustom: false,
                                  leftBarButtonCustom: nil,
                                  rightBarButtons: [])

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayUpdate(viewModel: EnterPasswordAfterQRFlow.Update.ViewModel(
                navBarBackground: backColor,
                backViewColor: backColor,
                navBar: navBar,
                separatorColor: separatorColor,
                items: items)
            )
        }
    }

    func presentChangeNextStepButtonState(response: EnterPasswordAfterQRFlow.ChangeButtonState.Response) {
        NotificationCenter.default.post(name: Constants.isApplyButtonChangeStateNotificationName,
                                        object: nil,
                                        userInfo: [Constants.isButtonActiveKey: response.isActive])
    }

//    func presentAlert(response: EnterPasswordAfterQRFlow.AlertInfo.Response) {
//        let title = getString(.errorOccurred)
//        let text = getString(.contactTechnicalSupport)
//        let buttonTitle = getString(.closeAction)
//
//        DispatchQueue.main.async { [weak self] in
//            self?.viewController?.displayAlert(viewModel: EnterPasswordAfterQRFlow.AlertInfo.ViewModel(title: title,
//                                                                                                           text: text,
//                                                                                                           buttonTitle: buttonTitle))
//        }
//    }
//
//    func presentWaitIndicator(response: EnterPasswordAfterQRFlow.OnWaitIndicator.Response) {
//        DispatchQueue.main.async { [weak self] in
//            self?.viewController?.displayWaitIndicator(viewModel: EnterPasswordAfterQRFlow.OnWaitIndicator.ViewModel(isShow: response.isShow))
//        }
//    }


    // MARK: - Private methods
    private func makeTitleAndSubTitleVM() -> AnyDifferentiable {
        let title = NSMutableAttributedString(
            string: getString(.enterPasswordTitle),
            attributes: Theme.shared.isLight ? UIHelper.Attributed.blackMiddleLRobotoRegular18 : UIHelper.Attributed.whiteStrongDRobotoRegular18)
        let subTitle = NSMutableAttributedString(
            string: getString(.enterPasswordSubTitle),
            attributes: Theme.shared.isLight ? UIHelper.Attributed.grayAlpha06RobotoRegular14 : UIHelper.Attributed.whiteDarkDRobotoRegular14)

        let titleAndSubTitleVM = TitleAndSubTitleCellViewModel(
            id: EnterPasswordAfterQRModel.MenuItems.title,
            title: title,
            subTitle: subTitle,
            insets: UIEdgeInsets(top: UIHelper.Margins.large24px,
                                 left: UIHelper.Margins.medium16px,
                                 bottom: UIHelper.Margins.medium12px,
                                 right: UIHelper.Margins.medium16px))
        return AnyDifferentiable(titleAndSubTitleVM)
    }

    private func makePasswordVM() -> AnyDifferentiable {

        let borderTitle = NSMutableAttributedString(
            string: getString(.enterPasswordRectangleTitle),
            attributes: Theme.shared.isLight ? UIHelper.Attributed.grayLRobotoRegular14 : UIHelper.Attributed.grayRegularDRobotoRegular14)

        let borderTitleBackColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD
        let borderColor = Theme.shared.isLight ? UIHelper.Color.grayLightL : UIHelper.Color.grayStrongD

        let passwordVM = TextCellWithTitleAtBorderViewModel(
            id: EnterPasswordAfterQRModel.MenuItems.passwordInput,
            type: .noLimits,
            borderTitle: borderTitle,
            borderColor: borderColor,
            borderTitleBackColor: borderTitleBackColor,
            isPasswordFieldActiveNeedsForConfirmPassword: true,
            insets: UIEdgeInsets(top: UIHelper.Margins.medium12px,
                                 left: UIHelper.Margins.medium16px,
                                 bottom: UIHelper.Margins.medium12px,
                                 right: UIHelper.Margins.medium16px))
        return AnyDifferentiable(passwordVM)
    }

    private func makeNextStepButtonVM(isActive: Bool) -> AnyDifferentiable {

        let applyButtonVM = NextStepButtonCellViewModel(
            id: EnterPasswordAfterQRModel.MenuItems.nextStep,
            activeTitle: NSAttributedString(
                string: getString(.enterPasswordNextStep),
                attributes: UIHelper.Attributed.whiteRobotoMedium14),
            nonActiveTitle: NSAttributedString(
                string: getString(.enterPasswordNextStep),
                attributes: Theme.shared.isLight ? UIHelper.Attributed.almostWhiteLRobotoMedium14 : UIHelper.Attributed.dustWhiteDRobotoMedium14),
            activeBackColor: UIHelper.Color.blue,
            nonActiveBackColor: Theme.shared.isLight ? UIHelper.Color.lightBlueL : UIHelper.Color.dustBlueD,
            insets: UIEdgeInsets(top: UIHelper.Margins.medium12px,
                                 left: UIHelper.Margins.medium16px,
                                 bottom: UIHelper.Margins.medium12px,
                                 right: UIHelper.Margins.medium16px),
            isActive: isActive,
            switchStateNotificationName: Constants.isApplyButtonChangeStateNotificationName,
            isActiveKey: Constants.isButtonActiveKey)
        return AnyDifferentiable(applyButtonVM)
    }
}
