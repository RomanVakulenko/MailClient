//
//  UserProfileController.swift
//  SGTS
//
//  Created by Roman Vakulenko on 16.06.2024.
//

import UIKit
import SnapKit

protocol UserProfileDisplayLogic: AnyObject {
    func displayUpdate(viewModel: UserProfileFlow.Update.ViewModel)
    func displayWaitIndicator(viewModel: UserProfileFlow.OnWaitIndicator.ViewModel)
    func displayAlert(viewModel: UserProfileFlow.AlertInfo.ViewModel)
    func displayRouteToNameEditingScreen(viewModel: UserProfileFlow.RoutePayload.ViewModel)
    func displayRouteToPinCodeEditingScreen(viewModel: UserProfileFlow.RoutePayload.ViewModel)
    func displayRouteToSignatureScreen(viewModel: UserProfileFlow.RoutePayload.ViewModel)
    func displayRouteToReportScreen(viewModel: UserProfileFlow.RoutePayload.ViewModel)
    func displayRouteToInfoScreen(viewModel: UserProfileFlow.RoutePayload.ViewModel)
    func displayRouteToSideMenu(viewModel: UserProfileFlow.RoutePayload.ViewModel)
}

final class UserProfileController: UIViewController, NavigationBarControllable, FileShareable, AlertDisplayable {


    var interactor: UserProfileBusinessLogic?
    var router: (UserProfileRoutingLogic & UserProfileDataPassing)?

    lazy var contentView: UserProfileViewLogic = UserProfileView()

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
        interactor?.onDidLoadViews(request: UserProfileFlow.OnDidLoadViews.Request())
    }

    func leftNavBarButtonDidTapped() {
        interactor?.didTapSideMenuBarButton(request: UserProfileFlow.RoutePayload.Request())
    }

    func rightNavBarButtonTapped(index: Int) {}

    // MARK: - Private methods
    private func configure() {
        addSubviews()
        configureConstraints()
    }

    private func addSubviews() { }

    private func configureConstraints() { }
}

// MARK: - UserProfileDisplayLogic

extension UserProfileController: UserProfileDisplayLogic {

    func displayRouteToSideMenu(viewModel: UserProfileFlow.RoutePayload.ViewModel) {
        router?.routeToSideMenu()
    }
    
    func displayUpdate(viewModel: UserProfileFlow.Update.ViewModel) {
        configureNavigationBar(navBar: viewModel.navBar)
        setNeedsStatusBarAppearanceUpdate()
        showNavigationBar(animated: false)
        contentView.update(viewModel: viewModel)
    }

    func displayRouteToNameEditingScreen(viewModel: UserProfileFlow.RoutePayload.ViewModel) {
        router?.routeToNameEditingScreen()
    }

    func displayRouteToPinCodeEditingScreen(viewModel: UserProfileFlow.RoutePayload.ViewModel) {
        router?.routeToPinCodeEditingScreen()
    }

    func displayRouteToSignatureScreen(viewModel: UserProfileFlow.RoutePayload.ViewModel) {
        router?.routeToSignatureScreen()
    }

    func displayRouteToReportScreen(viewModel: UserProfileFlow.RoutePayload.ViewModel) {
        router?.routeToReportScreen()
    }

    func displayRouteToInfoScreen(viewModel: UserProfileFlow.RoutePayload.ViewModel) {
        router?.routeToInfoScreen()
    }

    func displayWaitIndicator(viewModel: UserProfileFlow.OnWaitIndicator.ViewModel) {
        contentView.displayWaitIndicator(viewModel: viewModel)
    }

    func displayAlert(viewModel: UserProfileFlow.AlertInfo.ViewModel) {
        showAlert(title: viewModel.title,
                  message: viewModel.text,
                  firstButtonTitle: viewModel.buttonTitle ?? "Ok")
    }
}

// MARK: - UserProfileViewOutput

extension UserProfileController: UserProfileViewOutput {

    func didTapAtCell(_ viewModel: UserProfileCellViewModel) {
        interactor?.onSelectItem(request: UserProfileFlow.OnSelectItem.Request(id: viewModel.id))
    }
    
    func didTapAtCell(_ viewModel: IconTextAndChevronCellViewModel) {
        interactor?.onSelectItem(request: UserProfileFlow.OnSelectItem.Request(id: viewModel.id))
    }
    
    //    func didSwitch(_ viewModel: IconTextAndSwitchCellViewModel, isOn: Bool) {
    //        interactor?.onSwitch(request: UserProfileFlow.OnSwitch.Request(id: viewModel.id, isSwitchOn: isOn))
    //    }
    func didSwitch(_ viewModel: IconTextAndSwitchCellViewModel) {
        interactor?.onSwitch(request: UserProfileFlow.OnSwitch.Request(id: viewModel.id))
    }
}




