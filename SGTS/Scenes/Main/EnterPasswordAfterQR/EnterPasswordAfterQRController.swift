//
//  EnterPasswordAfterQRController.swift
//  SGTS
//
//  Created by Roman Vakulenko on 09.04.2024.
//

import UIKit
import SnapKit

protocol EnterPasswordAfterQRDisplayLogic: AnyObject {
    func displayUpdate(viewModel: EnterPasswordAfterQRFlow.Update.ViewModel)
//    func displayWaitIndicator(viewModel: EnterPasswordAfterQRFlow.OnWaitIndicator.ViewModel)
//    func displayAlert(viewModel: EnterPasswordAfterQRFlow.AlertInfo.ViewModel)
    func displayRouteToEnterQRPassword(viewModel: EnterPasswordAfterQRFlow.RoutePayload.ViewModel)
}

final class EnterPasswordAfterQRController: UIViewController, NavigationBarControllable, FileShareable, AlertDisplayable {
    
    var interactor: EnterPasswordAfterQRBusinessLogic?
    var router: (EnterPasswordAfterQRRoutingLogic & EnterPasswordAfterQRDataPassing)?
    
    lazy var contentView: EnterPasswordAfterQRViewLogic = EnterPasswordAfterQRView()

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
        interactor?.onDidLoadViews(request: EnterPasswordAfterQRFlow.OnDidLoadViews.Request())
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

// MARK: - EnterPasswordAfterQRDisplayLogic

extension EnterPasswordAfterQRController: EnterPasswordAfterQRDisplayLogic {
    
    func displayUpdate(viewModel: EnterPasswordAfterQRFlow.Update.ViewModel) {
        configureNavigationBar(navBar: viewModel.navBar)
        setNeedsStatusBarAppearanceUpdate()
        showNavigationBar(animated: true)
        contentView.update(viewModel: viewModel)
    }

    func displayRouteToEnterQRPassword(viewModel: EnterPasswordAfterQRFlow.RoutePayload.ViewModel) {
        router?.routeToEnterQRPassword()
    }
    
//    func displayWaitIndicator(viewModel: EnterPasswordAfterQRFlow.OnWaitIndicator.ViewModel) {
//        contentView.displayWaitIndicator(viewModel: viewModel)
//    }
//
//    func displayAlert(viewModel: EnterPasswordAfterQRFlow.AlertInfo.ViewModel) {
//        showAlert(title: viewModel.title,
//                  message: viewModel.text,
//                  firstButtonTitle: viewModel.buttonTitle ?? "Ok")
//    }
}

// MARK: - EnterPasswordAfterQRViewOutput

extension EnterPasswordAfterQRController: EnterPasswordAfterQRViewOutput {

    func onChangeText(_ viewModel: TextCellWithTitleAtBorderViewModel, currentText: String) {
        interactor?.changeInputText(
            request: EnterPasswordAfterQRFlow.OnSelectItem.Request(
                id: viewModel.id,
                selectedString: currentText)
        )
    }

    func didTapAt(_ viewModel: NextStepButtonCellViewModel) {
        interactor?.onSelectItem(
            request: EnterPasswordAfterQRFlow.OnSelectItem.Request(
                id: viewModel.id,
                selectedString: nil)
        )
    }
}



