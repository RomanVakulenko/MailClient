//
//  PinCodePresenter.swift
//  SGTS
//
//  Created by Roman Vakulenko on 04.04.2024.
//

import UIKit
import DifferenceKit

protocol PinCodePresentationLogic {
    func presentUpdate(response: PinCodeFlow.Update.Response)
//    func presentWaitIndicator(response: PinCodeFlow.OnWaitIndicator.Response)
    func presentAlert(response: PinCodeFlow.AlertInfo.Response)
    func presentRouteToNextScreen(response: PinCodeFlow.RoutePayload.Response)
    func prepareFaceIdScreening(response: PinCodeFlow.OnFaceDetection.Response)

}

final class PinCodePresenter: PinCodePresentationLogic {

    enum PinState {
        case notEntering, entering, ok, bad, deleteOneDigit
    }

    // MARK: - Public properties

    weak var viewController: PinCodeDisplayLogic?

    var colorsForCircles = Array(
        repeating: Theme.shared.isLight ? UIHelper.Color.grayLightL : UIHelper.Color.grayStrongD,
        count: 4)
    let allCirclesGray = Array(
        repeating: Theme.shared.isLight ? UIHelper.Color.blackMiddleL : UIHelper.Color.whiteStrong,
        count: 4)

    // MARK: - Public methods

    func presentUpdate(response: PinCodeFlow.Update.Response) {
        let backColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD
        
        let title = NSMutableAttributedString(
            string: getString(.pinCodeTitle),
            attributes: Theme.shared.isLight ? UIHelper.Attributed.blackStrongLRobotoMedium18 : UIHelper.Attributed.whiteStrongRobotoMedium18)

        let separatorColor = Theme.shared.isLight ? UIHelper.Color.grayLightL : UIHelper.Color.grayStrongD

        let labelEnterPin = makeLabelEnterPin()

        let navBar = CustomNavBar(title: title,
                            isLeftBarButtonEnable: false,
                            isLeftBarButtonCustom: false,
                            leftBarButtonCustom: nil,
                            rightBarButtons: [])

        var viewModel = PinCodeFlow.Update.ViewModel(
            items: [],
            enteredDigitsCount: response.amountOfEnteredDigits,
            backColor: backColor,
            title: title, //или навБар или шеврон назад - учтонить
            navBar: navBar,
            separatorColor: separatorColor,
            enterPinLabel: labelEnterPin,
            circleColors: colorsForCircles,
            didDeleteDigit: false)

        switch response.pinState {
        case .notEntering:
            ()
        case .entering, .ok:
            colorsForCircles = (0..<response.amountOfEnteredDigits).map { _ in
                Theme.shared.isLight ? UIHelper.Color.blackMiddleL : UIHelper.Color.whiteStrong
            }
        case .bad:
            colorsForCircles = (0..<response.amountOfEnteredDigits).map { _ in UIColor.red }
        case .deleteOneDigit:
            colorsForCircles = allCirclesGray
            colorsForCircles[response.amountOfEnteredDigits] = Theme.shared.isLight ? UIHelper.Color.grayLightL : UIHelper.Color.grayStrongD
            viewModel.didDeleteDigit = true
        }
        viewModel.circleColors = colorsForCircles


        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayUpdate(viewModel: viewModel)
        }
    }

    func prepareFaceIdScreening(response: PinCodeFlow.OnFaceDetection.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.checkUserPermissionAndDetectFace(viewModel: PinCodeFlow.RoutePayload.ViewModel())
        }
    }

    func presentRouteToNextScreen(response: PinCodeFlow.RoutePayload.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToNextScreen(viewModel: PinCodeFlow.RoutePayload.ViewModel())
        }
    }

    func presentAlert(response: PinCodeFlow.AlertInfo.Response) {
        let title = getString(.error)
        let getText = PinCodeModel.Errors.getErrorText(response.error)
        let buttonTitle = getString(.closeAction)

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayAlert(viewModel: PinCodeFlow.AlertInfo.ViewModel(
                title: title,
                text: getText(),
                buttonTitle: buttonTitle))
        }
    }
    
//    func presentWaitIndicator(response: PinCodeFlow.OnWaitIndicator.Response) {
//        DispatchQueue.main.async { [weak self] in
//            self?.viewController?.displayWaitIndicator(viewModel: PinCodeFlow.OnWaitIndicator.ViewModel(isShow: response.isShow))
//        }
//    }

    // MARK: - Private methods

    private func makeLabelEnterPin() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(
            string: getString(.enterPin),
            attributes: Theme.shared.isLight ? UIHelper.Attributed.blackMiddleLRobotoSemibold17 : UIHelper.Attributed.whiteStrongRobotoSemibold17)
        return attributedString
    }
}


// MARK: - PinCodeModel.Errors

private extension PinCodeModel.Errors {

    func getErrorText() -> String {
        switch self {
        case .cameraAccessDenied:
            return "Доступ к камере запрещен"
        case .cameraAccessDeniedOrRestricted:
            return "Доступ к камере запрещен или ограничен"
        case .errorAtFaceDetection:
            return "Ошибка при обнаружении лица"
        }
    }
}
