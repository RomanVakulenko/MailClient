//
//  SwitchBiometryCell.swift
//  SGTS
//
//  Created by Roman Vakulenko on 16.04.2024.
//

import UIKit
import SnapKit


final class SwitchBiometryCell: BaseTableViewCell<SwitchBiometryCellViewModel> {

    // MARK: - SubTypes
    private enum Constants {
        static let topOffset = 5
    }

    private(set) lazy var backView: UIView = {
        let view = UIView()
        return view
    }()

    private(set) lazy var bioSwitch: UISwitch = {
        let view = UISwitch()
        return view
    }()

    private(set) lazy var title: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        return view
    }()

    private var isSwitchOn = false

    // MARK: - Public methods
    override func update(with viewModel: SwitchBiometryCellViewModel) {
        self.title.attributedText = viewModel.title

        self.isSwitchOn = viewModel.isOn
        self.bioSwitch.setOn(self.isSwitchOn, animated: true)

        NotificationCenter.default.removeObserver(self)
        if let notification = viewModel.switchStateNotificationName {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(changeActiveState(_:)),
                name: notification,
                object: nil)
        }
        updateSwitchState(isActive: viewModel.isActive) //start state

        updateConstraints(insets: viewModel.insets)
        layoutIfNeeded()
    }

    override func composeSubviews() {
        [bioSwitch, title].forEach { backView.addSubview($0) }
        contentView.addSubview(backView)
        backgroundColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD
        bioSwitch.addTarget(self, action: #selector(didTapSwitch(_:)), for: .valueChanged)
    }

    override func setConstraints() {
        backView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }

        bioSwitch.snp.makeConstraints {
            $0.top.equalTo(backView.snp.top).offset(Constants.topOffset)
            $0.leading.equalTo(backView.snp.leading)
        }

        title.snp.makeConstraints {
            $0.leading.equalTo(bioSwitch.snp.trailing).offset(UIHelper.Margins.medium8px)
            $0.top.bottom.trailing.equalTo(backView)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Actions

    @objc private func changeActiveState(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any],
              let isActiveKey = viewModel?.isActiveKey,
              let isActive = userInfo[isActiveKey] as? Bool else {
            return
        }
        updateSwitchState(isActive: isActive)
    }

    @objc private func didTapSwitch(_ sender: UISwitch) {
        self.isSwitchOn.toggle()
        viewModel?.didTapAtSwitch(isOn: self.isSwitchOn)
    }

    // MARK: - Private methods

    private func updateSwitchState(isActive: Bool) {
        bioSwitch.isEnabled = isActive //updated state

        guard let viewModel = viewModel else { return }
        if isActive && viewModel.isOn {
            bioSwitch.onTintColor = viewModel.onTintColorBackOn
            bioSwitch.thumbTintColor = viewModel.thumbColorOn
        } else {
            bioSwitch.tintColor = viewModel.tintColorBackOff
            bioSwitch.thumbTintColor = viewModel.thumbColorOff
        }
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

