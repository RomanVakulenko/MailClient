//
//  EnterQRPasswordController.swift
//  SGTS
//
//  Created by Roman Vakulenko on 09.04.2024.
//

import UIKit
import SnapKit

protocol EnterQRPasswordDisplayLogic: AnyObject {
    func displayUpdate(viewModel: EnterQRPasswordFlow.Update.ViewModel)
//    func displayWaitIndicator(viewModel: EnterQRPasswordFlow.OnWaitIndicator.ViewModel)
//    func displayAlert(viewModel: EnterQRPasswordFlow.AlertInfo.ViewModel)
    func displayRouteToEnterKeyFilePasswordScreen(viewModel: EnterQRPasswordFlow.RoutePayload.ViewModel)
}

final class EnterQRPasswordController: UIViewController, NavigationBarControllable, FileShareable, AlertDisplayable {

    var interactor: EnterQRPasswordBusinessLogic?
    var router: (EnterQRPasswordRoutingLogic & EnterQRPasswordDataPassing)?
    
    lazy var contentView: EnterQRPasswordViewLogic = EnterQRPasswordView()

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
        interactor?.onDidLoadViews(request: EnterQRPasswordFlow.OnDidLoadViews.Request())
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

// MARK: - EnterQRPasswordDisplayLogic

extension EnterQRPasswordController: EnterQRPasswordDisplayLogic {

    func displayUpdate(viewModel: EnterQRPasswordFlow.Update.ViewModel) {
        configureNavigationBar(navBar: viewModel.navBar)
        setNeedsStatusBarAppearanceUpdate()
        showNavigationBar(animated: true)
        contentView.update(viewModel: viewModel)
    }

    func displayRouteToEnterKeyFilePasswordScreen(viewModel: EnterQRPasswordFlow.RoutePayload.ViewModel) {
        router?.routeToEnterKeyFilePasswordScreen()
    }
    
//    func displayWaitIndicator(viewModel: EnterQRPasswordFlow.OnWaitIndicator.ViewModel) {
//        contentView.displayWaitIndicator(viewModel: viewModel)
//    }
//
//    func displayAlert(viewModel: EnterQRPasswordFlow.AlertInfo.ViewModel) {
//        showAlert(title: viewModel.title,
//                  message: viewModel.text,
//                  firstButtonTitle: viewModel.buttonTitle ?? "Ok")
//    }
}

// MARK: - EnterQRPasswordViewOutput

extension EnterQRPasswordController: EnterQRPasswordViewOutput {

    func onChangeText(_ viewModel: TextCellWithTitleAtBorderViewModel, currentText: String) {
        interactor?.changeInputText(
            request: EnterQRPasswordFlow.OnSelectItem.Request(
                id: viewModel.id,
                selectedString: currentText)
        )
    }

    func didTapAt(_ viewModel: NextStepButtonCellViewModel) {
        interactor?.onSelectItem(
            request: EnterQRPasswordFlow.OnSelectItem.Request(
                id: viewModel.id,
                selectedString: nil)
        )
    }
}



