//
//  ImageFullScreenController.swift
//  SGTS
//
//  Created by Roman Vakulenko on 22.04.2024.
//

import UIKit
import SnapKit

protocol ImageFullScreenDisplayLogic: AnyObject {
    func displayUpdate(viewModel: ImageFullScreenFlow.Update.ViewModel)
    func displayDropdownMenuAtNavBarIcon(viewModel: ImageFullScreenFlow.OnDropdownMenu.ViewModel)

    func displayWaitIndicator(viewModel: ImageFullScreenFlow.OnWaitIndicator.ViewModel)
    func displayAlert(viewModel: ImageFullScreenFlow.AlertInfo.ViewModel)

    func displayRouteToSaveDialog(viewModel: ImageFullScreenFlow.RoutePayload.ViewModel)
    func displayRouteToFullScreenImage(viewModel: ImageFullScreenFlow.RoutePayload.ViewModel)
    func displayRouteBack(viewModel: ImageFullScreenFlow.RoutePayload.ViewModel)
    func displayRouteToOpenImageInOtherApp(viewModel: ImageFullScreenFlow.RoutePayload.ViewModel)
}


// MARK: - ImageFullScreenController

final class ImageFullScreenController: UIViewController, NavigationBarControllable, FileShareable, AlertDisplayable {
    
    var interactor: ImageFullScreenBusinessLogic?
    var router: (ImageFullScreenRoutingLogic & ImageFullScreenDataPassing)?
    
    private lazy var contentView: ImageFullScreenViewLogic = ImageFullScreenView()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.shared.isLight ? .darkContent : .lightContent
    }

    // MARK: - Lifecycle

    override func loadView() {
        contentView.output = self
        view = contentView
        hideNavigationBar(animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        interactor?.passImageToPresent(request: ImageFullScreenFlow.OnDidLoadViews.Request())
    }

    // MARK: - Private methods
    private func configure() {
        addSubviews()
        configureConstraints()
    }

    private func addSubviews() { }

    private func configureConstraints() { }
}

// MARK: - ImageFullScreenDisplayLogic

extension ImageFullScreenController: ImageFullScreenDisplayLogic {

    func displayRouteBack(viewModel: ImageFullScreenFlow.RoutePayload.ViewModel) {
        router?.routeBack()
    }

    func displayRouteToSaveDialog(viewModel: ImageFullScreenFlow.RoutePayload.ViewModel) {
        router?.routeToSaveDialog()
    }

    func displayRouteToOpenImageInOtherApp(viewModel: ImageFullScreenFlow.RoutePayload.ViewModel) {
        router?.openImageInOtherApp()
    }

    func displayUpdate(viewModel: ImageFullScreenFlow.Update.ViewModel) {
        setNeedsStatusBarAppearanceUpdate()
        contentView.update(viewModel: viewModel)
    }

    func displayDropdownMenuAtNavBarIcon(viewModel: ImageFullScreenFlow.OnDropdownMenu.ViewModel) {
        contentView.displayThreeDotsDropdownMenu(viewModel: viewModel)
    }

    func displayRouteToFullScreenImage(viewModel: ImageFullScreenFlow.RoutePayload.ViewModel) {
        router?.routeToOpenImage()
    }
    
    func displayWaitIndicator(viewModel: ImageFullScreenFlow.OnWaitIndicator.ViewModel) {
        contentView.displayWaitIndicator(viewModel: viewModel)
    }

    func displayAlert(viewModel: ImageFullScreenFlow.AlertInfo.ViewModel) {
        showAlert(title: viewModel.title,
                  message: viewModel.text,
                  firstButtonTitle: viewModel.buttonTitle ?? "Ok")
    }
}

// MARK: - ImageFullScreenViewOutput
extension ImageFullScreenController: ImageFullScreenViewOutput {

    func didTapBackArrow() {
        interactor?.didTapBackArrow()
    }

    func didTapThreeDotsIcon() {
        interactor?.didTapThreeDotsIcon(request: ImageFullScreenFlow.OnDropdownMenu.Request(dropDownMenuTitleCases: [.downloadFoto, .openImageInOtherApp]))
    }

    func didTapSomeDropdownMenuTitle(titleViewModel: ImageFullScreenModel.oneTitleOfDropdownMenu) {
        interactor?.didTapSomeDropdownMenuTitle(request: ImageFullScreenFlow.OnDropdownMenuTitle.Request(enumCase: titleViewModel.enumCaseOfDropdownMenu))
    }
}
