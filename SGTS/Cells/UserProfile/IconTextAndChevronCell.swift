//
//  IconTextAndChevronCell.swift
//  SGTS
//
//  Created by Roman Vakulenko on 18.06.2024.
//

import UIKit
import SnapKit


final class IconTextAndChevronCell: BaseTableViewCell<IconTextAndChevronCellViewModel> {

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
        let view = UILabel()
        view.textAlignment = .left
        view.numberOfLines = 0
        return view
    }()

    private(set) lazy var chevronRight: UIImageView = {
        let view = UIImageView()
        return view
    }()

    // MARK: - Public methods
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func update(with viewModel: IconTextAndChevronCellViewModel) {
        contentView.backgroundColor = viewModel.cellBackColor
        icon.image = viewModel.icon
        title.attributedText = viewModel.title
        chevronRight.image = viewModel.chevron
        
        updateConstraints(insets: viewModel.insets)
    }

    override func composeSubviews() {
        contentView.addSubview(backView)
        [icon, title, chevronRight].forEach { backView.addSubview($0) }


        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapAtCell(_:)))
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(tapGestureRecognizer)
    }

    override func setConstraints() {

        backView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }

        icon.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview().offset(UIHelper.Margins.small4px)
            $0.bottom.equalToSuperview().inset(UIHelper.Margins.small4px)
            $0.width.height.equalTo(Constants.iconWidthHeight)
        }

        title.snp.makeConstraints {
            $0.leading.equalTo(icon.snp.trailing).offset(UIHelper.Margins.medium8px)
            $0.centerY.equalTo(icon.snp.centerY)
            $0.trailing.equalTo(chevronRight.snp.leading).offset(-UIHelper.Margins.small2px)
        }

        chevronRight.snp.makeConstraints {
            $0.centerY.equalTo(icon.snp.centerY)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(UIHelper.Margins.medium14px)
            $0.height.equalTo(UIHelper.Margins.medium16px)
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


