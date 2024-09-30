//
//  BtnTableViewCell.swift
//  SGTS
//
//  Created by Roman Vakulenko on 09.04.2024.
//

import UIKit
import SnapKit


final class NextStepButtonCell: BaseTableViewCell<NextStepButtonCellViewModel> {

    // MARK: - SubTypes

    private(set) lazy var backView: UIView = {
        let view = UIView()
        return view
    }()

    private(set) lazy var nextStepButton: UIButton = {
        let btn = UIButton(type: .system)
        return btn
    }()

    // MARK: - Public methods

    override func update(with viewModel: NextStepButtonCellViewModel) {
        NotificationCenter.default.removeObserver(self)
        if let notification = viewModel.switchStateNotificationName {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(changeActiveState(_:)),
                                                   name: notification,
                                                   object: nil)
        }
        if UIHelper.Color.blue == viewModel.borderColor {
            nextStepButton.layer.borderWidth = viewModel.borderWidth ?? 0
            nextStepButton.layer.borderColor = UIHelper.Color.blue.cgColor
        }
        nextStepButton.layer.cornerRadius = UIHelper.Margins.medium8px
        updateButtonState(isActive: viewModel.isActive)
        updateConstraints(insets: viewModel.insets)
        layoutIfNeeded()
    }

    override func composeSubviews() {
        backView.addSubview(nextStepButton)
        contentView.addSubview(backView)
        backgroundColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD
        nextStepButton.addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }

    override func setConstraints() {
        backView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }

        nextStepButton.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
            $0.height.equalTo(UIHelper.Margins.huge56px)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Private methods

    @objc private func didTap(_ sender: UIButton) {
        viewModel?.onTap()
    }

    @objc private func changeActiveState(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any],
              let isActiveKey = viewModel?.isActiveKey,
              let isActive = userInfo[isActiveKey] as? Bool else {
            return
        }
        updateButtonState(isActive: isActive)
    }

    private func updateButtonState(isActive: Bool) {
        guard let viewModel = viewModel else { return }
        nextStepButton.setAttributedTitle(isActive ? viewModel.activeTitle : viewModel.nonActiveTitle, for: .normal)
        nextStepButton.backgroundColor = isActive ? viewModel.activeBackColor : viewModel.nonActiveBackColor
        nextStepButton.isUserInteractionEnabled = isActive
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



