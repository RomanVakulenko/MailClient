//
//  LogInRegistrController.swift
//  SGTS
//
//  Created by Roman Vakulenko on 03.04.2024.
//


import UIKit
import SnapKit

protocol LogInRegistrDisplayLogic: AnyObject {
    func displayUpdate(viewModel: LogInRegistrFlow.Update.ViewModel)
//    func displayWaitIndicator(viewModel: LogInRegistrFlow.OnWaitIndicator.ViewModel)
    func displayAlert(viewModel: LogInRegistrFlow.AlertInfo.ViewModel)
    func displayRouteToSecretKeySelectorScreen(viewModel: LogInRegistrFlow.RoutePayload.ViewModel)
    func displayRouteToQRScanScreen(viewModel: LogInRegistrFlow.RoutePayload.ViewModel)
}

final class LogInRegistrController: UIViewController, NavigationBarControllable, FileShareable, AlertDisplayable {

    var interactor: LogInRegistrBusinessLogic?
    var router: (LogInRegistrRoutingLogic & LogInRegistrDataPassing)?

    lazy var contentView: LogInRegistrViewLogic = LogInRegistrView()

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
        interactor?.onDidLoadViews(request: LogInRegistrFlow.OnDidLoadViews.Request())
    }

    func leftNavBarButtonDidTapped() {
        navigationController?.popViewController(animated: true)
    }

    func rightNavBarButtonTapped(index: Int) {}
    

    // MARK: - Private methods


    private func configure() {
        contentView.output = self
        addSubviews()
        configureConstraints()
    }

    private func addSubviews() {}

    private func configureConstraints() {}
}
// MARK: - LogInRegistrDisplayLogic
extension LogInRegistrController: LogInRegistrDisplayLogic {

    func displayRouteToSecretKeySelectorScreen(viewModel: LogInRegistrFlow.RoutePayload.ViewModel) {
        router?.routeToSecretKeySelectorScreen()
    }
    
    func displayRouteToQRScanScreen(viewModel: LogInRegistrFlow.RoutePayload.ViewModel) {
        router?.routeToQRScanScreen()
    }

    func displayUpdate(viewModel: LogInRegistrFlow.Update.ViewModel) {
        configureNavigationBar(navBar: viewModel.navBar)
        setNeedsStatusBarAppearanceUpdate()
        showNavigationBar(animated: true)
        contentView.update(viewModel: viewModel)
    }

//    func displayWaitIndicator(viewModel: LogInRegistrFlow.OnWaitIndicator.ViewModel) {
//        contentView.displayWaitIndicator(viewModel: viewModel)
//    }

    func displayAlert(viewModel: LogInRegistrFlow.AlertInfo.ViewModel) {
        showAlert(title: viewModel.title,
                  message: viewModel.text,
                  firstButtonTitle: viewModel.buttonTitle ?? "Ok")
    }
}

 // MARK: - LogInRegistrViewOutput
extension LogInRegistrController: LogInRegistrViewOutput {

    func loadKeysTapped() {
        interactor?.onDidTapButtonLoadKeys(request: LogInRegistrFlow.OnTapLoadKeys.Request())
//        router?.routeToSecretKeySelectorScreen()
    }

    func scanQRTapped() {
        interactor?.onDidTapButtonQRScan(request: LogInRegistrFlow.OnTapQRScan.Request())
//        router?.routeToQRScanScreen()
    }

}



