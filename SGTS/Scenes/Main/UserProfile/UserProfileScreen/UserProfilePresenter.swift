//
//  UserProfilePresenter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 16.06.2024.
//

import UIKit
import DifferenceKit

protocol UserProfilePresentationLogic {
    func presentUpdate(response: UserProfileFlow.Update.Response)
    func presentWaitIndicator(response: UserProfileFlow.OnWaitIndicator.Response)
    func presentAlert(response: UserProfileFlow.AlertInfo.Response)

    func presentRouteToNameEditingScreen(response: UserProfileFlow.OnSelectItem.Response)
    func presentRouteToPinCodeEditingScreen(response: UserProfileFlow.OnSelectItem.Response)
    func presentRouteToSignatureScreen(response: UserProfileFlow.OnSelectItem.Response)
    func presentRouteToReportScreen(response: UserProfileFlow.OnSelectItem.Response)
    func presentRouteToInfoScreen(response: UserProfileFlow.OnSelectItem.Response)
    func presentRouteToSideMenu(response: UserProfileFlow.RoutePayload.Response)
}


final class UserProfilePresenter: UserProfilePresentationLogic {

    enum Constants {
        static let mainImageWidthHeight: CGFloat = 45
        static let cellHeight: CGFloat = 16 + 45 + 16
    }

    // MARK: - Public properties

    weak var viewController: UserProfileDisplayLogic?

