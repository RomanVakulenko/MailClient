//
//  SecretKeySelectorPresenter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 12.04.2024.
//

import UIKit
import DifferenceKit

protocol SecretKeySelectorPresentationLogic {
    func presentUpdate(response: SecretKeySelectorFlow.Update.Response)
    func presentWaitIndicator(response: SecretKeySelectorFlow.OnWaitIndicator.Response)
    func presentAlert(response: SecretKeySelectorFlow.AlertInfo.Response)
    func presentFileDialog(response: SecretKeySelectorFlow.OnBrowseButton.Response)
    func presentChangeNextStepButtonState(response: SecretKeySelectorFlow.ChangeButtonState.Response)
    func presentRouteToSetPincodeScreen(response: SecretKeySelectorFlow.RoutePayload.Response)
    func presentRouteToBrowserAuth(response: SecretKeySelectorFlow.RoutePayload.Response)
}


final class SecretKeySelectorPresenter: SecretKeySelectorPresentationLogic {

    enum Constants {
        static let isButtonActiveKey = "isActiveKey"
        static let isApplyButtonChangeStateNotificationName = Notification.Name("SecretKeySelectorPresenterIsButtonChangeState")
    }

    // MARK: - Public properties

    weak var viewController: SecretKeySelectorDisplayLogic?

