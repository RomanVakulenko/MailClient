//
//  UserProfileChangePinCodeController.swift
//  SGTS
//
//  Created by Roman Vakulenko on 28.06.2024.
//

import UIKit
import SnapKit

protocol UserProfileChangePinCodeDisplayLogic: AnyObject {
    func displayUpdate(viewModel: UserProfileChangePinCodeFlow.Update.ViewModel)
    func displayWaitIndicator(viewModel: UserProfileChangePinCodeFlow.OnWaitIndicator.ViewModel)
    func displayAlert(viewModel: UserProfileChangePinCodeFlow.AlertInfo.ViewModel)
    func displayRouteToSavePincode(viewModel: UserProfileChangePinCodeFlow.RoutePayload.ViewModel)
    func displayRouteBackToUserProfile(viewModel: UserProfileChangePinCodeFlow.RoutePayload.ViewModel)
}

final class UserProfileChangePinCodeController: UIViewController, NavigationBarControllable, FileShareable, AlertDisplayable {


    var interactor: UserProfileChangePinCodeBusinessLogic?
    var router: (UserProfileChangePinCodeRoutingLogic & UserProfileChangePinCodeDataPassing)?

    lazy var contentView: UserProfileChangePinCodeViewLogic = UserProfileChangePinCodeView()

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
        interactor?.onDidLoadViews(request: UserProfileChangePinCodeFlow.OnDidLoadViews.Request())
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

// MARK: - UserProfileChangePinCodeDisplayLogic

extension UserProfileChangePinCodeController: UserProfileChangePinCodeDisplayLogic {

    func displayUpdate(viewModel: UserProfileChangePinCodeFlow.Update.ViewModel) {
        configureNavigationBar(navBar: viewModel.navBar)
        setNeedsStatusBarAppearanceUpdate()
        showNavigationBar(animated: true)
        contentView.update(viewModel: viewModel)
    }

    func displayRouteToSavePincode(viewModel: UserProfileChangePinCodeFlow.RoutePayload.ViewModel) {
        router?.doSavePincode()
    }

    func displayRouteBackToUserProfile(viewModel: UserProfileChangePinCodeFlow.RoutePayload.ViewModel) {
        router?.cancelAndGetBackToUserProfile()
    }

    func displayWaitIndicator(viewModel: UserProfileChangePinCodeFlow.OnWaitIndicator.ViewModel) {
        contentView.displayWaitIndicator(viewModel: viewModel)
    }

    func displayAlert(viewModel: UserProfileChangePinCodeFlow.AlertInfo.ViewModel) {
        showAlert(title: viewModel.title,
                  message: viewModel.text,
                  firstButtonTitle: viewModel.buttonTitle ?? "Ok")
    }
}

// MARK: - UserProfileChangePinCodeViewOutput

extension UserProfileChangePinCodeController: UserProfileChangePinCodeViewOutput {
    func didSwitch(_ viewModel: SwitchBiometryCellViewModel, isOn: Bool) {
        interactor?.didTapAtBiometrySwitch(request: UserProfileChangePinCodeFlow.OnSwitchTap.Request(isOn: isOn))
    }

    func onChangeText(_ viewModel: TextCellWithTitleAtBorderViewModel, currentText: String) {
        interactor?.onSelectItem(
            request: UserProfileChangePinCodeFlow.OnSelectItem.Request(
                id: viewModel.id,
                selectedString: currentText)
        )
    }

    func didTapAt(_ viewModel: NextStepButtonCellViewModel) {
        interactor?.onSelectItem(
            request: UserProfileChangePinCodeFlow.OnSelectItem.Request(
                id: viewModel.id,
                selectedString: nil)
        )
    }
}




