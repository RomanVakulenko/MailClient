//
//  SetPinCodeController.swift
//  SGTS
//
//  Created by Roman Vakulenko on 16.04.2024.
//

import UIKit
import SnapKit

protocol SetPinCodeDisplayLogic: AnyObject {
    func displayUpdate(viewModel: SetPinCodeFlow.Update.ViewModel)
//    func displayWaitIndicator(viewModel: SetPinCodeFlow.OnWaitIndicator.ViewModel)
//    func displayAlert(viewModel: SetPinCodeFlow.AlertInfo.ViewModel)
    func displayRouteToTabBarScreen(viewModel: SetPinCodeFlow.RoutePayload.ViewModel)
}

final class SetPinCodeController: UIViewController, NavigationBarControllable, FileShareable, AlertDisplayable {


    var interactor: SetPinCodeBusinessLogic?
    var router: (SetPinCodeRoutingLogic & SetPinCodeDataPassing)?

    lazy var contentView: SetPinCodeViewLogic = SetPinCodeView()

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
        interactor?.onDidLoadViews(request: SetPinCodeFlow.OnDidLoadViews.Request())
    }

    func leftNavBarButtonDidTapped() {
        self.navigationController?.popViewController(animated: true)
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

// MARK: - SetPinCodeDisplayLogic

extension SetPinCodeController: SetPinCodeDisplayLogic {

    func displayUpdate(viewModel: SetPinCodeFlow.Update.ViewModel) {
        configureNavigationBar(navBar: viewModel.navBar)
        setNeedsStatusBarAppearanceUpdate()
        showNavigationBar(animated: true)
        contentView.update(viewModel: viewModel)
    }

    func displayRouteToTabBarScreen(viewModel: SetPinCodeFlow.RoutePayload.ViewModel) {
        router?.routeToTabBarScreen()
    }

//    func displayWaitIndicator(viewModel: SetPinCodeFlow.OnWaitIndicator.ViewModel) {
//        contentView.displayWaitIndicator(viewModel: viewModel)
//    }
//
//    func displayAlert(viewModel: SetPinCodeFlow.AlertInfo.ViewModel) {
//        showAlert(title: viewModel.title,
//                  message: viewModel.text,
//                  firstButtonTitle: viewModel.buttonTitle ?? "Ok")
//    }
}

// MARK: - SetPinCodeViewOutput

extension SetPinCodeController: SetPinCodeViewOutput {
    func didSwitch(_ viewModel: SwitchBiometryCellViewModel, isOn: Bool) {
        interactor?.didTapAtBiometrySwitch(request: SetPinCodeFlow.OnSwitchTap.Request(isOn: isOn))
    }

    func onChangeText(_ viewModel: TextCellWithTitleAtBorderViewModel, currentText: String) {
        interactor?.onSelectItem(
            request: SetPinCodeFlow.OnSelectItem.Request(
                id: viewModel.id,
                selectedString: currentText)
        )
    }

    func didTapAt(_ viewModel: NextStepButtonCellViewModel) {
        interactor?.onSelectItem(
            request: SetPinCodeFlow.OnSelectItem.Request(
                id: viewModel.id,
                selectedString: nil)
        )
    }
}




