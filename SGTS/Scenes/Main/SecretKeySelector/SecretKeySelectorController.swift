//
//  SecretKeySelectorController.swift
//  SGTS
//
//  Created by Roman Vakulenko on 12.04.2024.
//

import UIKit
import SnapKit

protocol SecretKeySelectorDisplayLogic: AnyObject {
    func displayUpdate(viewModel: SecretKeySelectorFlow.Update.ViewModel)
    func displayWaitIndicator(viewModel: SecretKeySelectorFlow.OnWaitIndicator.ViewModel)
    func displayAlert(viewModel: SecretKeySelectorFlow.AlertInfo.ViewModel)
    func displayFileDialog(viewModel: SecretKeySelectorFlow.OnBrowseButton.ViewModel)
    func displayRouteToSetPincodeScreen(viewModel: SecretKeySelectorFlow.RoutePayload.ViewModel)
    func displayRouteToBrowserAuth(viewModel: SecretKeySelectorFlow.RoutePayload.ViewModel)
}

final class SecretKeySelectorController: UIViewController, NavigationBarControllable, FileShareable, AlertDisplayable {
    
    var interactor: SecretKeySelectorBusinessLogic?
    var router: (SecretKeySelectorRoutingLogic & SecretKeySelectorDataPassing)?
    
    lazy var contentView: SecretKeySelectorViewLogic = SecretKeySelectorView()

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
        interactor?.onDidLoadViews(request: SecretKeySelectorFlow.OnDidLoadViews.Request())
    }
    
    func leftNavBarButtonDidTapped() {
        self.navigationController?.popViewController(animated: true)
    }

    func rightNavBarButtonTapped(index: Int) {
        switch index {
        case 0:
          () //routeTo "QR код сканирование"
        default: return
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

// MARK: - SecretKeySelectorDisplayLogic

extension SecretKeySelectorController: SecretKeySelectorDisplayLogic {
    func displayRouteToBrowserAuth(viewModel: SecretKeySelectorFlow.RoutePayload.ViewModel) {
        router?.routeToBrowserAuth(completion: { [weak self] result in
            switch result {
            case .success(_):
                print("Success")
            case .failure(let error):
                self?.interactor?.onBrowserAuthError(request: SecretKeySelectorFlow.OnBrowserAuthError.Request(error: error))
            }
        })
    }
    
    func displayFileDialog(viewModel: SecretKeySelectorFlow.OnBrowseButton.ViewModel) {
        router?.routeToDialog()
    }

    func displayUpdate(viewModel: SecretKeySelectorFlow.Update.ViewModel) {
        configureNavigationBar(navBar: viewModel.navBar)
        setNeedsStatusBarAppearanceUpdate()
        showNavigationBar(animated: true)
        contentView.update(viewModel: viewModel)
    }

    func displayRouteToSetPincodeScreen(viewModel: SecretKeySelectorFlow.RoutePayload.ViewModel) {
        router?.routeToSetPincodeScreen()
    }
    
    func displayWaitIndicator(viewModel: SecretKeySelectorFlow.OnWaitIndicator.ViewModel) {
        contentView.displayWaitIndicator(viewModel: viewModel)
    }

    func displayAlert(viewModel: SecretKeySelectorFlow.AlertInfo.ViewModel) {
        showAlert(title: viewModel.title,
                  message: viewModel.text,
                  firstButtonTitle: viewModel.buttonTitle ?? "Ok")
    }
}

// MARK: - SecretKeySelectorViewOutput

extension SecretKeySelectorController: SecretKeySelectorViewOutput {

    func didTapAt(_ viewModel: BrowseButtonCellViewModel) {
        interactor?.onSelectItem(request: SecretKeySelectorFlow.OnSelectItem.Request(
            id: viewModel.id,
            selectedString: nil)
        )
    }

    func didTapAt(_ viewModel: CloudKeyCellViewModel) {
        interactor?.onSelectItem(
            request: SecretKeySelectorFlow.OnSelectItem.Request(
                id: viewModel.id,
                selectedString: nil)
        )
    }


    func onChangeText(_ viewModel: TextCellWithTitleAtBorderViewModel, currentText: String) {
        interactor?.changeInputText(
            request: SecretKeySelectorFlow.OnSelectItem.Request(
                id: viewModel.id,
                selectedString: currentText)
        )
    }

    func didTapAt(_ viewModel: NextStepButtonCellViewModel) {
        interactor?.onSelectItem(
            request: SecretKeySelectorFlow.OnSelectItem.Request(
                id: viewModel.id,
                selectedString: nil)
        )
    }
}


// MARK: - UIDocumentPickerDelegate
extension SecretKeySelectorController: UIDocumentPickerDelegate {

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        // Обработка выбранного файла
        Log.i("Выбран файл: \(url)")
        interactor?.didChooseFileWith(url: url)
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        Log.i("Выбор файла отменен")
    }
}
