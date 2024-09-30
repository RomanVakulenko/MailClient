//
//  UserProfileChangeNameController.swift
//  SGTS
//
//  Created by Roman Vakulenko on 24.06.2024.
//

import UIKit
import SnapKit

protocol UserProfileChangeNameDisplayLogic: AnyObject {
    func displayUpdate(viewModel: UserProfileChangeNameFlow.Update.ViewModel)
    func displayWaitIndicator(viewModel: UserProfileChangeNameFlow.OnWaitIndicator.ViewModel)
    func displayAlert(viewModel: UserProfileChangeNameFlow.AlertInfo.ViewModel)
    func displayRouteBack(viewModel: UserProfileChangeNameFlow.RoutePayload.ViewModel)
}

final class UserProfileChangeNameController: UIViewController, FileShareable, AlertDisplayable, NavigationBarControllable {

//    enum Constants {
//    }

    var interactor: UserProfileChangeNameBusinessLogic?
    var router: (UserProfileChangeNameRoutingLogic & UserProfileChangeNameDataPassing)?
    
    lazy var contentView: UserProfileChangeNameViewLogic = UserProfileChangeNameView()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.shared.isLight ? .darkContent : .lightContent
    }

    // MARK: - Private properties

    // MARK: - Lifecycle

    override func loadView() {
        contentView.output = self
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        hideNavigationBar(animated: false)
        interactor?.onDidLoadViews(request: UserProfileChangeNameFlow.OnDidLoadViews.Request())
    }


    // MARK: - Private methods
    private func configure() {
        addSubviews()
        configureConstraints()
    }

    private func addSubviews() { }

    private func configureConstraints() { }
}

// MARK: - UserProfileChangeNameDisplayLogic

extension UserProfileChangeNameController: UserProfileChangeNameDisplayLogic {

//    func displayRouteToUserProfileChangeName(viewModel: UserProfileChangeNameFlow.OnLongPressGestureTap.ViewModel) {
//        router?.routeToUserProfileChangeName(viewModel: UserProfileChangeNameFlow.OnLongPressGestureTap.ViewModel(selectedEmailIds: viewModel.selectedEmailIds))
//    }

    func displayUpdate(viewModel: UserProfileChangeNameFlow.Update.ViewModel) {
        setNeedsStatusBarAppearanceUpdate()
        contentView.update(viewModel: viewModel)

    }

    func displayRouteBack(viewModel: UserProfileChangeNameFlow.RoutePayload.ViewModel) {
        router?.routeBack(from: self)
    }


//    func displayRouteToMailStartScreen(viewModel: UserProfileChangeNameFlow.RoutePayload.ViewModel) {
//        router?.routeToMailStartScreen(viewModel: UserProfileChangeNameFlow.RoutePayload.ViewModel())
//    }
    
    func displayWaitIndicator(viewModel: UserProfileChangeNameFlow.OnWaitIndicator.ViewModel) {
        contentView.displayWaitIndicator(viewModel: viewModel)
    }

    func displayAlert(viewModel: UserProfileChangeNameFlow.AlertInfo.ViewModel) {
        showAlert(title: viewModel.title,
                  message: viewModel.text,
                  firstButtonTitle: viewModel.buttonTitle ?? "Ok")
    }

}

// MARK: - UserProfileChangeNameViewOutput

extension UserProfileChangeNameController: UserProfileChangeNameViewOutput {
    func onChangeText(_ viewModel: UserProfileChangeNameViewModel, currentText: String) {
        interactor?.changeInputText(
            request: UserProfileChangeNameFlow.OnTextFieldDidChange.Request(enteredSenderName: currentText))
    }

    func didTapCancel() {
        interactor?.didTapCancel(request: UserProfileChangeNameFlow.RoutePayload.Request())
    }

    func didTapSave() {
        interactor?.didTapCancel(request: UserProfileChangeNameFlow.RoutePayload.Request())
    }
}


