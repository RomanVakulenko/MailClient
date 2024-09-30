//
//  AboutAppScreenController.swift
//  SGTS
//
//  Created by Roman Vakulenko on 24.06.2024.
//

import UIKit
import SnapKit

protocol AboutAppScreenDisplayLogic: AnyObject {
    func displayUpdate(viewModel: AboutAppScreenFlow.Update.ViewModel)
    //    func displayAlert(viewModel: AboutAppScreenFlow.AlertInfo.ViewModel)
    func displayRouteBack(viewModel: AboutAppScreenFlow.RoutePayload.ViewModel)
    func displayRouteToSendLog(viewModel: AboutAppScreenFlow.RoutePayload.ViewModel)
}

final class AboutAppScreenController: UIViewController, FileShareable, AlertDisplayable, NavigationBarControllable {

    var interactor: AboutAppScreenBusinessLogic?
    var router: AboutAppScreenRoutingLogic?
    
    lazy var contentView: AboutAppScreenViewLogic = AboutAppScreenView()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.shared.isLight ? .darkContent : .lightContent
    }

    // MARK: - Lifecycle

    override func loadView() {
        contentView.output = self
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        hideNavigationBar(animated: false)
        interactor?.onDidLoadViews(request: AboutAppScreenFlow.OnDidLoadViews.Request())
    }


    // MARK: - Private methods
    private func configure() {
        addSubviews()
        configureConstraints()
    }

    private func addSubviews() { }

    private func configureConstraints() { }
}

// MARK: - AboutAppScreenDisplayLogic

extension AboutAppScreenController: AboutAppScreenDisplayLogic {
    func displayRouteToSendLog(viewModel: AboutAppScreenFlow.RoutePayload.ViewModel) {
        router?.routeToSendLog()
    }
    
    func displayUpdate(viewModel: AboutAppScreenFlow.Update.ViewModel) {
        setNeedsStatusBarAppearanceUpdate()
        contentView.update(viewModel: viewModel)
    }

    func displayRouteBack(viewModel: AboutAppScreenFlow.RoutePayload.ViewModel) {
        router?.routeBack()
    }

//    func displayAlert(viewModel: AboutAppScreenFlow.AlertInfo.ViewModel) {
//        showAlert(title: viewModel.title,
//                  message: viewModel.text,
//                  firstButtonTitle: viewModel.buttonTitle ?? "Ok")
//    }

}

// MARK: - AboutAppScreenViewOutput

extension AboutAppScreenController: AboutAppScreenViewOutput {
    func didFiveTapOnLogo() {
        interactor?.onFiveTap(request: AboutAppScreenFlow.RoutePayload.Request())
    }
    
    func didTapCancel() {
        interactor?.didTapCancel(request: AboutAppScreenFlow.RoutePayload.Request())
    }

}


