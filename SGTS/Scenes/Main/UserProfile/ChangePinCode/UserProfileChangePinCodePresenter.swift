//
//  UserProfileChangePinCodePresenter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 28.06.2024.
//

import UIKit
import DifferenceKit

protocol UserProfileChangePinCodePresentationLogic {
    func presentUpdate(response: UserProfileChangePinCodeFlow.Update.Response)
    func presentWaitIndicator(response: UserProfileChangePinCodeFlow.OnWaitIndicator.Response)
    func presentAlert(response: UserProfileChangePinCodeFlow.AlertInfo.Response)
    func presentBiometrySwitchState(response: UserProfileChangePinCodeFlow.ChangeSwitchState.Response)
    func presentConfirmPasswordFieldState(response: UserProfileChangePinCodeFlow.ChangeConfirmPswrdState.Response)

    func presentRouteToSavePincode(response: UserProfileChangePinCodeFlow.RoutePayload.Response)
    func presentRouteBackToUserProfile(response: UserProfileChangePinCodeFlow.RoutePayload.Response)

    func presentFinishRegistrationButtonState(response: UserProfileChangePinCodeFlow.ChangeButtonState.Response)
}


final class UserProfileChangePinCodePresenter: UserProfileChangePinCodePresentationLogic {

    enum Constants {
        static let maxCharacters = 4
        static let isConfirmPasswordActiveKey = "isConfirmPasswordActiveKey"
        static let confirmPasswordFieldNotificationName = Notification.Name("UserProfileChangePinCodePresenterConfirmPasswordChangeState")

        static let isBioSwitchActiveKey = "isBioSwitchActiveKey"
        static let bioSwitchNotificationName = Notification.Name("UserProfileChangePinCodePresenterBioSwitchNotificationName")

        static let isButtonActiveKey = "isActiveKey"
        static let finishButtonNotificationName = Notification.Name("UserProfileChangePinCodePresenterIsButtonChangeState")
    }

    // MARK: - Public properties

    weak var viewController: UserProfileChangePinCodeDisplayLogic?

    // MARK: - Public methods

