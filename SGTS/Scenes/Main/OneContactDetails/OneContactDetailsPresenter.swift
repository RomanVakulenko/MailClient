//
//  OneContactDetailsPresenter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 03.04.2024.
//

import UIKit
import DifferenceKit

protocol OneContactDetailsPresentationLogic {
    func presentUpdate(response: OneContactDetailsFlow.Update.Response)
//    func presentWaitIndicator(response: OneContactDetailsFlow.OnWaitIndicator.Response)
    func presentAlert(response: OneContactDetailsFlow.AlertInfo.Response)
    func presentRouteBackToAddressBook(response: OneContactDetailsFlow.RoutePayload.Response)
    func presentRouteToCallNumber(response: OneContactDetailsFlow.RoutePayload.Response)
}

final class OneContactDetailsPresenter: OneContactDetailsPresentationLogic {

    private enum Constants {
        static let avatarSize: CGFloat = 124
    }

    // MARK: - Public properties
    weak var viewController: OneContactDetailsDisplayLogic?

    // MARK: - Public methods

    func presentRouteBackToAddressBook(response: OneContactDetailsFlow.RoutePayload.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteBackToAddressBook(viewModel: OneContactDetailsFlow.RoutePayload.ViewModel())
        }
    }

    func presentRouteToCallNumber(response: OneContactDetailsFlow.RoutePayload.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToCallNumber(
                viewModel: OneContactDetailsFlow.RoutePayload.ViewModel())
        }
    }

    func presentUpdate(response: OneContactDetailsFlow.Update.Response) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            let title = NSAttributedString(
                string: getString(.oneContactDetailsTitle),
                attributes: Theme.shared.isLight ? UIHelper.Attributed.blackStrongLRobotoMedium18 : UIHelper.Attributed.whiteStrongRobotoMedium18)

            let backColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD
            let separatorColor = Theme.shared.isLight ? UIHelper.Color.grayLightL : UIHelper.Color.grayStrongD

            let avatarImg = makeAvatar(id: response.id, backColor: backColor, fullName: response.fullName)

            let fullName = NSAttributedString(
                string: response.fullName,
                attributes: Theme.shared.isLight ? UIHelper.Attributed.blackStrongLRobotoMedium18 : UIHelper.Attributed.whiteStrongRobotoMedium18)

            let emailTitle = NSAttributedString(
                string: getString(.oneContactDetailsEmailTitle),
                attributes: Theme.shared.isLight ? UIHelper.Attributed.blackStrongLRobotoRegular16 : UIHelper.Attributed.whiteStrongDRobotoRegular16)
            let emailAddress = NSAttributedString(
                string: response.emailAddress ?? "",
                attributes: UIHelper.Attributed.blueUnderlinedRobotoRegular16)

            let phoneTitle = NSAttributedString(
                string: getString(.oneContactDetailsPhoneTitle),
                attributes: Theme.shared.isLight ? UIHelper.Attributed.blackStrongLRobotoRegular16 : UIHelper.Attributed.whiteStrongDRobotoRegular16)
            let phoneNumber = NSAttributedString(
                string: response.phoneNumber ?? "",
                attributes: Theme.shared.isLight ? UIHelper.Attributed.blackStrongLRobotoRegular16 : UIHelper.Attributed.whiteStrongDRobotoRegular16)

            let iinTitle = NSAttributedString(
                string: getString(.oneContactDetailsIINTitle),
                attributes: Theme.shared.isLight ? UIHelper.Attributed.blackStrongLRobotoRegular16 : UIHelper.Attributed.whiteStrongDRobotoRegular16)
            let iin = NSAttributedString(
                string: response.iin ?? "",
                attributes: Theme.shared.isLight ? UIHelper.Attributed.blackStrongLRobotoRegular16 : UIHelper.Attributed.whiteStrongDRobotoRegular16)

            let navBar = CustomNavBar(title: title,
                                      isLeftBarButtonEnable: true,
                                      isLeftBarButtonCustom: false,
                                      leftBarButtonCustom: nil,
                                      rightBarButtons: [])

            let viewModel = OneContactDetailsFlow.Update.ViewModel(
                navBarBackground: backColor,
                navBar: navBar,
                backColor: backColor,
                separatorColor: separatorColor,
                avatarImg: avatarImg,
                fullName: fullName,
                emailTitle: emailTitle,
                emailAddress: emailAddress,
                phoneTitle: phoneTitle,
                phoneNumber: phoneNumber,
                iinTitle: iinTitle,
                iin: iin)

            DispatchQueue.main.async { [weak self] in
                self?.viewController?.displayUpdate(viewModel: viewModel)
            }
        }
    }

    func presentAlert(response: OneContactDetailsFlow.AlertInfo.Response) {
        let title = getString(.error)
        let text = getString(.oneContactDetailsInvalidPhoneNumber)
        let buttonTitle = getString(.closeAction)

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayAlert(viewModel: OneContactDetailsFlow.AlertInfo.ViewModel(title: title,
                                                                                                    text: text,
                                                                                                    buttonTitle: buttonTitle))
        }
    }
    //    func presentWaitIndicator(response: OneContactDetailsFlow.OnWaitIndicator.Response) {
    //        DispatchQueue.main.async { [weak self] in
    //            self?.viewController?.displayWaitIndicator(viewModel: OneContactDetailsFlow.OnWaitIndicator.ViewModel(isShow: response.isShow))
    //        }
    //    }

    // MARK: - Private methods
    private func makeAvatar(id: AnyHashable,
                            backColor: UIColor,
                            fullName: String) -> UIImage {

        let backColorOfImage = Alphabet.colorOfFirstLetter(in: fullName)
        let char = String(fullName.prefix(1))

        var avatarImage = UIImage()
        let semaphore = DispatchSemaphore(value: 0)
        ImageManager.createIcon(for: char,
                                backCellViewColor: backColor,
                                backColorOfImage: backColorOfImage,
                                width: Constants.avatarSize,
                                height: Constants.avatarSize) { image in
            avatarImage = image ?? UIImage()
            semaphore.signal()
        }
        semaphore.wait()

        return avatarImage
    }
}
