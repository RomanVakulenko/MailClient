//
//  SideMenuCell.swift
//  SGTS
//
//  Created by Roman Vakulenko on 04.07.2024.
//

import UIKit
import SnapKit


final class IconTextAndCounterCell: BaseTableViewCell<IconTextAndCounterCellViewModel> {

    // MARK: - SubTypes

    private enum Constants {
        static let iconWidthHeight =  24
        static let cellHeight = 16 + 32 + 16
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

    private(set) lazy var counterField: UILabel = {
        let view = UILabel()
        return view
    }()

    // MARK: - Public methods
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func update(with viewModel: IconTextAndCounterCellViewModel) {
        contentView.backgroundColor = viewModel.cellBackColor
        icon.image = viewModel.icon
        title.attributedText = viewModel.title
        counterField.attributedText = viewModel.counterText

        updateConstraints(insets: viewModel.insets)
    }

    override func composeSubviews() {
        contentView.addSubview(backView)
        [icon, title, counterField].forEach { backView.addSubview($0) }

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapAtCell(_:)))
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(tapGestureRecognizer)
    }

    override func setConstraints() {

        backView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
            $0.height.equalTo(Constants.cellHeight)
        }

        icon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(UIHelper.Margins.medium16px)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(Constants.iconWidthHeight)
        }

        title.snp.makeConstraints {
            $0.leading.equalTo(icon.snp.trailing).offset(UIHelper.Margins.medium8px)
            $0.centerY.equalTo(icon.snp.centerY)
            $0.trailing.equalTo(counterField.snp.leading).inset(UIHelper.Margins.medium8px)
        }
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        counterField.snp.makeConstraints {
            $0.centerY.equalTo(icon.snp.centerY)
            $0.trailing.equalToSuperview().inset(UIHelper.Margins.medium16px)
        }
    }


    // MARK: - Actions
    @objc private func didTapAtCell(_ sender: UITapGestureRecognizer) {
        viewModel?.didTapAtCell()
    }

    // MARK: - Private methods

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


