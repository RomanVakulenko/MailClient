//
//  ContactNameAndAddressCell.swift
//  SGTS
//
//  Created by Roman Vakulenko on 29.05.2024.
//

import UIKit
import SnapKit

protocol ContactNameAndAddressCellOutput: AnyObject { }

final class ContactNameAndAddressCell: BaseTableViewCell<ContactNameAndAddressCellViewModel> {

    // MARK: - SubTypes
    private enum Constants {
        static let mainImageWidthHeight = 45
        static let leadingForSenderTitleText = 69 - 16
        static let emailTitleAndTextHeight = 17
        static let offsetForNameAndAddress = 2.5
        static let collectionViewHeght: CGFloat = 22
        static let cloudNewEmailBackViewCornerRadius: CGFloat = 9
    }

    private(set) lazy var backView: UIView = {
        let view = UIView()
        return view
    }()

    private(set) lazy var avatar: UIImageView = {
        let view = UIImageView()
        return view
    }()

    private(set) lazy var name: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.lineBreakMode = .byTruncatingTail
        return view
    }()

    private(set) lazy var emailTitle: UILabel = {
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

    weak var output: ContactNameAndAddressCellOutput?

    // MARK: - Public methods

    override func update(with viewModel: ContactNameAndAddressCellViewModel) {
        contentView.backgroundColor = viewModel.cellBackColor
        avatar.image = viewModel.avatarImage
        name.attributedText = viewModel.name
        emailTitle.attributedText = viewModel.email
        chevronRight.image = viewModel.chevron

        updateConstraints(insets: viewModel.insets)
        self.separatorInset = viewModel.separatorInset ?? .zero
    }

    override func composeSubviews() {
        contentView.addSubview(backView)
        [avatar, name, emailTitle, chevronRight].forEach { backView.addSubview($0) }
//        backgroundColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 1.0
        backView.addGestureRecognizer(longPressGesture)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapAtCell(_:)))
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(tapGestureRecognizer)
        
        let avatarTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapAtAvatar(_:)))
        avatar.isUserInteractionEnabled = true
        avatar.addGestureRecognizer(avatarTapGestureRecognizer)
    }

    override func setConstraints() {
        backView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }

        avatar.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.height.equalTo(Constants.mainImageWidthHeight)
        }

        name.snp.makeConstraints {
            $0.top.equalTo(backView.snp.top).offset(Constants.offsetForNameAndAddress)
            $0.leading.equalTo(avatar.snp.trailing).offset(UIHelper.Margins.medium8px)
            $0.trailing.equalToSuperview()
        }

        emailTitle.snp.makeConstraints {
            $0.bottom.equalTo(backView.snp.bottom).inset(Constants.offsetForNameAndAddress)
            $0.leading.equalTo(avatar.snp.trailing).offset(UIHelper.Margins.medium8px)
            $0.trailing.equalToSuperview()
        }
        
        chevronRight.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalTo(UIHelper.Margins.medium14px)
            $0.height.equalTo(UIHelper.Margins.medium16px)
            $0.trailing.equalToSuperview().inset(UIHelper.Margins.medium16px)
        }
    }

    // MARK: - Actions
    @objc private func didTapAtAvatar(_ sender: UITapGestureRecognizer) {
        viewModel?.didTapAtAvatar()
    }

    @objc private func didTapAtCell(_ sender: UITapGestureRecognizer) {
        viewModel?.didTapAtEmail()
    }

    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            viewModel?.onLongTap()
        }
    }

    // MARK: - Private methods
    ///Must have the same set of constraints as makeConstraints method
    private func updateConstraints(insets: UIEdgeInsets) {
        backView.snp.updateConstraints {
            $0.top.equalToSuperview().offset(insets.top) //all 16
            $0.leading.equalToSuperview().offset(insets.left)
            $0.bottom.equalToSuperview().inset(insets.bottom)
            $0.trailing.equalToSuperview().inset(insets.right)
        }
    }
}
