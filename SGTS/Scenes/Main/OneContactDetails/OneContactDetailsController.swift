//
//  OneContactDetailsController.swift
//  SGTS
//
//  Created by Roman Vakulenko on 31.07.2024.
//


import UIKit
import SnapKit

protocol OneContactDetailsDisplayLogic: AnyObject {
    func displayUpdate(viewModel: OneContactDetailsFlow.Update.ViewModel)
//    func displayWaitIndicator(viewModel: OneContactDetailsFlow.OnWaitIndicator.ViewModel)
    func displayAlert(viewModel: OneContactDetailsFlow.AlertInfo.ViewModel)
    func displayRouteBackToAddressBook(viewModel: OneContactDetailsFlow.RoutePayload.ViewModel)
    func displayRouteToCallNumber(viewModel: OneContactDetailsFlow.RoutePayload.ViewModel)
}

final class OneContactDetailsController: UIViewController, NavigationBarControllable, FileShareable, AlertDisplayable {

    var interactor: OneContactDetailsBusinessLogic?
    var router: (OneContactDetailsRoutingLogic & OneContactDetailsDataPassing)?

    lazy var contentView: OneContactDetailsViewLogic = OneContactDetailsView()
    weak var delegate: OneContactDetailsDelegate?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.shared.isLight ? .darkContent : .lightContent
    }

    // MARK: - Lifecycle

    init(delegate: OneContactDetailsDelegate?) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        hideNavigationBar(animated: false)
        interactor?.onDidLoadViews(request: OneContactDetailsFlow.OnDidLoadViews.Request())
    }

    func leftNavBarButtonDidTapped() {
        navigationController?.popViewController(animated: false)
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
// MARK: - OneContactDetailsDisplayLogic
extension OneContactDetailsController: OneContactDetailsDisplayLogic {

    func displayRouteBackToAddressBook(viewModel: OneContactDetailsFlow.RoutePayload.ViewModel) {
        router?.routeBackToAddressBook(viewModel: viewModel)
    }
    
    func displayRouteToCallNumber(viewModel: OneContactDetailsFlow.RoutePayload.ViewModel) {
        router?.callNumber()
    }

    func displayUpdate(viewModel: OneContactDetailsFlow.Update.ViewModel) {
        configureNavigationBar(navBar: viewModel.navBar)
        setNeedsStatusBarAppearanceUpdate()
        showNavigationBar(animated: false)
        contentView.update(viewModel: viewModel)
    }

//    func displayWaitIndicator(viewModel: OneContactDetailsFlow.OnWaitIndicator.ViewModel) {
//        contentView.displayWaitIndicator(viewModel: viewModel)
//    }

    func displayAlert(viewModel: OneContactDetailsFlow.AlertInfo.ViewModel) {
        showAlert(title: viewModel.title,
                  message: viewModel.text,
                  firstButtonTitle: viewModel.buttonTitle ?? "Ok")
    }
}

 // MARK: - OneContactDetailsViewOutput

extension OneContactDetailsController: OneContactDetailsViewOutput {

    func didTapAtEmailAddress() {
        interactor?.didTapAtEmailAddress(request: OneContactDetailsFlow.OnTapEmailAddress.Request())
    }
    
    func didTapAtPhone() {
        interactor?.didTapAtPhone(request: OneContactDetailsFlow.OnTapPhone.Request())
    }

}



