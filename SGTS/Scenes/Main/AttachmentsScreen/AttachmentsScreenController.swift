//
//  AttachmentsScreenController.swift
//  SGTS
//
//  Created by Roman Vakulenko on 12.06.2024.
//

import UIKit
import SnapKit

protocol AttachmentsScreenDisplayLogic: AnyObject {
    func toggleSearchBar(viewModel: AttachmentsScreenFlow.OnSearchBarIconTap.ViewModel)

    func displayUpdate(viewModel: AttachmentsScreenFlow.Update.ViewModel)
    func displayWaitIndicator(viewModel: AttachmentsScreenFlow.OnWaitIndicator.ViewModel)
    func displayAlert(viewModel: AttachmentsScreenFlow.AlertInfo.ViewModel)
    func displayRouteToSideMenu(viewModel: AttachmentsScreenFlow.RoutePayload.ViewModel)
    func displayRouteToOpenFileInOtherApp(viewModel: AttachmentsScreenFlow.OnSelectItem.ViewModel)

}

final class AttachmentsScreenController: UIViewController, FileShareable, AlertDisplayable, NavigationBarControllable {
    
    var interactor: AttachmentsScreenBusinessLogic?
    var router: (AttachmentsScreenRoutingLogic & AttachmentsScreenDataPassing)?
    
    lazy var contentView: AttachmentsScreenViewLogic = AttachmentsScreenView()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.shared.isLight ? .darkContent : .lightContent
    }

    // MARK: - Private methods
    private var isSearchBarDisplaying = false
    private var didTabBarSet = false

    // MARK: - Lifecycle

    override func loadView() {
        contentView.output = self
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        hideNavigationBar(animated: false)
        interactor?.onDidLoadViews(request: AttachmentsScreenFlow.OnDidLoadViews.Request())
    }

    override func viewWillDisappear(_ animated: Bool) {
        defer {
            if let urlOfCachedAttachments = interactor?.urlsOfDataForAttachmentsInCache {
                clearCacheUsing(urlsOfDataForAttachmentsInCache: urlOfCachedAttachments)
            }
        }
        super.viewWillDisappear(animated)
    }

    func leftNavBarButtonDidTapped() {
        interactor?.didTapSideMenuBarButton(request: AttachmentsScreenFlow.OnBurgerMenuTap.Request())
    }

    func rightNavBarButtonTapped(index: Int) {
        switch index {
        case 0:
            isSearchBarDisplaying.toggle()
            interactor?.didTapSearchBarIcon(request: AttachmentsScreenFlow.OnSearchBarIconTap.Request(
                searchText: nil,
                isSearchBarDisplaying: isSearchBarDisplaying))
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

    private func clearCacheUsing(urlsOfDataForAttachmentsInCache: [URL]) {
        let fileManager = FileManager.default
        for fileURL in urlsOfDataForAttachmentsInCache {
            do {
                try fileManager.removeItem(at: fileURL)
            } catch {
                Log.i("Error removing file from cache: \(error)")
            }
        }
    }
}

// MARK: - AttachmentsScreenDisplayLogic

extension AttachmentsScreenController: AttachmentsScreenDisplayLogic {

    func toggleSearchBar(viewModel: AttachmentsScreenFlow.OnSearchBarIconTap.ViewModel) {
        contentView.toggleSearchBar(viewModel: viewModel)
    }

    func displayRouteToOpenFileInOtherApp(viewModel: AttachmentsScreenFlow.OnSelectItem.ViewModel) {
        router?.openInOtherApp()
    }

    func displayRouteToSideMenu(viewModel: AttachmentsScreenFlow.RoutePayload.ViewModel) {
        router?.routeToSideMenu()
    }

    func displayUpdate(viewModel: AttachmentsScreenFlow.Update.ViewModel) {

        configureNavigationBar(navBar: viewModel.navBar)
        setNeedsStatusBarAppearanceUpdate()
        showNavigationBar(animated: true)
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


    func displayWaitIndicator(viewModel: AttachmentsScreenFlow.OnWaitIndicator.ViewModel) {
        contentView.displayWaitIndicator(viewModel: viewModel)
    }

    func displayAlert(viewModel: AttachmentsScreenFlow.AlertInfo.ViewModel) {
        showAlert(title: viewModel.title,
                  message: viewModel.text,
                  firstButtonTitle: viewModel.buttonTitle ?? "Ok")
    }
}

// MARK: - AttachmentsScreenViewOutput

extension AttachmentsScreenController: AttachmentsScreenViewOutput {
    func didTapAtSearchIconInSearchView(searchText: String) {
        interactor?.filterAttachmentsWithSearchText(request: AttachmentsScreenFlow.OnSearchBarIconTap.Request(
            searchText: searchText,
            isSearchBarDisplaying: isSearchBarDisplaying))
    }

    func didTapAttachmentCell(_ viewModel: AttachmentCellViewModel) {
        interactor?.onSelectItem(request: AttachmentsScreenFlow.OnSelectItem.Request(id: viewModel.id))
    }

    func bottomCellHasBeenDisplayed() {
        //        interactor?.checkIfAllMailsFetched(request: AttachmentsScreenFlow.Update.Request())
    }
}


