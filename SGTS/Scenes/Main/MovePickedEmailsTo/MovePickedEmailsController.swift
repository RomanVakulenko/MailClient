//
//  MovePickedEmailsController.swift
//  SGTS
//
//  Created by Roman Vakulenko on 24.05.2024.
//

import UIKit
import SnapKit

protocol MovePickedEmailsDisplayLogic: AnyObject {
    func displayUpdate(viewModel: MovePickedEmailsFlow.Update.ViewModel)
    //    func displayWaitIndicator(viewModel: MovePickedEmailsFlow.OnWaitIndicator.ViewModel)
    //    func displayAlert(viewModel: MovePickedEmailsFlow.AlertInfo.ViewModel)
    func displayRouteBackToEmailPickingScreen(viewModel: MovePickedEmailsFlow.RoutePayload.ViewModel)
}

final class MovePickedEmailsController: UIViewController, FileShareable, AlertDisplayable, NavigationBarControllable {

//    enum Constants {
//    }

    var interactor: MovePickedEmailsBusinessLogic?
    var router: (MovePickedEmailsRoutingLogic & MovePickedEmailsDataPassing)?
    
    lazy var contentView: MovePickedEmailsViewLogic = MovePickedEmailsView()

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
        interactor?.onDidLoadViews(request: MovePickedEmailsFlow.OnDidLoadViews.Request())
    }


    // MARK: - Private methods
    private func configure() {
        addSubviews()
        configureConstraints()
    }

    private func addSubviews() { }

    private func configureConstraints() { }
}

// MARK: - MovePickedEmailsDisplayLogic

extension MovePickedEmailsController: MovePickedEmailsDisplayLogic {

//    func displayRouteToMovePickedEmails(viewModel: MovePickedEmailsFlow.OnLongPressGestureTap.ViewModel) {
//        router?.routeToMovePickedEmails(viewModel: MovePickedEmailsFlow.OnLongPressGestureTap.ViewModel(selectedEmailIds: viewModel.selectedEmailIds))
//    }

    func displayUpdate(viewModel: MovePickedEmailsFlow.Update.ViewModel) {
        setNeedsStatusBarAppearanceUpdate()
        contentView.update(viewModel: viewModel)

    }

    func displayRouteBackToEmailPickingScreen(viewModel: MovePickedEmailsFlow.RoutePayload.ViewModel) {
        router?.routeBackToEmailPickingScreen(from: self)
    }


//    func displayRouteToMailStartScreen(viewModel: MovePickedEmailsFlow.RoutePayload.ViewModel) {
//        router?.routeToMailStartScreen(viewModel: MovePickedEmailsFlow.RoutePayload.ViewModel())
//    }
    
//    func displayWaitIndicator(viewModel: MovePickedEmailsFlow.OnWaitIndicator.ViewModel) {
//        contentView.displayWaitIndicator(viewModel: viewModel)
//    }
//
//    func displayAlert(viewModel: MovePickedEmailsFlow.AlertInfo.ViewModel) {
//        showAlert(title: viewModel.title,
//                  message: viewModel.text,
//                  firstButtonTitle: viewModel.buttonTitle ?? "Ok")
//    }

}

// MARK: - MovePickedEmailsViewOutput

extension MovePickedEmailsController: MovePickedEmailsViewOutput {
    func didTapAtAlreadySent() {
        interactor?.didTapAtAlreadySent(request: MovePickedEmailsFlow.RoutePayload.Request())
    }

    func didTapToDraft() {
        interactor?.didTapToDraft(request: MovePickedEmailsFlow.RoutePayload.Request())
    }

    func didTapToArchive() {
        interactor?.didTapToArchive(request: MovePickedEmailsFlow.RoutePayload.Request())
    }

    func didTapToDeleted() {
        interactor?.didTapToDeleted(request: MovePickedEmailsFlow.RoutePayload.Request())
    }

    func didTapCancel() {
        interactor?.didTapCancel(request: MovePickedEmailsFlow.RoutePayload.Request())        
    }
}


