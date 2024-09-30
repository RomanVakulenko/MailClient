//
//  SetPinCodePresenter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 16.04.2024.
//

import UIKit
import DifferenceKit

protocol SetPinCodePresentationLogic {
    func presentUpdate(response: SetPinCodeFlow.Update.Response)
//    func presentWaitIndicator(response: SetPinCodeFlow.OnWaitIndicator.Response)
//    func presentAlert(response: SetPinCodeFlow.AlertInfo.Response)
    func presentBiometrySwitchState(response: SetPinCodeFlow.ChangeSwitchState.Response)
    func presentRouteToTabBarScreen(response: SetPinCodeFlow.RoutePayload.Response)
    func presentConfirmPasswordFieldState(response: SetPinCodeFlow.ChangeConfirmPswrdState.Response)
    func presentFinishRegistrationButtonState(response: SetPinCodeFlow.ChangeButtonState.Response)
}


final class SetPinCodePresenter: SetPinCodePresentationLogic {

    enum Constants {
        static let maxCharacters = 4
        static let isConfirmPasswordActiveKey = "isConfirmPasswordActiveKey"
        static let confirmPasswordFieldNotificationName = Notification.Name("SetPinCodePresenterConfirmPasswordChangeState")

        static let isBioSwitchActiveKey = "isBioSwitchActiveKey"
        static let bioSwitchNotificationName = Notification.Name("SetPinCodePresenterBioSwitchNotificationName")

        static let isButtonActiveKey = "isActiveKey"
        static let finishButtonNotificationName = Notification.Name("SetPinCodePresenterIsButtonChangeState")
    }

    // MARK: - Public properties

    weak var viewController: SetPinCodeDisplayLogic?

    // MARK: - Public methods

    func presentRouteToTabBarScreen(response: SetPinCodeFlow.RoutePayload.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToTabBarScreen(viewModel: SetPinCodeFlow.RoutePayload.ViewModel())
        }
    }

    func presentConfirmPasswordFieldState(response: SetPinCodeFlow.ChangeConfirmPswrdState.Response) {
            NotificationCenter.default.post(
                name: Constants.confirmPasswordFieldNotificationName,
                object: nil,
                userInfo: [Constants.isConfirmPasswordActiveKey: response.isActive])
    }

    func presentBiometrySwitchState(response: SetPinCodeFlow.ChangeSwitchState.Response) {
            NotificationCenter.default.post(
                name: Constants.bioSwitchNotificationName,
                object: nil,
                userInfo: [Constants.isBioSwitchActiveKey: response.isActive])
    }

    func presentFinishRegistrationButtonState(response: SetPinCodeFlow.ChangeButtonState.Response) {
        NotificationCenter.default.post(
            name: Constants.finishButtonNotificationName,
            object: nil,
            userInfo: [Constants.isButtonActiveKey: response.isActive])
    }

//    func presentAlert(response: SetPinCodeFlow.AlertInfo.Response) {
//        let title = getString(.errorOccurred)
//        let text = getString(.contactTechnicalSupport)
//        let buttonTitle = getString(.closeAction)
//
//        DispatchQueue.main.async { [weak self] in
//            self?.viewController?.displayAlert(
//                viewModel: SetPinCodeFlow.AlertInfo.ViewModel(title: title,
//                                                              text: text,
//                                                              buttonTitle: buttonTitle))
//        }
//    }

    func presentUpdate(response: SetPinCodeFlow.Update.Response) {
        let backColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD
        let title = NSMutableAttributedString(
            string: getString(.registrationTitle),
            attributes: Theme.shared.isLight ? UIHelper.Attributed.blackStrongLRobotoMedium18 : UIHelper.Attributed.whiteStrongRobotoMedium18)
        let separatorColor = Theme.shared.isLight ? UIHelper.Color.grayLightL : UIHelper.Color.grayStrongD

        var items: [AnyDifferentiable] = []
        items.append(makeTitleAndSubTitleVM())
        items.append(makePasswordVM(password: response.passwordText))
        items.append(makeConfirmPasswordVM(password: response.passwordText,
                                           isActive: response.isConfirmPasswordActive))

        items.append(makeBiometrySwitchVM(isOn: response.isBiometrySwitchOn,
                                          isActive: response.isBiometrySwitchActive))
        items.append(makeFinishButtonVM(isActive: response.isFinishButtonActive))

        let navBar = CustomNavBar(title: title,
                                  isLeftBarButtonEnable: true,
                                  isLeftBarButtonCustom: false,
                                  leftBarButtonCustom: nil,
                                  rightBarButtons: [])

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayUpdate(viewModel: SetPinCodeFlow.Update.ViewModel(
                navBarBackground: backColor,
                backViewColor: backColor,
                navBar: navBar,
                separatorColor: separatorColor,
                items: items)
            )
        }
    }