    // MARK: - Public methods
    func presentRouteToSideMenu(response: UserProfileFlow.RoutePayload.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToSideMenu(viewModel: UserProfileFlow.RoutePayload.ViewModel())
        }
    }

    func presentRouteToNameEditingScreen(response: UserProfileFlow.OnSelectItem.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToNameEditingScreen(viewModel: UserProfileFlow.RoutePayload.ViewModel())
        }
    }

    func presentRouteToPinCodeEditingScreen(response: UserProfileFlow.OnSelectItem.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToPinCodeEditingScreen(viewModel: UserProfileFlow.RoutePayload.ViewModel())
        }
    }

    func presentRouteToSignatureScreen(response: UserProfileFlow.OnSelectItem.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToSignatureScreen(viewModel: UserProfileFlow.RoutePayload.ViewModel())
        }
    }

    func presentRouteToReportScreen(response: UserProfileFlow.OnSelectItem.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToReportScreen(viewModel: UserProfileFlow.RoutePayload.ViewModel())
        }
    }

    func presentRouteToInfoScreen(response: UserProfileFlow.OnSelectItem.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToInfoScreen(viewModel: UserProfileFlow.RoutePayload.ViewModel())
        }
    }

    func presentUpdate(response: UserProfileFlow.Update.Response) {
        let concurrentQueue = DispatchQueue(label: "kz.mailDetails.fileQueue",
                                            attributes: .concurrent)
        concurrentQueue.async { [weak self] in
            guard let self = self else { return }

            let backColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD
            let separatorColor = Theme.shared.isLight ? UIHelper.Color.grayLightL : UIHelper.Color.grayStrongD

            var items: [AnyDifferentiable] = []

            let changePinCodeIcon = Theme.shared.isLight ? UIHelper.Image.changePinCodeUserProfile24L : UIHelper.Image.changePinCodeUserProfile24D
            let signatureIcon = Theme.shared.isLight ? UIHelper.Image.signatureUserProfile24L : UIHelper.Image.signatureUserProfile24D
            let reportIcon = Theme.shared.isLight ? UIHelper.Image.reportOrDraftIcon24L : UIHelper.Image.reportOrDraftIcon24D
            let trashIcon = Theme.shared.isLight ? UIHelper.Image.trashIcon24x24L : UIHelper.Image.trashIcon24x24D
            let unsafeOutputAlertIcon = Theme.shared.isLight ? UIHelper.Image.unsafeOutputAlertUserProfile24L : UIHelper.Image.unsafeOutputAlertUserProfile24D
            let themeIcon = Theme.shared.isLight ? UIHelper.Image.darkThemeUserProfile24L : UIHelper.Image.darkThemeUserProfile24D
            let infoIcon = Theme.shared.isLight ? UIHelper.Image.infoUserProfile24L : UIHelper.Image.infoUserProfile24D

            var attributesForText = Theme.shared.isLight ? UIHelper.Attributed.blackMiddleLRobotoRegular16 : UIHelper.Attributed.whiteDarkDRobotoRegular16
            let chevronImage = Theme.shared.isLight ? UIHelper.Image.chevronRightL : UIHelper.Image.chevronRightD


            concurrentQueue.sync {
                items.append(self.makeUserNameAndEmailVM(id: UserProfileModel.MenuItems.userNameAndEmail,
                                                              backColor: backColor,
                                                              fullName: response.userFullName,
                                                              email: response.userEmail,
                                                              chevronImage: chevronImage))
            }

            items.append(makeSeparatorVMWith(id: 0,
                                             backColor: backColor,
                                             borderWidth: UIHelper.Margins.medium8px,
                                             separatorColor: separatorColor))

            items.append(makeIconTextAndChevronVM(id: UserProfileModel.MenuItems.changePinCode,
                                                  backColor: backColor,
                                                  icon: changePinCodeIcon,
                                                  text: getString(.userProfileChangePinCode),
                                                  attributesForText: attributesForText,
                                                  chevronImage: chevronImage))

            items.append(makeSeparatorVMWith(id: 1,
                                             backColor: backColor,
                                             borderWidth: UIHelper.Margins.small1px,
                                             separatorColor: separatorColor))

            items.append(makeIconTextAndChevronVM(id: UserProfileModel.MenuItems.signature,
                                                  backColor: backColor,
                                                  icon: signatureIcon,
                                                  text: getString(.userProfileSignature),
                                                  attributesForText: attributesForText,
                                                  chevronImage: chevronImage))

            items.append(makeSeparatorVMWith(id: 2,
                                             backColor: backColor,
                                             borderWidth: UIHelper.Margins.small1px,
                                             separatorColor: separatorColor))

            items.append(makeIconTextAndChevronVM(id: UserProfileModel.MenuItems.report,
                                                  backColor: backColor,
                                                  icon: reportIcon,
                                                  text: getString(.userProfileReport),
                                                  attributesForText: attributesForText,
                                                  chevronImage: chevronImage))

            items.append(makeSeparatorVMWith(id: 3,
                                             backColor: backColor,
                                             borderWidth: UIHelper.Margins.medium8px,
                                             separatorColor: separatorColor))

            items.append(makeIconTextAndSwitchVM(id: UserProfileModel.MenuItems.deleteMailForServer,
                                                 backColor: backColor,
                                                 icon: trashIcon,
                                                 text: getString(.userProfileDeleteMailForServer),
                                                 attributesForText: &attributesForText,
                                                 isSwitchOn: response.isDeleteFromServerOn))

            items.append(makeSeparatorVMWith(id: 4,
                                             backColor: backColor,
                                             borderWidth: UIHelper.Margins.small1px,
                                             separatorColor: separatorColor))

            items.append(makeIconTextAndSwitchVM(id: UserProfileModel.MenuItems.unsafeOutputAlert,
                                                 backColor: backColor,
                                                 icon: unsafeOutputAlertIcon,
                                                 text: getString(.userProfileUnsafeOutputAlert),
                                                 attributesForText: &attributesForText,
                                                 isSwitchOn: response.isUnsafeOutputAlertOn))

            items.append(makeSeparatorVMWith(id: 5,
                                             backColor: backColor,
                                             borderWidth: UIHelper.Margins.medium8px,
                                             separatorColor: separatorColor))

            items.append(makeIconTextAndSwitchVM(id: UserProfileModel.MenuItems.darkTheme,
                                                 backColor: backColor,
                                                 icon: themeIcon,
                                                 text: getString(.userProfileDarkTheme),
                                                 attributesForText: &attributesForText,
                                                 isSwitchOn: response.isDarkThemeOn))

            items.append(makeSeparatorVMWith(id: 6,
                                             backColor: backColor,
                                             borderWidth: UIHelper.Margins.small1px,
                                             separatorColor: separatorColor))

            items.append(makeIconTextAndChevronVM(id: UserProfileModel.MenuItems.info,
                                                  backColor: backColor,
                                                  icon: infoIcon,
                                                  text: getString(.aboutAppTitle),
                                                  attributesForText: attributesForText,
                                                  chevronImage: chevronImage))

            let title = NSAttributedString(
                string: getString(.userProfileTitle),
                attributes: Theme.shared.isLight ? UIHelper.Attributed.blackStrongLRobotoMedium18 : UIHelper.Attributed.whiteStrongRobotoMedium18)

            let navBar = CustomNavBar(title: title,
                                      isLeftBarButtonEnable: false,
                                      isLeftBarButtonCustom: false,
                                      leftBarButtonCustom: nil,
                                      rightBarButtons: [])

            DispatchQueue.main.async { [weak self] in
                self?.viewController?.displayUpdate(viewModel: UserProfileFlow.Update.ViewModel(
                    navBarBackground: backColor,
                    backViewColor: backColor,
                    navBar: navBar,
                    separatorUnderNavBarColor: separatorColor,
                    items: items)
                )
            }
        }
    }

    func presentAlert(response: UserProfileFlow.AlertInfo.Response) {
        let title = getString(.error)
        let text = response.error.localizedDescription
        let buttonTitle = getString(.closeAction)

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayAlert(
                viewModel: UserProfileFlow.AlertInfo.ViewModel(title: title,
                                                              text: text,
                                                              buttonTitle: buttonTitle))
        }
    }

    func presentWaitIndicator(response: UserProfileFlow.OnWaitIndicator.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayWaitIndicator(viewModel: UserProfileFlow.OnWaitIndicator.ViewModel(isShow: response.isShow))
        }
    }


    // MARK: - Private methods
    private func makeUserNameAndEmailVM(id: AnyHashable,
                                        backColor: UIColor,
                                        fullName: String,
                                        email: String,
                                        chevronImage: UIImage) -> AnyDifferentiable {

        let backColorOfImage = Alphabet.colorOfFirstLetter(in: fullName)
        let char = String(fullName.prefix(1))

        var avatarImage = UIImage()
        let semaphore = DispatchSemaphore(value: 0)
        ImageManager.createIcon(for: char,
                                backCellViewColor: backColor,
                                backColorOfImage: backColorOfImage,
                                width: Constants.mainImageWidthHeight,
                                height: Constants.mainImageWidthHeight) { image in
            avatarImage = image ?? UIImage()
            semaphore.signal()
        }
        semaphore.wait()

        let name = NSAttributedString(
            string: fullName,
            attributes: Theme.shared.isLight ? UIHelper.Attributed.blackStrongLRobotoRegular16 : UIHelper.Attributed.whiteStrongDRobotoRegular16)
        let email = NSAttributedString(
            string: email,
            attributes: UIHelper.Attributed.blueUnderlinedRobotoRegular14)

        let userProfileCellVM = UserProfileCellViewModel(
            id: id,
            cellBackColor: backColor,
            avatarImage: avatarImage,
            name: name,
            email: email,
            chevron: chevronImage, 
            insets: UIEdgeInsets(top: 0,
                                 left: UIHelper.Margins.medium16px,
                                 bottom: 0,
                                 right: UIHelper.Margins.medium16px))

        return AnyDifferentiable(userProfileCellVM)
    }

    private func makeSeparatorVMWith(id: AnyHashable,
                                     backColor: UIColor,
                                     borderWidth: CGFloat,
                                     separatorColor: UIColor)  -> AnyDifferentiable {
        let separatorCellVM = SeparatorCellViewModel(
            id: id,
            separatorColor: separatorColor,
            separatorBorderWidth: borderWidth,
            insets: UIEdgeInsets(top:0, left: 0, bottom: 0, right: 0))
        return AnyDifferentiable(separatorCellVM)
    }

    private func makeIconTextAndChevronVM(id: AnyHashable,
                                          backColor: UIColor,
                                          icon: UIImage,
                                          text: String,
                                          attributesForText: [NSAttributedString.Key : Any],
                                          chevronImage: UIImage) -> AnyDifferentiable {

        let title = NSAttributedString(string: text, attributes: attributesForText)

        let iconTextAndChevronVM = IconTextAndChevronCellViewModel(
            id: id,
            cellBackColor: backColor,
            icon: icon,
            title: title,
            chevron: chevronImage,
            insets: UIEdgeInsets(top: UIHelper.Margins.medium16px,
                                 left: UIHelper.Margins.medium16px,
                                 bottom: UIHelper.Margins.medium16px,
                                 right: UIHelper.Margins.medium16px))

        return AnyDifferentiable(iconTextAndChevronVM)
    }

    private func makeIconTextAndSwitchVM(id: AnyHashable,
                                         backColor: UIColor,
                                         icon: UIImage,
                                         text: String,
                                         attributesForText: inout [NSAttributedString.Key : Any],
                                         isSwitchOn: Bool) -> AnyDifferentiable {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.12
        attributesForText[.paragraphStyle] = paragraphStyle
        let title = NSAttributedString(string: text, attributes: attributesForText)

        let thumbColorOff = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.grayRegularD //circleOFF
        let tintColorBackOff = Theme.shared.isLight ? UIHelper.Color.grayL : UIHelper.Color.grayStrongD //backOFF
        let thumbColorOn = UIHelper.Color.blue //circleON_both
        let onTintColorBackOn = UIHelper.Color.darkBlue //backON

        let iconTextAndChevronVM = IconTextAndSwitchCellViewModel(
            id: id,
            cellBackColor: backColor, 
            icon: icon,
            title: title,
            isOn: isSwitchOn,
            thumbColorOff: thumbColorOff,
            thumbColorOn: thumbColorOn,
            tintColorBackOff: tintColorBackOff,
            onTintColorBackOn: onTintColorBackOn,
            insets: UIEdgeInsets(top: 0,
                                 left: UIHelper.Margins.medium16px,
                                 bottom: 0,
                                 right: UIHelper.Margins.medium16px))

        return AnyDifferentiable(iconTextAndChevronVM)
    }

}

