//
//  OneEmailDetailsButtonsView.swift
//  SGTS
//
//  Created by Roman Vakulenko on 23.04.2024.
//

import UIKit
import SnapKit

protocol OneEmailDetailsButtonsViewOutput: AnyObject {
    func didTapReply(viewModel: OneEmailDetailsButtonsViewModel.ButtonType)
    func didTapReplyToAll(viewModel: OneEmailDetailsButtonsViewModel.ButtonType)
    func didTapForward(viewModel: OneEmailDetailsButtonsViewModel.ButtonType)
}

protocol OneEmailDetailsButtonsViewLogic: UIView {
    func update(viewModel: OneEmailDetailsButtonsViewModel)
//    func displayWaitIndicator(viewModel: OneEmailDetailsHeaderFlow.OnWaitIndicator.ViewModel)

    var output: OneEmailDetailsButtonsViewOutput? { get set }
}

final class OneEmailDetailsButtonsView: UIView, OneEmailDetailsButtonsViewLogic {


    // MARK: - Public properties
    var viewModel: OneEmailDetailsButtonsViewModel?

    weak var output: OneEmailDetailsButtonsViewOutput?

    // MARK: - SubTypes

    private enum Constants {
        static let inset = UIHelper.Margins.medium16px
    }

    private(set) lazy var backView: UIView = {
        let view = UIView()
        return view
    }()

    private(set) lazy var replyButton: UIButton = {
        let btn = UIButton(type: .system)
        return btn
    }()

    private(set) lazy var replyToAllButton: UIButton = {
        let btn = UIButton(type: .system)
        return btn
    }()

    private(set) lazy var forwardButton: UIButton = {
        let btn = UIButton(type: .system)
        return btn
    }()


    // MARK: - Init

    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        configure()
        backgroundColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    func update(viewModel: OneEmailDetailsButtonsViewModel) {
        //fixes flashing == updating if no need
        if forwardButton.backgroundColor != viewModel.forwardBackColor {
            replyButton.setAttributedTitle(viewModel.replyTitle, for: .normal)
            replyButton.backgroundColor = viewModel.replyBackColor
            replyButton.layer.cornerRadius = UIHelper.Margins.medium8px
        }
        if forwardButton.backgroundColor != viewModel.forwardBackColor {
            replyToAllButton.setAttributedTitle(viewModel.replyToAllTitle, for: .normal)
            replyToAllButton.backgroundColor = viewModel.replyToAllBackColor
            replyToAllButton.layer.borderColor = viewModel.borderColor.cgColor

            replyToAllButton.layer.cornerRadius = UIHelper.Margins.medium8px
            replyToAllButton.layer.borderWidth = UIHelper.Margins.small1px
        }

        if forwardButton.backgroundColor != viewModel.forwardBackColor {
            forwardButton.setAttributedTitle(viewModel.forwardTitle, for: .normal)
            forwardButton.backgroundColor = viewModel.forwardBackColor
            forwardButton.layer.cornerRadius = UIHelper.Margins.medium8px
        }

        updateConstraints(insets: viewModel.insets)
        layoutIfNeeded()
    }

    private func configure() {
        addSubviews()
        setConstraints()
    }

    private func addSubviews() {
        [replyButton, replyToAllButton, forwardButton].forEach { backView.addSubview($0) }
        self.addSubview(backView)

        replyButton.addTarget(self, action: #selector(didTapReply), for: .touchUpInside)
        replyToAllButton.addTarget(self, action: #selector(didTapReplyToAll), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(didTapForward), for: .touchUpInside)
    }

    func setConstraints() {
        backView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }

        let screenWidth = UIScreen.main.bounds.width
        let buttonWidth = (screenWidth - 3 * Constants.inset) / 2

        replyButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(UIHelper.Margins.medium8px)
            $0.leading.equalToSuperview()
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(UIHelper.Margins.huge56px)
        }

        replyToAllButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(UIHelper.Margins.medium8px)
            $0.trailing.equalToSuperview()
            $0.leading.equalTo(replyButton.snp.trailing).offset(UIHelper.Margins.medium16px)
            $0.height.equalTo(UIHelper.Margins.huge56px)
        }

        forwardButton.snp.makeConstraints {
            $0.top.equalTo(replyButton.snp.bottom).offset(UIHelper.Margins.medium16px)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(UIHelper.Margins.medium8px)
            $0.height.equalTo(UIHelper.Margins.huge56px)
        }
    }
    // MARK: - Private methods

    @objc private func didTapReply(_ sender: UIButton) {
//        viewModel?.onTap(OneEmailDetailsButtonsViewModel.ButtonType.reply)
        output?.didTapReply(viewModel: OneEmailDetailsButtonsViewModel.ButtonType.reply)
    }
    @objc private func didTapReplyToAll(_ sender: UIButton) {
//        viewModel?.onTap(OneEmailDetailsButtonsViewModel.ButtonType.replyToAll)
        output?.didTapReplyToAll(viewModel: OneEmailDetailsButtonsViewModel.ButtonType.replyToAll)
    }
    @objc private func didTapForward(_ sender: UIButton) {
//        viewModel?.onTap(OneEmailDetailsButtonsViewModel.ButtonType.forward)
        output?.didTapForward(viewModel: OneEmailDetailsButtonsViewModel.ButtonType.forward)
    }

    ///Must have the same set of constraints as makeConstraints method
    private func updateConstraints(insets: UIEdgeInsets) {
        backView.snp.updateConstraints {
            $0.top.equalToSuperview().offset(insets.top)
            $0.leading.equalToSuperview().offset(insets.left)
            $0.bottom.equalToSuperview().inset(insets.bottom)
            $0.trailing.equalToSuperview().inset(insets.right)
        }
    }

}




