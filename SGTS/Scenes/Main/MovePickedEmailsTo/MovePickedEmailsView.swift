//
//  MovePickedEmailsView.swift
//  SGTS
//
//  Created by Roman Vakulenko on 24.05.2024.
//

import UIKit
import SnapKit

protocol MovePickedEmailsViewOutput: AnyObject {

    func didTapAtAlreadySent()
    func didTapToDraft()
    func didTapToArchive()
    func didTapToDeleted()

    func didTapCancel()
}

protocol MovePickedEmailsViewLogic: UIView {
    func update(viewModel: MovePickedEmailsModel.ViewModel)
//    func displayWaitIndicator(viewModel: MovePickedEmailsFlow.OnWaitIndicator.ViewModel)

    var output: MovePickedEmailsViewOutput? { get set }
}

final class MovePickedEmailsView: UIView, MovePickedEmailsViewLogic, SpinnerDisplayable {

    // MARK: - Public methods

    // MARK: - Public properties
    private enum Constants {
        static let stackViewHeight = 120
    }

    private lazy var grayView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()

    private lazy var extendedMenuMoveTo: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = UIHelper.Margins.large24px
        return view
    }()

    private lazy var titleOfExtendedMenu: UILabel = {
        var lbl = UILabel()
        return lbl
    }()

    private lazy var toAlreadySentButton = UIButton(type: .system)
    private lazy var toDraftsButton = UIButton(type: .system)
    private lazy var toArchiveBarButton = UIButton(type: .system)
    private lazy var toDeletedButton = UIButton(type: .system)


    private lazy var stackForExtendedView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fillEqually
        view.spacing = UIHelper.Margins.medium16px
        return view
    }()

    private lazy var cancelButton: UIButton = {
        let btn = UIButton(type: .system)
        return btn
    }()

    private(set) var viewModel: MovePickedEmailsModel.ViewModel?

    // MARK: - Init

    deinit { }

    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    weak var output: MovePickedEmailsViewOutput?
    
    // MARK: - Public Methods
    
    func update(viewModel: MovePickedEmailsModel.ViewModel) {
        self.viewModel = viewModel

        grayView.backgroundColor = viewModel.grayViewColor

        extendedMenuMoveTo.backgroundColor = viewModel.extendedMenuMoveToColor
        titleOfExtendedMenu.attributedText = viewModel.titleOfExtendedMenu

        toAlreadySentButton.setAttributedTitle(viewModel.toAlreadySentTitle, for: .normal)
        toDraftsButton.setAttributedTitle(viewModel.toDraftsTitle, for: .normal)
        toArchiveBarButton.setAttributedTitle(viewModel.toArchiveTitle, for: .normal)
        toDeletedButton.setAttributedTitle(viewModel.toDeletedTitle, for: .normal)

        stackForExtendedView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        stackForExtendedView.addArrangedSubview(toAlreadySentButton)
        stackForExtendedView.addArrangedSubview(toDraftsButton)
        stackForExtendedView.addArrangedSubview(toArchiveBarButton)
        stackForExtendedView.addArrangedSubview(toDeletedButton)

        cancelButton.setAttributedTitle(viewModel.cancelTitle, for: .normal)
    }
    
    //    func displayWaitIndicator(viewModel: MovePickedEmailsFlow.OnWaitIndicator.ViewModel) {
    //        if viewModel.isShow {
    //            showSpinner()
    //        } else {
    //            hideSpinner()
    //        }
    //    }


    // MARK: - Actions

    @objc func didTapAtAlreadySent(_ sender: UIButton) {
        output?.didTapAtAlreadySent()
    }

    @objc func didTapToDraft(_ sender: UIButton) {
        output?.didTapToDraft()
    }

    @objc func didTapToArchive(_ sender: UIButton) {
        output?.didTapToArchive()
    }

    @objc func didTapToDeleted(_ sender: UIButton) {
        output?.didTapToDeleted()
    }

    @objc func didTapCancel(_ sender: UIButton) {
        output?.didTapCancel()
    }



    // MARK: - Private Methods

    private func configure() {
        addSubviews()
        configureConstraints()

        toAlreadySentButton.addTarget(self, action: #selector(didTapAtAlreadySent), for: .touchUpInside)
        toDraftsButton.addTarget(self, action: #selector(didTapToDraft), for: .touchUpInside)
        toArchiveBarButton.addTarget(self, action: #selector(didTapToArchive), for: .touchUpInside)
        toDeletedButton.addTarget(self, action: #selector(didTapToDeleted), for: .touchUpInside)

        cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
    }

    private func addSubviews() {
        self.addSubview(grayView)
        grayView.addSubview(extendedMenuMoveTo)
        [titleOfExtendedMenu, stackForExtendedView, cancelButton].forEach{extendedMenuMoveTo.addSubview($0)}
        self.addSubview(grayView)
    }

    private func configureConstraints() {
        let view = self

        grayView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }

        extendedMenuMoveTo.snp.makeConstraints {
            $0.leading.equalTo(view.snp.leading).offset(UIHelper.Margins.large32px)
            $0.trailing.equalTo(view.snp.trailing).offset(-UIHelper.Margins.large32px)
            $0.center.equalToSuperview()
        }

        titleOfExtendedMenu.snp.makeConstraints {
            $0.top.equalTo(extendedMenuMoveTo.snp.top).offset(UIHelper.Margins.large24px)
            $0.leading.equalTo(extendedMenuMoveTo.snp.leading).offset(UIHelper.Margins.large24px)
            $0.trailing.equalTo(extendedMenuMoveTo.snp.trailing).offset(-UIHelper.Margins.large24px)
        }

        stackForExtendedView.snp.makeConstraints {
            $0.top.equalTo(titleOfExtendedMenu.snp.bottom).offset(UIHelper.Margins.large24px)
            $0.leading.equalTo(extendedMenuMoveTo.snp.leading).offset(UIHelper.Margins.large24px)
            $0.height.equalTo(Constants.stackViewHeight)
        }

        cancelButton.snp.makeConstraints {
            $0.top.equalTo(stackForExtendedView.snp.bottom).offset(UIHelper.Margins.large24px)
            $0.trailing.equalTo(extendedMenuMoveTo.snp.trailing).offset(-UIHelper.Margins.large24px)
            $0.bottom.equalTo(extendedMenuMoveTo.snp.bottom).offset(-UIHelper.Margins.large24px)
        }

    }
}