//
//    func presentWaitIndicator(response: SetPinCodeFlow.OnWaitIndicator.Response) {
//        DispatchQueue.main.async { [weak self] in
//            self?.viewController?.displayWaitIndicator(viewModel: SetPinCodeFlow.OnWaitIndicator.ViewModel(isShow: response.isShow))
//        }
//    }


    // MARK: - Private methods
    private func makeTitleAndSubTitleVM() -> AnyDifferentiable {
        let title = NSMutableAttributedString(
            string: getString(.setPinCodeTitle),
            attributes: Theme.shared.isLight ? UIHelper.Attributed.blackMiddleLRobotoRegular18 : UIHelper.Attributed.whiteStrongDRobotoRegular18)
        let subTitle = NSMutableAttributedString(
            string: getString(.setPinCodeSubTitle),
            attributes: Theme.shared.isLight ? UIHelper.Attributed.grayAlpha06RobotoRegular14 : UIHelper.Attributed.whiteDarkDRobotoRegular14)

        let titleAndSubTitleVM = TitleAndSubTitleCellViewModel(
            id: SetPinCodeModel.MenuItems.title,
            title: title,
            subTitle: subTitle,
            insets: UIEdgeInsets(top: UIHelper.Margins.large24px,
                                 left: UIHelper.Margins.medium16px,
                                 bottom: UIHelper.Margins.medium12px,
                                 right: UIHelper.Margins.medium16px))
        return AnyDifferentiable(titleAndSubTitleVM)
    }


    private func makePasswordVM(password: String?) -> AnyDifferentiable {
        let placeholderText = NSAttributedString(
            string: getString(.enterPin),
            attributes: Theme.shared.isLight ? UIHelper.Attributed.grayLRobotoRegular16 : UIHelper.Attributed.grayRegularDRobotoRegular16)

        let borderColor = Theme.shared.isLight ? UIHelper.Color.grayLightL : UIHelper.Color.grayStrongD

        let passwordVM = TextCellWithTitleAtBorderViewModel(
            id: SetPinCodeModel.MenuItems.passwordInput,
            type: .only4Digits,
            maxCharacters: Constants.maxCharacters,
            password: password,
            placeholder: placeholderText,
            borderTitle: nil,
            borderColor: borderColor,
            borderTitleBackColor: UIColor.clear,
            isPasswordFieldActiveNeedsForConfirmPassword: true,
            insets: UIEdgeInsets(top: UIHelper.Margins.medium12px,
                                 left: UIHelper.Margins.medium16px,
                                 bottom: UIHelper.Margins.medium12px,
                                 right: UIHelper.Margins.medium16px),
            keyboardType: .numberPad)
        return AnyDifferentiable(passwordVM)
    }


    private func makeConfirmPasswordVM(password: String?, isActive: Bool) -> AnyDifferentiable {
        let placeholderText = NSAttributedString(
            string: getString(.confirmEnterPin),
            attributes: Theme.shared.isLight ? UIHelper.Attributed.grayLRobotoRegular16 : UIHelper.Attributed.grayRegularDRobotoRegular16)

        let borderColor = Theme.shared.isLight ? UIHelper.Color.grayLightL : UIHelper.Color.grayStrongD

        let passwordVM = TextCellWithTitleAtBorderViewModel(
            id: SetPinCodeModel.MenuItems.confirmPasswordInput,
            type: .only4Digits,
            maxCharacters: Constants.maxCharacters,
            password: password,
            placeholder: placeholderText,
            borderTitle: nil,
            borderColor: borderColor,
            borderTitleBackColor: UIColor.clear,
            isPasswordFieldActiveNeedsForConfirmPassword: isActive,
            switchStateNotificationName: Constants.confirmPasswordFieldNotificationName,
            isActiveKey: Constants.isConfirmPasswordActiveKey,
            insets: UIEdgeInsets(top: UIHelper.Margins.medium12px,
                                 left: UIHelper.Margins.medium16px,
                                 bottom: UIHelper.Margins.medium12px,
                                 right: UIHelper.Margins.medium16px),
            keyboardType: .numberPad)
        return AnyDifferentiable(passwordVM)
    }


    private func makeBiometrySwitchVM(isOn: Bool, isActive: Bool) -> AnyDifferentiable {
        let thumbColorOff = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.grayRegularD //circleOFF
        let tintColorBackOff = Theme.shared.isLight ? UIHelper.Color.grayL : UIHelper.Color.grayStrongD //backOFF
        
        let thumbColorOn = UIHelper.Color.blue //circleON_both
        let onTintColorBackOn = UIHelper.Color.darkBlue //backON

        let title = NSMutableAttributedString(
            string: getString(.setPinCodeToggleTitle),
            attributes: Theme.shared.isLight ? UIHelper.Attributed.grayLRobotoRegular16 : UIHelper.Attributed.grayRegularDRobotoRegular16)

        let switchAndTitleVM = SwitchBiometryCellViewModel(
            id: 0,
            title: title,
            isOn: isOn,
            isActive: isActive,
            switchStateNotificationName: Constants.bioSwitchNotificationName,
            isActiveKey: Constants.isBioSwitchActiveKey,
            thumbColorOff: thumbColorOff,
            thumbColorOn: thumbColorOn,
            tintColorBackOff: tintColorBackOff,
            onTintColorBackOn: onTintColorBackOn,
            insets: UIEdgeInsets(top: UIHelper.Margins.medium12px,
                                 left: UIHelper.Margins.medium16px,
                                 bottom: UIHelper.Margins.medium12px,
                                 right: UIHelper.Margins.medium16px))
        return AnyDifferentiable(switchAndTitleVM)
    }


    private func makeFinishButtonVM(isActive: Bool) -> AnyDifferentiable {
        let applyButtonVM = NextStepButtonCellViewModel(
            id: SetPinCodeModel.MenuItems.finishButton,
            activeTitle: NSAttributedString(
                string: getString(.setPinCodeFinishRegistration),
                attributes: UIHelper.Attributed.whiteRobotoMedium14),
            nonActiveTitle: NSAttributedString(
                string: getString(.setPinCodeFinishRegistration),
                attributes: Theme.shared.isLight ? UIHelper.Attributed.almostWhiteLRobotoMedium14 : UIHelper.Attributed.dustWhiteDRobotoMedium14),
            activeBackColor: UIHelper.Color.blue,
            nonActiveBackColor: Theme.shared.isLight ? UIHelper.Color.lightBlueL : UIHelper.Color.dustBlueD,
            insets: UIEdgeInsets(top: UIHelper.Margins.medium12px,
                                 left: UIHelper.Margins.medium16px,
                                 bottom: UIHelper.Margins.medium12px,
                                 right: UIHelper.Margins.medium16px),
            isActive: isActive,
            switchStateNotificationName: Constants.finishButtonNotificationName,
            isActiveKey: Constants.isButtonActiveKey)
        return AnyDifferentiable(applyButtonVM)
    }
}

