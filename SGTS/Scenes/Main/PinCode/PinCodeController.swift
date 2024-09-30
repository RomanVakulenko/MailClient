//
//  PinCodeController.swift
//  SGTS
//
//  Created by Roman Vakulenko on 04.04.2024.
//

import UIKit
import SnapKit
import Vision
import AVFoundation

protocol PinCodeDisplayLogic: AnyObject {
    func displayUpdate(viewModel: PinCodeFlow.Update.ViewModel)
    //    func displayWaitIndicator(viewModel: PinCodeFlow.OnWaitIndicator.ViewModel)
    func displayAlert(viewModel: PinCodeFlow.AlertInfo.ViewModel)
    func displayRouteToNextScreen(viewModel: PinCodeFlow.RoutePayload.ViewModel)
    func checkUserPermissionAndDetectFace(viewModel: PinCodeFlow.RoutePayload.ViewModel)
}

final class PinCodeController: UIViewController, NavigationBarControllable, FileShareable, AlertDisplayable {
    
    var interactor: PinCodeBusinessLogic?
    var router: (PinCodeRoutingLogic & PinCodeDataPassing)?
    
    lazy var contentView: PinCodeViewLogic = PinCodeView()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.shared.isLight ? .darkContent : .lightContent
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        interactor?.onDidLoadViews(request: PinCodeFlow.OnDidLoadViews.Request())
    }

    func leftNavBarButtonDidTapped() {
        self.navigationController?.popViewController(animated: true)
    }

    func rightNavBarButtonTapped(index: Int) { }


    // MARK: - Actions

    // MARK: - Private methods

    private func configure() {
        contentView.output = self
        addSubviews()
        configureConstraints()
    }
    
    private func addSubviews() {}
    
    private func configureConstraints() {}

    private func handleFaceDetection(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNFaceObservation] else {
            fatalError("Unexpected result type from VNFaceObservation")
        }

        for face in observations {
            // Handle the detected face here
            print(face.boundingBox)
        }
    }

    private func startFaceDetection(viewModel: PinCodeFlow.RoutePayload.ViewModel) {
        let faceIDRequest = VNDetectFaceRectanglesRequest(completionHandler: handleFaceDetection)
        let requestHandler = VNImageRequestHandler(cgImage: UIImage(named: "yourImage.jpg")!.cgImage!, options: [:])
        do {
            try requestHandler.perform([faceIDRequest])
        } catch {
            Log.i("Error at detecting face: \(error)")
            interactor?.accessDeinedOrRestricted(
                request: PinCodeFlow.AlertInfo.Request(error: .errorAtFaceDetection))
        }

    }
}

// MARK: - PinCodeDisplayLogic

extension PinCodeController: PinCodeDisplayLogic {

    func displayAlert(viewModel: PinCodeFlow.AlertInfo.ViewModel) {
        showAlert(title: viewModel.title,
                  message: viewModel.text,
                  firstButtonTitle: viewModel.buttonTitle ?? "Ok")
    }

    func checkUserPermissionAndDetectFace(viewModel: PinCodeFlow.RoutePayload.ViewModel) {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)

        switch cameraAuthorizationStatus {
        case .authorized:
            startFaceDetection(viewModel: viewModel)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    self?.startFaceDetection(viewModel: viewModel)
                } else {
                    Log.i("Camera access denied")
                    self?.interactor?.accessDeinedOrRestricted(
                        request: PinCodeFlow.AlertInfo.Request(error: .cameraAccessDenied)) //(errorText: "Доступ к камере запрещен"))
                }
            }
        case .denied, .restricted:
            Log.i("Camera access denied or restricted")
            interactor?.accessDeinedOrRestricted(
                request: PinCodeFlow.AlertInfo.Request(error: .cameraAccessDeniedOrRestricted))
        @unknown default:
            break
        }
    }

    func displayUpdate(viewModel: PinCodeFlow.Update.ViewModel) {
        configureNavigationBar(navBar: viewModel.navBar)
        setNeedsStatusBarAppearanceUpdate()
        showNavigationBar(animated: true)
        contentView.update(viewModel: viewModel)
    }
    
    //    func displayWaitIndicator(viewModel: PinCodeFlow.OnWaitIndicator.ViewModel) {
    //        contentView.displayWaitIndicator(viewModel: viewModel)
    //    }
    //
    //    func displayAlert(viewModel: PinCodeFlow.AlertInfo.ViewModel) {
    //        showAlert(title: viewModel.title,
    //                  message: viewModel.text,
    //                  firstButtonTitle: viewModel.buttonTitle ?? "Ok")
    //    }

    func displayRouteToNextScreen(viewModel: PinCodeFlow.RoutePayload.ViewModel) {
        router?.routeToNextScreen()
    }
}

// MARK: - PinCodeViewOutput

extension PinCodeController: PinCodeViewOutput {

    func didTapDigit(digit: Int) {
        interactor?.didTapDigit(digit: digit)
    }

    func didTapBackspace() {
        interactor?.didTapBackspace()
    }

    func didTapFaceID() {
        interactor?.didTapFaceID(request: PinCodeFlow.OnFaceDetection.Request())
    }

}