    // MARK: - Public methods
    func presentRouteToBrowserAuth(response: SecretKeySelectorFlow.RoutePayload.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToBrowserAuth(
                viewModel: SecretKeySelectorFlow.RoutePayload.ViewModel())
        }
    }
    
    func presentRouteToSetPincodeScreen(response: SecretKeySelectorFlow.RoutePayload.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToSetPincodeScreen(
                viewModel: SecretKeySelectorFlow.RoutePayload.ViewModel())
        }
    }

    func presentFileDialog(response: SecretKeySelectorFlow.OnBrowseButton.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayFileDialog(
                viewModel: SecretKeySelectorFlow.OnBrowseButton.ViewModel())
        }
    }

    func presentUpdate(response: SecretKeySelectorFlow.Update.Response) {

        let backColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD
        let title = NSMutableAttributedString(
            string: getString(.registrationTitle),
            attributes: Theme.shared.isLight ? UIHelper.Attributed.blackStrongLRobotoMedium18 : UIHelper.Attributed.whiteStrongRobotoMedium18)
        let separatorColor = Theme.shared.isLight ? UIHelper.Color.grayLightL : UIHelper.Color.grayStrongD

        var items: [AnyDifferentiable] = []


        items.append(makeTitleAndSubTitleVM())
        if let fileName = response.nameOfChoosenFile,
           response.isFileChoosen {
            items.append(
                makeCloudCellVM(isFileChoosen: response.isFileChoosen, fileName: fileName)
            )
        }
        items.append(makeBrowseButtonVM())
        items.append(makePasswordVM(isPasswordFieldActive: response.isFileChoosen))
        items.append(makeNextStepButtonVM(isActive: response.isNextStepButtonActive))

        let rightBarButtonImage = NavBarButton(image: Theme.shared.isLight ? UIHelper.Image.secretKeySelectRightBarButtonQRL : UIHelper.Image.secretKeySelectRightBarButtonQRD)

        let navBar = CustomNavBar(title: title,
                            isLeftBarButtonEnable: true,
                            isLeftBarButtonCustom: false,
                            leftBarButtonCustom: nil,
                            rightBarButtons: [rightBarButtonImage])

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayUpdate(viewModel: SecretKeySelectorFlow.Update.ViewModel(
                navBarBackground: backColor,
                backViewColor: backColor,
                navBar: navBar,
                separatorColor: separatorColor,
                items: items)
            )
        }
    }

    func presentChangeNextStepButtonState(response: SecretKeySelectorFlow.ChangeButtonState.Response) {
        NotificationCenter.default.post(name: Constants.isApplyButtonChangeStateNotificationName,
                                        object: nil,
                                        userInfo: [Constants.isButtonActiveKey: response.isActive])
    }

    func presentAlert(response: SecretKeySelectorFlow.AlertInfo.Response) {
        let title = getString(.error)
        let text = "Server, key file of password error"
        let buttonTitle = getString(.closeAction)

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayAlert(
                viewModel: SecretKeySelectorFlow.AlertInfo.ViewModel(title: title,
                                                                     text: text,
                                                                     buttonTitle: buttonTitle))
        }
    }

    func presentWaitIndicator(response: SecretKeySelectorFlow.OnWaitIndicator.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayWaitIndicator(viewModel: SecretKeySelectorFlow.OnWaitIndicator.ViewModel(isShow: response.isShow))
        }
    }

    // MARK: - Private methods
    private func makeTitleAndSubTitleVM() -> AnyDifferentiable {
        let title = NSAttributedString(
            string: getString(.secretKeySelectorTitle),
            attributes: Theme.shared.isLight ? UIHelper.Attributed.blackMiddleLRobotoRegular18 : UIHelper.Attributed.whiteStrongDRobotoRegular18)
        let subTitle = NSAttributedString(
            string: getString(.secretKeySelectorSubTitle),
            attributes: Theme.shared.isLight ? UIHelper.Attributed.grayAlpha06RobotoRegular14 : UIHelper.Attributed.whiteDarkDRobotoRegular14)

        let titleAndSubTitleVM = TitleAndSubTitleCellViewModel(
            id: SecretKeySelectorModel.MenuItems.title,
            title: title,
            subTitle: subTitle,
            insets: UIEdgeInsets(top: UIHelper.Margins.large24px,
                                 left: UIHelper.Margins.medium16px,
                                 bottom: UIHelper.Margins.medium12px,
                                 right: UIHelper.Margins.medium16px))
        return AnyDifferentiable(titleAndSubTitleVM)
    }


    private func makeCloudCellVM(isFileChoosen: Bool, fileName: String) -> AnyDifferentiable {
        let backColor = Theme.shared.isLight ? UIHelper.Color.whiteStrong : UIHelper.Color.almostBlackD

        let title = NSAttributedString(
            string: fileName,
            attributes: Theme.shared.isLight ? UIHelper.Attributed.grayAlpha06RobotoMedium14 : UIHelper.Attributed.whiteDarkDRobotoMedium14)

        let xButton = Theme.shared.isLight ? UIHelper.Image.xButton14pxL : UIHelper.Image.xButton14pxD

        let borderColor = Theme.shared.isLight ? UIHelper.Color.grayLightL : UIHelper.Color.grayStrongD

        let cloudButtonVM = CloudKeyCellViewModel(
            id: SecretKeySelectorModel.MenuItems.cloud,
            backColor: backColor,
            borderColor: borderColor,
            title: title,
            xButton: xButton,
            insets: UIEdgeInsets(top: UIHelper.Margins.small4px,
                                 left: UIHelper.Margins.medium16px,
                                 bottom: UIHelper.Margins.medium8px,
                                 right: UIHelper.Margins.medium16px)
        )
        return AnyDifferentiable(cloudButtonVM)
    }

    private func makeBrowseButtonVM() -> AnyDifferentiable {
        let title = NSAttributedString(
            string: getString(.secretKeySelectorBrowseTitle),
            attributes: UIHelper.Attributed.blueRobotoMedium14)

        let borderColor = UIHelper.Color.blue

        let browseButtonVM = BrowseButtonCellViewModel(
            id: SecretKeySelectorModel.MenuItems.browse,
            title: title,
            borderColor: borderColor,
            insets: UIEdgeInsets(top: UIHelper.Margins.medium8px,
                                 left: UIHelper.Margins.medium16px,
                                 bottom: UIHelper.Margins.medium12px,
                                 right: UIHelper.Margins.medium16px)
        )
        return AnyDifferentiable(browseButtonVM)
    }

    private func makePasswordVM(isPasswordFieldActive: Bool) -> AnyDifferentiable {

        let borderTitle = NSAttributedString(
            string: getString(.secretKeySelectorPlaceholderOrBorderTitle),
            attributes: Theme.shared.isLight ? UIHelper.Attributed.grayLRobotoRegular14 : UIHelper.Attributed.grayRegularDRobotoRegular14)
        let borderTitleBackColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD
        
        let borderColor = Theme.shared.isLight ? UIHelper.Color.grayLightL : UIHelper.Color.grayStrongD



        let passwordVM = TextCellWithTitleAtBorderViewModel(
            id: SecretKeySelectorModel.MenuItems.passwordInput,
            type: .noLimits,
            borderTitle: borderTitle,
            borderColor: borderColor,
            borderTitleBackColor: borderTitleBackColor,
            isPasswordFieldActiveNeedsForConfirmPassword: isPasswordFieldActive,
            insets: UIEdgeInsets(top: UIHelper.Margins.medium12px,
                                 left: UIHelper.Margins.medium16px,
                                 bottom: UIHelper.Margins.medium12px,
                                 right: UIHelper.Margins.medium16px),
            isOnlyDigits: false)
        return AnyDifferentiable(passwordVM)
    }

    private func makeNextStepButtonVM(isActive: Bool) -> AnyDifferentiable {
        let applyButtonVM = NextStepButtonCellViewModel(
            id: SecretKeySelectorModel.MenuItems.nextStep,
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
