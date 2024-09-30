//
//  MailStartScreenController.swift
//  SGTS
//
//  Created by Roman Vakulenko on 17.04.2024.
//

import UIKit
import SnapKit

protocol MailStartScreenDisplayLogic: AnyObject {
    func displayUpdate(viewModel: MailStartScreenFlow.Update.ViewModel)
//    func displayRouteToEmailPickingScreen(viewModel: MailStartScreenFlow.OnSelectItem.ViewModel)
    func displayWaitIndicator(viewModel: MailStartScreenFlow.OnWaitIndicator.ViewModel)
    func displayAlert(viewModel: MailStartScreenFlow.AlertInfo.ViewModel)
    func displayRouteToEmailPickingScreen(viewModel: MailStartScreenFlow.OnLongPressGestureTap.ViewModel)

    func displayRouteToOneEmailDetailsScreen(viewModel: MailStartScreenFlow.OnSelectItem.ViewModel)
    func displayRouteToNewEmailCreate(viewModel: MailStartScreenFlow.RoutePayload.ViewModel)
    func displayRouteToSideMenu(viewModel: MailStartScreenFlow.RoutePayload.ViewModel)
}

final class MailStartScreenController: UIViewController, FileShareable, AlertDisplayable, NavigationBarControllable {
    
    var interactor: MailStartScreenBusinessLogic?
    var router: (MailStartScreenRoutingLogic & MailStartScreenDataPassing)?
    
    lazy var contentView: MailStartScreenViewLogic = MailStartScreenView()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.shared.isLight ? .darkContent : .lightContent
    }

    // MARK: - Private methods
    private var messageType: TabBarManager.MessageType
    private var didTabBarSet = false

    // MARK: - Lifecycle

   init(messageType: TabBarManager.MessageType) {
        self.messageType = messageType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        contentView.output = self
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        interactor?.onDidLoadViews(request: MailStartScreenFlow.OnDidLoadViews.Request())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar(animated: false)
        guard let navigationController = self.navigationController else { return }
        TabBarManager.showAndEnableTabBarFor(navController: navigationController)
        
        interactor?.updateMailListWithReceiveNewMail(request: MailStartScreenFlow.Update.Request())
    }

    func leftNavBarButtonDidTapped() {
        interactor?.didTapSideMenuBarButton(request: MailStartScreenFlow.OnBarButtonTap.Request())
    }

    func rightNavBarButtonTapped(index: Int) {
        switch index {
        case 0:
            interactor?.didTapCreateNewEmailBarButton(request: MailStartScreenFlow.OnBarButtonTap.Request())
        case 1:
            ()// Действие для второй кнопки
        default:
            break
        }
    }


    // MARK: - Private methods
    private func configure() {
        addSubviews()
        configureConstraints()
    }

    private func addSubviews() { }

    private func configureConstraints() { }
    
}

// MARK: - MailStartScreenDisplayLogic

extension MailStartScreenController: MailStartScreenDisplayLogic {

    func displayRouteToSideMenu(viewModel: MailStartScreenFlow.RoutePayload.ViewModel) {
        router?.routeToSideMenu()
    }

    func displayRouteToOneEmailDetailsScreen(viewModel: MailStartScreenFlow.OnSelectItem.ViewModel) {
        router?.routeToOneEmailDetailsScreen()
    }

    func displayRouteToEmailPickingScreen(viewModel: MailStartScreenFlow.OnLongPressGestureTap.ViewModel) {
        router?.routeToEmailPickingScreen()
    }
    
    func displayUpdate(viewModel: MailStartScreenFlow.Update.ViewModel) {
        configureNavigationBar(navBar: viewModel.navBar)
        setNeedsStatusBarAppearanceUpdate()
        showNavigationBar(animated: false)
        
        if !didTabBarSet,
           let navController = self.navigationController {
            TabBarManager.configureTabBarItem(for: navController,
                                              title: viewModel.tabBarTitle,
                                              image: viewModel.tabBarImage,
                                              selectedImage: viewModel.tabBarSelectedImage)
            didTabBarSet = true
        }
        contentView.update(viewModel: viewModel)
    }

    func displayRouteToNewEmailCreate(viewModel: MailStartScreenFlow.RoutePayload.ViewModel) {
        router?.routeToNewEmailCreate(emailType: .newEmail)
    }

    func displayWaitIndicator(viewModel: MailStartScreenFlow.OnWaitIndicator.ViewModel) {
        contentView.displayWaitIndicator(viewModel: viewModel)
    }

    func displayAlert(viewModel: MailStartScreenFlow.AlertInfo.ViewModel) {
        showAlert(title: viewModel.title,
                  message: viewModel.text,
                  firstButtonTitle: viewModel.buttonTitle ?? "Ok")
    }
}

// MARK: - MailStartScreenViewOutput

extension MailStartScreenController: MailStartScreenViewOutput {
    func didPullToReftesh() {
        interactor?.updateMailListWithReceiveNewMail(request: MailStartScreenFlow.Update.Request())
    }
    
    func bottomCellHasBeenDisplayed() {
        interactor?.checkIfAllMailsFetched(request: MailStartScreenFlow.Update.Request())
    }


    func didTapAtOneEmail(_ viewModel: EmailCellViewModel) {
        interactor?.onSelectItem(request: MailStartScreenFlow.OnSelectItem.Request(id: viewModel.id))
    }

    func didLongPressAt(_ viewModel: EmailCellViewModel) {
        interactor?.didLongPressAtEmail(request: MailStartScreenFlow.OnLongPressGestureTap.Request(id: viewModel.id))
    }
}
