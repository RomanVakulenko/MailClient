//
//  InitialPresenter.swift
// 01.04.2024.
//

import UIKit
import DifferenceKit

protocol InitialPresentationLogic {
    func presentUpdate(response: InitialFlow.Update.Response)
//    func presentWaitIndicator(response: InitialFlow.OnWaitIndicator.Response)
//    func presentAlert(response: InitialFlow.AlertInfo.Response)
    func presentRouteToLogInRegistr(response: InitialFlow.RoutePayload.Response)
    func presentRouteToPinCode(response: InitialFlow.RoutePayload.Response)
    func presentRouteToTabBar(response: InitialFlow.RoutePayload.Response)
}

final class InitialPresenter: InitialPresentationLogic {

    enum Constants {}

    // MARK: - Public properties

    weak var viewController: InitialDisplayLogic?

    // MARK: - Public methods

    func presentUpdate(response: InitialFlow.Update.Response) {
        let backColor = Theme.shared.isLight ? UIHelper.Color.blue : UIHelper.Color.blackLightD

        let title = NSMutableAttributedString(
            string: getString(.initialTitle),
            attributes: UIHelper.Attributed.whiteRobotoBold18)

        let imgLogo = UIHelper.Image.initialLogoWhite

        let progressTintColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blue
        let trackTintColor = Theme.shared.isLight ? UIHelper.Color.blueLightL : UIHelper.Color.grayD

        let vm = InitialFlow.Update.ViewModel(backColor: backColor,
                                              imgLogo: imgLogo,
                                              title: title,
                                              progressTintColor: progressTintColor,
                                              trackTintColor: trackTintColor)

        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayUpdate(viewModel: vm)
        }
    }

//    func presentAlert(response: InitialFlow.AlertInfo.Response) {
//        let title = getString(.errorOccurred)
//        let text = getString(.contactTechnicalSupport)
//        let buttonTitle = getString(.closeAction)
//
//        DispatchQueue.main.async { [weak self] in
//            self?.viewController?.displayAlert(viewModel: InitialFlow.AlertInfo.ViewModel(title: title,
//                                                                                                           text: text,
//                                                                                                           buttonTitle: buttonTitle))
//        }
//    }

//    func presentWaitIndicator(response: InitialFlow.OnWaitIndicator.Response) {
//        DispatchQueue.main.async { [weak self] in
//            self?.viewController?.displayWaitIndicator(viewModel: InitialFlow.OnWaitIndicator.ViewModel(isShow: response.isShow))
//        }
//    }

    func presentRouteToLogInRegistr(response: InitialFlow.RoutePayload.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToLogInRegistr(
                viewModel: InitialFlow.RoutePayload.ViewModel())
        }
    }

    func presentRouteToPinCode(response: InitialFlow.RoutePayload.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToPinCode(
                viewModel: InitialFlow.RoutePayload.ViewModel())
        }
    }
    
    func presentRouteToTabBar(response: InitialFlow.RoutePayload.Response) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayRouteToTabBar(
                viewModel: InitialFlow.RoutePayload.ViewModel())
        }
    }
}
