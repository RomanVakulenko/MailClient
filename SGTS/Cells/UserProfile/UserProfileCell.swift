//
//  UserProfileCell.swift
//  SGTS
//
//  Created by Roman Vakulenko on 18.06.2024.
//

import UIKit
import SnapKit

protocol UserProfileCellOutput: AnyObject { }

final class UserProfileCell: BaseTableViewCell<UserProfileCellViewModel> {

    // MARK: - SubTypes
    private enum Constants {
        static let mainImageWidthHeight = 45
        static let offsetForNameAndEmail = 3
    }

    private(set) lazy var backView: UIView = {
        let view = UIView()
        return view
    }()

    private(set) lazy var avatarImage: UIImageView = {
        let view = UIImageView()
        return view
    }()

    private(set) lazy var name: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.lineBreakMode = .byTruncatingTail
        return view
    }()

    private(set) lazy var email: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.lineBreakMode = .byTruncatingTail
        return view
    }()

    private(set) lazy var chevronRight: UIImageView = {
        let view = UIImageView()
        return view
    }()


    // MARK: - Public properties

    weak var output: UserProfileCellOutput?

    // MARK: - Public methods

    override func update(with viewModel: UserProfileCellViewModel) {
        contentView.backgroundColor = viewModel.cellBackColor
        avatarImage.image = viewModel.avatarImage
        name.attributedText = viewModel.name
        email.attributedText = viewModel.email
        chevronRight.image = viewModel.chevron

        updateConstraints(insets: viewModel.insets)
    }

    override func composeSubviews() {
        contentView.addSubview(backView)
        [avatarImage, name, email, chevronRight].forEach { backView.addSubview($0) }

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapAtCell(_:)))
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(tapGestureRecognizer)
    }

    override func setConstraints() {
        backView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }

        avatarImage.snp.makeConstraints {
            $0.top.equalTo(backView.snp.top).offset(UIHelper.Margins.medium16px)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.height.equalTo(Constants.mainImageWidthHeight)
            $0.bottom.equalTo(backView.snp.bottom).inset(UIHelper.Margins.medium16px)
        }

        name.snp.makeConstraints {
            $0.top.equalTo(avatarImage.snp.top).offset(Constants.offsetForNameAndEmail)
            $0.leading.equalTo(avatarImage.snp.trailing).offset(UIHelper.Margins.medium8px)
            $0.trailing.equalTo(chevronRight.snp.leading).offset(-UIHelper.Margins.medium8px)
        }
        name.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        email.snp.makeConstraints {
            $0.bottom.equalTo(avatarImage.snp.bottom).inset(Constants.offsetForNameAndEmail)
            $0.leading.equalTo(avatarImage.snp.trailing).offset(UIHelper.Margins.medium8px)
            $0.trailing.equalTo(chevronRight.snp.leading).offset(-UIHelper.Margins.medium8px)
        }
        email.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        chevronRight.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalTo(UIHelper.Margins.medium14px)
            $0.height.equalTo(UIHelper.Margins.medium16px)
            $0.trailing.equalToSuperview()
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
