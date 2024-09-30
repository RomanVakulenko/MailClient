//
//  InitialController.swift
// 01.04.2024.
//

import UIKit
import SnapKit

protocol InitialDisplayLogic: AnyObject {
    func displayUpdate(viewModel: InitialFlow.Update.ViewModel)
    func displayWaitIndicator(viewModel: InitialFlow.OnWaitIndicator.ViewModel)
//    func displayAlert(viewModel: InitialFlow.AlertInfo.ViewModel)
    func displayRouteToLogInRegistr(viewModel: InitialFlow.RoutePayload.ViewModel)
    func displayRouteToPinCode(viewModel: InitialFlow.RoutePayload.ViewModel)
    func displayRouteToTabBar(viewModel: InitialFlow.RoutePayload.ViewModel)
    
}

final class InitialController: UIViewController, FileShareable, AlertDisplayable {

    var interactor: InitialBusinessLogic?
    var router: (InitialRoutingLogic & InitialDataPassing)?
    
    lazy var contentView: InitialViewLogic = InitialView()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.shared.isLight ? .darkContent : .lightContent
    }
    // MARK: - Lifecycle
    
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setNeedsStatusBarAppearanceUpdate()
        interactor?.onDidLoadViews(request: InitialFlow.OnDidLoadViews.Request())
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interactor?.onDidAppear(request: InitialFlow.OnDidAppear.Request())
    }

    // MARK: - Private methods

    private func configure() {
        contentView.output = self
    }

//    private func showAlert(title: String?,
//                           message: String?,
//                           firstButtonTitle: String) {
//    }

}
// MARK: - InitialDisplayLogic
extension InitialController: InitialDisplayLogic {
    func displayRouteToTabBar(viewModel: InitialFlow.RoutePayload.ViewModel) {
        router?.routeToTabBarScreen()
    }
    
    func displayRouteToLogInRegistr(viewModel: InitialFlow.RoutePayload.ViewModel) {
        router?.routeToLogInRegistr()
    }

    func displayRouteToPinCode(viewModel: InitialFlow.RoutePayload.ViewModel) {
        router?.routeToPinCode()
    }

    func displayUpdate(viewModel: InitialFlow.Update.ViewModel) {
        contentView.update(viewModel: viewModel)
    }
    
    func displayWaitIndicator(viewModel: InitialFlow.OnWaitIndicator.ViewModel) {
        contentView.displayWaitIndicator(viewModel: viewModel)
    }
    
//    func displayAlert(viewModel: InitialFlow.AlertInfo.ViewModel) {
//        showAlert(title: viewModel.title,
//                  message: viewModel.text,
//                  firstButtonTitle: viewModel.buttonTitle ?? "Ok")
//    }
}

 // MARK: - InitialViewOutput
extension InitialController: InitialViewOutput {

}

