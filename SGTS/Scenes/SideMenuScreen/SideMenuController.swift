//
//  SideMenuController.swift
//  SGTS
//
//  Created by Roman Vakulenko on 03.07.2024.
//

import UIKit
import SnapKit

protocol SideMenuDisplayLogic: AnyObject {
    func displayUpdate(viewModel: SideMenuFlow.Update.ViewModel)
//    func displayUpdateIncoming(viewModel: SideMenuFlow.UpdateIncomingAmount.ItemViewModel)
//    func displayWaitIndicator(viewModel: SideMenuFlow.OnWaitIndicator.ViewModel)
    func displayAlert(viewModel: SideMenuFlow.AlertInfo.ViewModel)
//    func displayRouteToAddressBookScreen(viewModel: SideMenuFlow.RoutePayload.ViewModel)

    func displayRouteBack(viewModel: SideMenuFlow.RoutePayload.ViewModel)
    func displayRouteToSelectedScreen(viewModel: SideMenuFlow.RoutePayload.ViewModel)
}

final class SideMenuController: UIViewController, FileShareable, AlertDisplayable {

    var interactor: SideMenuBusinessLogic?
    var router: (SideMenuRoutingLogic & SideMenuDataPassing)?

    lazy var contentView: SideMenuViewLogic = SideMenuView()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.shared.isLight ? .darkContent : .lightContent
    }

    // MARK: - Private properties
    private var interactiveAnimate: UIViewPropertyAnimator!
    private var flag = false

    // MARK: - Lifecycle

    override func loadView() {
        contentView.output = self
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        interactor?.onDidLoadViews(request: SideMenuFlow.OnDidLoadViews.Request())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)

        contentView.tableView.layer.add(transition, forKey: kCATransition)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_ :)))
//        view.addGestureRecognizer(pan)

        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft(_:)))
        swipeLeftGesture.direction = .left
        view.addGestureRecognizer(swipeLeftGesture)
    }

    // MARK: - Actions
    @objc func handleSwipeLeft(_ gesture: UISwipeGestureRecognizer) {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: []) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25) {
                self.contentView.grayView.backgroundColor = .none
            }
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
                self.view.frame = CGRect(x: -self.view.bounds.width,
                                         y: 0,
                                         width: self.view.bounds.width,
                                         height: self.view.bounds.height)
            }
        } completion: { _ in
            self.interactor?.swipedOrTappedAtGrayViewForClose(request: SideMenuFlow.RoutePayload.Request())
        }
    }

//    @objc func onPan(_ recognizer: UIPanGestureRecognizer) {
//        switch recognizer.state {
//        case.began:
//            interactiveAnimate = UIViewPropertyAnimator(duration: 0.5,
//                                                        curve: .linear,
//                                                        animations: {[weak self] in
//                self?.contentView.tableView.transform = CGAffineTransform.init(translationX: -UIScreen.main.bounds.width, y: 0)
//            })
//            interactiveAnimate.pauseAnimation()
//
//        case.changed:
//            let translation = recognizer.translation(in: contentView.tableView)
//            if translation.x < 0 && flag == false {
//                flag = true
//                interactiveAnimate.stopAnimation(true) // останавливаем without finishing
//            }
//            if translation.x < 0 && flag == true {
//                interactiveAnimate.fractionComplete = (-translation.x)/UIScreen.main.bounds.width
//            }
//
//        case.ended:
//            interactiveAnimate.continueAnimation(withTimingParameters: nil, durationFactor: 0)
//            interactiveAnimate.addCompletion({ [weak self] _ in
//                self?.interactor?.swipedForClose(request: SideMenuFlow.RoutePayload.Request())
//            })
//        default: return
//        }
//    }

    // MARK: - Private methods

    //    private func onChange(isLeft: Bool) {
    //        self.mainImageView.transform = .identity
    //        self.secondaryImageView.transform = .identity
    //        self.mainImageView.image = images[currentIndex]
    //
    //        if isLeft {
    //            self.secondaryImageView.image = images[self.currentIndex + 1]
    //            self.secondaryImageView.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
    //        } else {
    //            self.secondaryImageView.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
    //            self.secondaryImageView.image = images[currentIndex - 1]
    //        }
    //    }
    //
    //    private func onChangeCompletion(isLeft: Bool) {
    //        self.mainImageView.transform = .identity
    //        self.secondaryImageView.transform = .identity
    //        if isLeft {
    //            self.currentIndex += 1
    //        } else {
    //            self.currentIndex -= 1
    //        }
    //        self.mainImageView.image = self.images[self.currentIndex]
    //        self.bringSubviewToFront(self.mainImageView)
    //        self.customPageView.currentPage = self.currentIndex
    //    }

    private func configure() {
        addSubviews()
        configureConstraints()
    }

    private func addSubviews() { }

    private func configureConstraints() { }
}

// MARK: - SideMenuDisplayLogic

extension SideMenuController: SideMenuDisplayLogic {


    func displayUpdate(viewModel: SideMenuFlow.Update.ViewModel) {
        setNeedsStatusBarAppearanceUpdate()
        contentView.update(viewModel: viewModel)
    }

//    func displayUpdateIncoming(viewModel: SideMenuFlow.UpdateIncomingAmount.ItemViewModel) {
//        setNeedsStatusBarAppearanceUpdate()
//        contentView.updateIncoming(viewModel: viewModel)
//    }

    func displayRouteToSelectedScreen(viewModel: SideMenuFlow.RoutePayload.ViewModel) {
        router?.routeToSelectedScreen()
    }

    func displayRouteBack(viewModel: SideMenuFlow.RoutePayload.ViewModel) {
        router?.closeSideMenu()
    }

//    func displayWaitIndicator(viewModel: SideMenuFlow.OnWaitIndicator.ViewModel) {
//        contentView.displayWaitIndicator(viewModel: viewModel)
//    }
//

    func displayAlert(viewModel: SideMenuFlow.AlertInfo.ViewModel) {
        showAlert(title: viewModel.title,
                  message: viewModel.text,
                  firstButtonTitle: viewModel.buttonTitle ?? "Ok")
    }
}

// MARK: - SideMenuViewOutput

extension SideMenuController: SideMenuViewOutput {
    func didTapAtGrayView() {
        interactor?.swipedOrTappedAtGrayViewForClose(request: SideMenuFlow.RoutePayload.Request())
    }

    func swipedForClose() {
        interactor?.swipedOrTappedAtGrayViewForClose(request: SideMenuFlow.RoutePayload.Request())
    }

    func didTapAtCell(_ viewModel: UserProfileCellViewModel) {
        interactor?.onSelectItem(request: SideMenuFlow.OnSelectItem.Request(id: viewModel.id))
    }

    func didTapAtCell(_ viewModel: IconTextAndCounterCellViewModel) {
        interactor?.onSelectItem(request: SideMenuFlow.OnSelectItem.Request(id: viewModel.id))
    }

}
