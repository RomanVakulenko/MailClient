//
//  IconTextAndSwitchCell.swift
//  SGTS
//
//  Created by Roman Vakulenko on 18.06.2024.
//

import UIKit
import SnapKit


final class IconTextAndSwitchCell: BaseTableViewCell<IconTextAndSwitchCellViewModel> {

    // MARK: - SubTypes

    private enum Constants {
        static let iconWidthHeight = 24
    }

    private(set) lazy var backView: UIView = {
        let view = UIView()
        return view
    }()

    private(set) lazy var icon: UIImageView = {
        let view = UIImageView()
        return view
    }()

    private(set) lazy var title: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        return lbl
    }()

    private(set) lazy var switcher: UISwitch = {
        let view = UISwitch()
        let thumbColorOff = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.grayRegularD //circleOFF
        let tintColorBackOff = Theme.shared.isLight ? UIHelper.Color.grayL : UIHelper.Color.grayStrongD //backOFF

        let thumbColorOn = UIHelper.Color.blue //circleON_both
        let onTintColorBackOn = UIHelper.Color.darkBlue //backON

        view.tintColor = view.isOn ? onTintColorBackOn : tintColorBackOff
        view.thumbTintColor = view.isOn ? thumbColorOn : thumbColorOff
        return view
    }()

    // MARK: - Public methods
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func update(with viewModel: IconTextAndSwitchCellViewModel) {
        contentView.backgroundColor = viewModel.cellBackColor
        icon.image = viewModel.icon
        title.attributedText = viewModel.title
        title.numberOfLines = 0

        updateSwitchAppearance(isOn: viewModel.isOn)
        switcher.setOn(viewModel.isOn, animated: false)

        updateConstraints(insets: viewModel.insets)
        layoutIfNeeded()
    }

    override func composeSubviews() {
        contentView.addSubview(backView)
        [icon, title, switcher].forEach { backView.addSubview($0) }

        switcher.addTarget(self, action: #selector(didTapSwitch(_:)), for: .valueChanged)
    }

    override func setConstraints() {

        backView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }

        icon.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(Constants.iconWidthHeight)
        }

        title.snp.makeConstraints {
            $0.top.equalToSuperview().offset(UIHelper.Margins.medium16px)
            $0.leading.equalTo(icon.snp.trailing).offset(UIHelper.Margins.medium8px)
            $0.trailing.equalTo(switcher.snp.leading).offset(-UIHelper.Margins.medium8px)
            $0.bottom.equalToSuperview().offset(-UIHelper.Margins.medium16px)
        }
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        switcher.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }


    // MARK: - Actions

    @objc private func didTapSwitch(_ sender: UISwitch) {
        viewModel?.didTapAtSwitch()
    }

    // MARK: - Private methods

    private func updateSwitchAppearance(isOn: Bool) {
        guard let viewModel = viewModel else { return }

        if isOn {
            switcher.onTintColor = viewModel.onTintColorBackOn
            switcher.thumbTintColor = viewModel.thumbColorOn
        } else {
            switcher.tintColor = viewModel.tintColorBackOff
            switcher.thumbTintColor = viewModel.thumbColorOff
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



