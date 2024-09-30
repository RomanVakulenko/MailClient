//
//  UserProfileSetSignaturePresenter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 28.06.2024.
//

import UIKit
import DifferenceKit

protocol UserProfileSetSignaturePresentationLogic {
    func presentUpdate(response: UserProfileSetSignatureFlow.Update.Response)
    func presentWaitIndicator(response: UserProfileSetSignatureFlow.OnWaitIndicator.Response)
    func presentAlert(response: UserProfileSetSignatureFlow.AlertInfo.Response)
    func presentRouteToSavePincode(response: UserProfileSetSignatureFlow.RoutePayload.Response)
    func presentRouteBackToUserProfile(response: UserProfileSetSignatureFlow.RoutePayload.Response)

    func presentFinishRegistrationButtonState(response: UserProfileSetSignatureFlow.ChangeButtonState.Response)
}


final class UserProfileSetSignaturePresenter: UserProfileSetSignaturePresentationLogic {

    enum Constants {
        static let maxCharacters = 4
        static let isConfirmPasswordActiveKey = "isConfirmPasswordActiveKey"
        static let confirmPasswordFieldNotificationName = Notification.Name("UserProfileSetSignaturePresenterConfirmPasswordChangeState")

        static let isBioSwitchActiveKey = "isBioSwitchActiveKey"
        static let bioSwitchNotificationName = Notification.Name("UserProfileSetSignaturePresenterBioSwitchNotificationName")

        static let isButtonActiveKey = "isActiveKey"
        static let finishButtonNotificationName = Notification.Name("UserProfileSetSignaturePresenterIsButtonChangeState")
    }

    // MARK: - Public properties

    weak var viewController: UserProfileSetSignatureDisplayLogic?

    // MARK: - Public methods

    func presentRouteToSavePincode(response: UserProfileSetSignatureFlow.RoutePayload.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToSavePincode(viewModel: UserProfileSetSignatureFlow.RoutePayload.ViewModel())
        }
    }

    func presentRouteBackToUserProfile(response: UserProfileSetSignatureFlow.RoutePayload.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteBackToUserProfile(viewModel: UserProfileSetSignatureFlow.RoutePayload.ViewModel())
        }
    }

    func presentFinishRegistrationButtonState(response: UserProfileSetSignatureFlow.ChangeButtonState.Response) {
        NotificationCenter.default.post(
            name: Constants.finishButtonNotificationName,
            object: nil,
            userInfo: [Constants.isButtonActiveKey: response.isActive])
    }

    func presentUpdate(response: UserProfileSetSignatureFlow.Update.Response) {
        let backColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD
        let title = NSMutableAttributedString(
            string: getString(.userProfileSignature),
            attributes: Theme.shared.isLight ? UIHelper.Attributed.blackStrongLRobotoMedium18 : UIHelper.Attributed.whiteStrongRobotoMedium18)
        let separatorColor = Theme.shared.isLight ? UIHelper.Color.grayLightL : UIHelper.Color.grayStrongD

        var items: [AnyDifferentiable] = []
        items.append(makeSignatureVM(backColor: backColor,
                                     signature: response.signature,
                                     placeholderText: getString(.userProfileSetSingnaturePlaceholder),
                                     type: .signField))


        items.append(makeFinishButtonVM(isActive: response.isFinishButtonActive,
                                        title: getString(.saveTitle),
                                        type: UserProfileSetSignatureModel.MenuItems.saveButton))
        items.append(makeFinishButtonVM(isActive: true, //cancel always active
                                        title: getString(.сancelTitle),
                                        type: UserProfileSetSignatureModel.MenuItems.cancelButton))


        let navBar = CustomNavBar(title: title,
                                  isLeftBarButtonEnable: true,
                                  isLeftBarButtonCustom: false,
                                  leftBarButtonCustom: nil,
                                  rightBarButtons: [])

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayUpdate(viewModel: UserProfileSetSignatureFlow.Update.ViewModel(
                navBarBackground: backColor,
                backViewColor: backColor,
                navBar: navBar,
                separatorColor: separatorColor,
                items: items)
            )
        }
    }

    func presentWaitIndicator(response: UserProfileSetSignatureFlow.OnWaitIndicator.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayWaitIndicator(viewModel: UserProfileSetSignatureFlow.OnWaitIndicator.ViewModel(isShow: response.isShow))
        }
    }

    func presentAlert(response: UserProfileSetSignatureFlow.AlertInfo.Response) {
        let title = getString(.error)
        let text = response.error.localizedDescription
        let buttonTitle = getString(.closeAction)

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayAlert(
                viewModel: UserProfileSetSignatureFlow.AlertInfo.ViewModel(title: title,
                                                                           text: text,
                                                                           buttonTitle: buttonTitle))
        }
    }


    // MARK: - Private methods


    private func makeSignatureVM(backColor: UIColor,
                                 signature: String?,
                                 placeholderText: String,
                                 type: UserProfileSetSignatureModel.MenuItems) -> AnyDifferentiable {
        let placeholderText = NSAttributedString(
            string: placeholderText,
            attributes: Theme.shared.isLight ? UIHelper.Attributed.grayLRobotoRegular16 : UIHelper.Attributed.grayRegularDRobotoRegular16)

        let attributedSignature = NSAttributedString(
            string: signature ?? "",
            attributes: Theme.shared.isLight ? UIHelper.Attributed.grayLRobotoRegular16 : UIHelper.Attributed.grayRegularDRobotoRegular16)

        let borderColor = Theme.shared.isLight ? UIHelper.Color.grayLightL : UIHelper.Color.grayStrongD

        let signatureVM = TextViewCellViewModel(
            id: type,
            placeholder: placeholderText,
            isCreatingNewEmail: false,
            isMakingSignature: true,
            attributedText: attributedSignature,
            backColor: backColor,
            borderWidth: UIHelper.Margins.small1px,
            borderColor: borderColor,
            insets: UIEdgeInsets(top: UIHelper.Margins.medium12px,
                                 left: UIHelper.Margins.medium16px,
                                 bottom: UIHelper.Margins.medium12px,
                                 right: UIHelper.Margins.medium16px))
        return AnyDifferentiable(signatureVM)
    }

    private func makeFinishButtonVM(isActive: Bool, 
                                    title: String,
                                    type: UserProfileSetSignatureModel.MenuItems) -> AnyDifferentiable {
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

