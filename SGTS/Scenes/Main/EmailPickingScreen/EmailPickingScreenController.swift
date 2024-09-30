//
//  EmailPickingScreenController.swift
//  SGTS
//
//  Created by Roman Vakulenko on 20.05.2024.
//

import UIKit
import SnapKit

protocol EmailPickingScreenDisplayLogic: AnyObject {
    func displayUpdate(viewModel: EmailPickingScreenFlow.Update.ViewModel)
    func displayWaitIndicator(viewModel: EmailPickingScreenFlow.OnWaitIndicator.ViewModel)
    func displayAlert(viewModel: EmailPickingScreenFlow.AlertInfo.ViewModel)
    func displayRouteToMailStartScreen(viewModel: EmailPickingScreenFlow.RoutePayload.ViewModel)
    func displayThreeDotsDropdownMenu(viewModel: EmailPickingScreenFlow.OnDropdownMenu.ViewModel)
    func displayRouteToMovePickedEmailsScreen(viewModel: EmailPickingScreenFlow.RoutePayload.ViewModel)
}

final class EmailPickingScreenController: UIViewController, FileShareable, AlertDisplayable, NavigationBarControllable {

    var interactor: EmailPickingScreenBusinessLogic?
    var router: (EmailPickingScreenRoutingLogic & EmailPickingScreenDataPassing)?
    
    lazy var contentView: EmailPickingScreenViewLogic = EmailPickingScreenView()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.shared.isLight ? .darkContent : .lightContent
    }


    // MARK: - Private methods
    private var didTabBarSet = false

    // MARK: - Lifecycle
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func loadView() {
        contentView.output = self
        view = contentView
        hideNavigationBar(animated: false) //to hide flashing blue "< Back"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        interactor?.onDidLoadViews(request: EmailPickingScreenFlow.OnDidLoadViews.Request())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navigationController = self.navigationController else { return }
        TabBarManager.showAndEnableTabBarFor(navController: navigationController)

// В MailStartScreen это было нужно, чтобы срабатывал didPullToReftesh() и при возврате на экран
//        interactor?.updateMailListWithReceiveNewMail(request: MailStartScreenFlow.Update.Request())
    }


    // MARK: - Private methods
    private func configure() {
        addSubviews()
        configureConstraints()
    }

    private func addSubviews() { }

    private func configureConstraints() { }
}

// MARK: - EmailPickingScreenDisplayLogic

extension EmailPickingScreenController: EmailPickingScreenDisplayLogic {

    func displayUpdate(viewModel: EmailPickingScreenFlow.Update.ViewModel) {
        setNeedsStatusBarAppearanceUpdate()
        if !didTabBarSet,
           let navController = self.navigationController {
            TabBarManager.configureTabBarItem(for: navController,
                                              title: viewModel.tabBarTitle,
                                              image: viewModel.tabBarImage,
                                              selectedImage: viewModel.tabBarSelectedImage)
            didTabBarSet = true
        }
        hideNavigationBar(animated: false) //to hide it
        contentView.update(viewModel: viewModel)
    }

    func displayRouteToMovePickedEmailsScreen(viewModel: EmailPickingScreenFlow.RoutePayload.ViewModel) {
        router?.routeToMovePickedEmailsScreen()
    }

    func displayRouteToMailStartScreen(viewModel: EmailPickingScreenFlow.RoutePayload.ViewModel) {
        router?.routeToMailStartScreen()
    }
    
    func displayWaitIndicator(viewModel: EmailPickingScreenFlow.OnWaitIndicator.ViewModel) {
        contentView.displayWaitIndicator(viewModel: viewModel)
    }

    func displayAlert(viewModel: EmailPickingScreenFlow.AlertInfo.ViewModel) {
        showAlert(title: viewModel.title,
                  message: viewModel.text,
                  firstButtonTitle: viewModel.firstButtonTitle ?? "Ok",
                  secondButtonTitle: viewModel.secondButtonTitle ?? "Cancel",
                  firstButtonCompletion: { [weak self] in
            guard let self = self else { return }

            if viewModel.text == getString(.doYouWantToDelete) {
                interactor?.transferEmails(request: EmailPickingScreenFlow.MovingTo.Request(folder: GlobalConstants.deletedEmails)) //fixes getting meail and deletion
            } else if viewModel.text == getString(.doYouWantToArchive) {
                interactor?.transferEmails(request: EmailPickingScreenFlow.MovingTo.Request(folder: GlobalConstants.archivedEmails)) //fixes getting meail and deletion
            } else {
                router?.routeToMailStartScreen()
            }
        },
                  secondButtonCompletion: { [weak self] in
            guard let self = self else { return }
            router?.routeToMailStartScreen()
        })
    }

    func displayThreeDotsDropdownMenu(viewModel: EmailPickingScreenFlow.OnDropdownMenu.ViewModel) {
        contentView.displayThreeDotsDropdownMenu(viewModel: viewModel)
    }
}

// MARK: - EmailPickingScreenViewOutput

extension EmailPickingScreenController: EmailPickingScreenViewOutput {
    func didTapBackArrow() {
        interactor?.didTapBackArrow()
    }

    func didTapThreeDotsDropDownMenuAt(oneTitleViewModel: EmailPickingScreenModel.oneTitleOfDropdownMenu) {
        interactor?.didTapTitleOfThreeDotsDropdownMenu(request: EmailPickingScreenFlow.OnDropdownMenuTitle.Request(enumCase: oneTitleViewModel.enumCaseOfDropdownMenu))
    }

    func didLongPressAt(_ viewModel: EmailCellViewModel) {}

    func didTapArchiveNavBarIcon() {
        interactor?.didTapTrashOrArchiveNavBarIcon(request: EmailPickingScreenFlow.MovingTo.Request(folder: GlobalConstants.archivedEmails))
    }

    func didTapTrashNavBarIcon() {
        interactor?.didTapTrashOrArchiveNavBarIcon(request: EmailPickingScreenFlow.MovingTo.Request(folder: GlobalConstants.deletedEmails))
    }

    func didTapUnreadNavBarIcon() {
        interactor?.markAsUnread(request: EmailPickingScreenFlow.OnEnvelopNavBarButton.Request())
    }

    func didTapThreeDotsNavBarIcon() {
        interactor?.didTapThreeDotsNavBarIcon(request: EmailPickingScreenFlow.OnDropdownMenu.Request())
    }

    func didTapPickAllBox() {
        interactor?.didTapPickAllBox(request: EmailPickingScreenFlow.Update.Request())
    }

    func didTapAtOneEmail(_ viewModel: EmailCellViewModel) {
        interactor?.onSelectItem(request: EmailPickingScreenFlow.OnSelectItem.Request(pickedEmailId: viewModel.id))
    }
}