    func presentRouteToSavePincode(response: UserProfileChangePinCodeFlow.RoutePayload.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToSavePincode(viewModel: UserProfileChangePinCodeFlow.RoutePayload.ViewModel())
        }
    }

    func presentRouteBackToUserProfile(response: UserProfileChangePinCodeFlow.RoutePayload.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteBackToUserProfile(viewModel: UserProfileChangePinCodeFlow.RoutePayload.ViewModel())
        }
    }

    func presentConfirmPasswordFieldState(response: UserProfileChangePinCodeFlow.ChangeConfirmPswrdState.Response) {
            NotificationCenter.default.post(
                name: Constants.confirmPasswordFieldNotificationName,
                object: nil,
                userInfo: [Constants.isConfirmPasswordActiveKey: response.isActive])
    }

    func presentBiometrySwitchState(response: UserProfileChangePinCodeFlow.ChangeSwitchState.Response) {
            NotificationCenter.default.post(
                name: Constants.bioSwitchNotificationName,
                object: nil,
                userInfo: [Constants.isBioSwitchActiveKey: response.isActive])
    }

    func presentFinishRegistrationButtonState(response: UserProfileChangePinCodeFlow.ChangeButtonState.Response) {
        NotificationCenter.default.post(
            name: Constants.finishButtonNotificationName,
            object: nil,
            userInfo: [Constants.isButtonActiveKey: response.isActive])
    }

    func presentUpdate(response: UserProfileChangePinCodeFlow.Update.Response) {
        let backColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD
        let title = NSMutableAttributedString(
            string: getString(.registrationTitle),
            attributes: Theme.shared.isLight ? UIHelper.Attributed.blackStrongLRobotoMedium18 : UIHelper.Attributed.whiteStrongRobotoMedium18)
        let separatorColor = Theme.shared.isLight ? UIHelper.Color.grayLightL : UIHelper.Color.grayStrongD

        var items: [AnyDifferentiable] = []
        items.append(makePasswordVM(password: response.currentPassword, 
                                    placeholderText: getString(.userProfileEnterCurrentPinCode),
                                    type: .enterCurrentPinCode))

        items.append(makePasswordVM(password: response.newPassword,
                                    placeholderText: getString(.userProfileEnterNewPinCode),
                                    type: .enterNewPinCode))

        items.append(makeConfirmPasswordVM(password: response.newPassword, //то же ли должно быть свойство
                                           isActive: response.isConfirmPasswordActive))

        items.append(makeBiometrySwitchVM(isOn: response.isBiometrySwitchOn,
                                          isActive: response.isBiometrySwitchActive))

        items.append(makeFinishButtonVM(isActive: response.isFinishButtonActive,
                                        title: getString(.saveTitle),
                                        type: UserProfileChangePinCodeModel.MenuItems.saveButton))
        items.append(makeFinishButtonVM(isActive: true, //cancel always active
                                        title: getString(.сancelTitle),
                                        type: UserProfileChangePinCodeModel.MenuItems.cancelButton))


        let navBar = CustomNavBar(title: title,
                                  isLeftBarButtonEnable: true,
                                  isLeftBarButtonCustom: false,
                                  leftBarButtonCustom: nil,
                                  rightBarButtons: [])

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayUpdate(viewModel: UserProfileChangePinCodeFlow.Update.ViewModel(
                navBarBackground: backColor,
                backViewColor: backColor,
                navBar: navBar,
                separatorColor: separatorColor,
                items: items)
            )
        }
    }

    func presentAlert(response: UserProfileChangePinCodeFlow.AlertInfo.Response) {
        let title = getString(.error)
        let text =  response.error.localizedDescription
        let buttonTitle = getString(.closeAction)

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayAlert(
                viewModel: UserProfileChangePinCodeFlow.AlertInfo.ViewModel(title: title,
                                                                            text: text,
                                                                            buttonTitle: buttonTitle))
        }
    }

    func presentWaitIndicator(response: UserProfileChangePinCodeFlow.OnWaitIndicator.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayWaitIndicator(viewModel: UserProfileChangePinCodeFlow.OnWaitIndicator.ViewModel(isShow: response.isShow))
        }
    }


    // MARK: - Private methods

    private func makePasswordVM(password: String?, 
                                placeholderText: String,
                                type: UserProfileChangePinCodeModel.MenuItems) -> AnyDifferentiable {
        let placeholderText = NSAttributedString(
            string: placeholderText,
            attributes: Theme.shared.isLight ? UIHelper.Attributed.grayLRobotoRegular16 : UIHelper.Attributed.grayRegularDRobotoRegular16)

        let borderColor = Theme.shared.isLight ? UIHelper.Color.grayLightL : UIHelper.Color.grayStrongD

        let passwordVM = TextCellWithTitleAtBorderViewModel(
            id: type,
            type: .only4Digits,
            maxCharacters: Constants.maxCharacters,
            password: password,
            placeholder: placeholderText,
            borderTitle: nil,
            borderColor: borderColor,
            borderTitleBackColor: UIColor.clear,
            isPasswordFieldActiveNeedsForConfirmPassword: true,//set logic earlier - here shouldn't be raw value
            insets: UIEdgeInsets(top: UIHelper.Margins.medium12px,
                                 left: UIHelper.Margins.medium16px,
                                 bottom: UIHelper.Margins.medium12px,
                                 right: UIHelper.Margins.medium16px),
            keyboardType: .numberPad)
        return AnyDifferentiable(passwordVM)
    }

    private func makeConfirmPasswordVM(password: String?, isActive: Bool) -> AnyDifferentiable {
        let placeholderText = NSAttributedString(
            string: getString(.userProfileConfirmNewPinCode),
            attributes: Theme.shared.isLight ? UIHelper.Attributed.grayLRobotoRegular16 : UIHelper.Attributed.grayRegularDRobotoRegular16)

        let borderColor = Theme.shared.isLight ? UIHelper.Color.grayLightL : UIHelper.Color.grayStrongD

        let passwordVM = TextCellWithTitleAtBorderViewModel(
            id: UserProfileChangePinCodeModel.MenuItems.confirmNewPinCode,
            type: .only4Digits,
            maxCharacters: Constants.maxCharacters,
            password: password,
            placeholder: placeholderText,
            borderTitle: nil,
            borderColor: borderColor,
            borderTitleBackColor: UIColor.clear,
            isPasswordFieldActiveNeedsForConfirmPassword: true, //set logic earlier - here shouldn't be raw value
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


    private func makeFinishButtonVM(isActive: Bool, 
                                    title: String,
                                    type: UserProfileChangePinCodeModel.MenuItems) -> AnyDifferentiable {
        var activeTitleAttribute = [NSAttributedString.Key: Any]()
        var nonActiveTitleAttribute = [NSAttributedString.Key: Any]()
        var activeBackColor = UIColor()
        var nonActiveBackColor = UIColor()
        var borderColor = UIColor()

        switch type {
        case .saveButton:
            activeTitleAttribute = UIHelper.Attributed.whiteRobotoMedium14
            nonActiveTitleAttribute = Theme.shared.isLight ? UIHelper.Attributed.almostWhiteLRobotoMedium14 : UIHelper.Attributed.dustWhiteDRobotoMedium14
            activeBackColor = UIHelper.Color.blue
            nonActiveBackColor = Theme.shared.isLight ? UIHelper.Color.lightBlueL : UIHelper.Color.dustBlueD
            
        case .cancelButton:
            activeTitleAttribute = UIHelper.Attributed.blueRobotoMedium14
            nonActiveTitleAttribute = UIHelper.Attributed.blueRobotoMedium14
            activeBackColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD
            nonActiveBackColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD
            borderColor = UIHelper.Color.blue
        default:
            break
        }

        let finishButtonVM = NextStepButtonCellViewModel(
            id: type,
            activeTitle: NSAttributedString(
                string: title,
                attributes: activeTitleAttribute),
            nonActiveTitle: NSAttributedString(
                string: title,
                attributes: nonActiveTitleAttribute),
            activeBackColor: activeBackColor,
            nonActiveBackColor: nonActiveBackColor,
            insets: UIEdgeInsets(top: UIHelper.Margins.medium12px,
                                 left: UIHelper.Margins.medium16px,
                                 bottom: UIHelper.Margins.medium12px,
                                 right: UIHelper.Margins.medium16px),
            isActive: isActive,
            switchStateNotificationName: Constants.finishButtonNotificationName,
            isActiveKey: Constants.isButtonActiveKey,
            borderWidth: UIHelper.Margins.small1px,
            borderColor: borderColor)
        return AnyDifferentiable(finishButtonVM)
    }
}

