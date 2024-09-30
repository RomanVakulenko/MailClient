//
//  UserProfileSetSignatureController.swift
//  SGTS
//
//  Created by Roman Vakulenko on 28.06.2024.
//

import UIKit
import SnapKit

protocol UserProfileSetSignatureDisplayLogic: AnyObject {
    func displayUpdate(viewModel: UserProfileSetSignatureFlow.Update.ViewModel)
    func displayWaitIndicator(viewModel: UserProfileSetSignatureFlow.OnWaitIndicator.ViewModel)
    func displayAlert(viewModel: UserProfileSetSignatureFlow.AlertInfo.ViewModel)
    func displayRouteToSavePincode(viewModel: UserProfileSetSignatureFlow.RoutePayload.ViewModel)
    func displayRouteBackToUserProfile(viewModel: UserProfileSetSignatureFlow.RoutePayload.ViewModel)
}

final class UserProfileSetSignatureController: UIViewController, NavigationBarControllable, FileShareable, AlertDisplayable {


    var interactor: UserProfileSetSignatureBusinessLogic?
    var router: (UserProfileSetSignatureRoutingLogic & UserProfileSetSignatureDataPassing)?

    lazy var contentView: UserProfileSetSignatureViewLogic = UserProfileSetSignatureView()

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
        interactor?.onDidLoadViews(request: UserProfileSetSignatureFlow.OnDidLoadViews.Request())
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

// MARK: - UserProfileSetSignatureDisplayLogic

extension UserProfileSetSignatureController: UserProfileSetSignatureDisplayLogic {

    func displayUpdate(viewModel: UserProfileSetSignatureFlow.Update.ViewModel) {
        configureNavigationBar(navBar: viewModel.navBar)
        setNeedsStatusBarAppearanceUpdate()
        showNavigationBar(animated: true)
        contentView.update(viewModel: viewModel)
    }

    func displayRouteToSavePincode(viewModel: UserProfileSetSignatureFlow.RoutePayload.ViewModel) {
        router?.doSaveSignature()
        interactor?.disableSaveButton()
    }

    func displayRouteBackToUserProfile(viewModel: UserProfileSetSignatureFlow.RoutePayload.ViewModel) {
        router?.cancelAndGetBackToUserProfile()
    }

    func displayWaitIndicator(viewModel: UserProfileSetSignatureFlow.OnWaitIndicator.ViewModel) {
        contentView.displayWaitIndicator(viewModel: viewModel)
    }

    func displayAlert(viewModel: UserProfileSetSignatureFlow.AlertInfo.ViewModel) {
        showAlert(title: viewModel.title,
                  message: viewModel.text,
                  firstButtonTitle: viewModel.buttonTitle ?? "Ok")
    }
}

// MARK: - UserProfileSetSignatureViewOutput

extension UserProfileSetSignatureController: UserProfileSetSignatureViewOutput {
    func onChangeTextInTextView(_ viewModel: TextViewCellViewModel, currentText: String) {
        interactor?.onSelectItem(
            request: UserProfileSetSignatureFlow.OnSelectItem.Request(
                id: viewModel.id,
                enteredText: currentText))
    }

    func didTapAt(_ viewModel: NextStepButtonCellViewModel) {
        interactor?.onSelectItem(
            request: UserProfileSetSignatureFlow.OnSelectItem.Request(
                id: viewModel.id,
                enteredText: nil))
    }
}




