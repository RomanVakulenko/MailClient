//
//  CloudKeyCell.swift
//  SGTS
//
//  Created by Roman Vakulenko on 12.04.2024.
//

import UIKit
import SnapKit


final class CloudKeyCell: BaseTableViewCell<CloudKeyCellViewModel> {

    // MARK: - SubTypes

    private(set) lazy var backView: UIView = {
        let view = UIView()
        return view
    }()

    private(set) lazy var cloudBackView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = UIHelper.Margins.medium8px
        view.layer.borderWidth = UIHelper.Margins.small1px
        return view
    }()

    private(set) lazy var title: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        return view
    }()


    private(set) lazy var closeXButton: UIButton = {
        let view = UIButton(type: .system)
        return view
    }()


    // MARK: - Public methods

    override func update(with viewModel: CloudKeyCellViewModel) {
        title.attributedText = viewModel.title
        cloudBackView.backgroundColor = viewModel.backColor
        cloudBackView.layer.borderColor = viewModel.borderColor.cgColor
        closeXButton.setImage(viewModel.xButton, for: .normal)

        updateConstraints(insets: viewModel.insets)
        layoutIfNeeded()
    }

    override func composeSubviews() {
        backgroundColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD
        contentView.addSubview(backView)
        backView.addSubview(cloudBackView)
        cloudBackView.addSubview(title)
        cloudBackView.addSubview(closeXButton)


        closeXButton.addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }

    override func setConstraints() {
        backView.snp.makeConstraints {
            $0.leading.trailing.bottom.top.equalToSuperview()
        }

        cloudBackView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
        }

        title.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(UIHelper.Margins.medium8px)
            $0.top.equalToSuperview().offset(UIHelper.Margins.small4px)
            $0.bottom.equalToSuperview().offset(-UIHelper.Margins.small4px)
            $0.trailing.equalTo(closeXButton.snp.leading).offset(-UIHelper.Margins.small2px)
        }

        closeXButton.snp.makeConstraints {
            $0.centerY.equalTo(title.snp.centerY)
            $0.width.height.equalTo(GlobalConstants.xButtonWidth)
            $0.trailing.equalToSuperview().offset(-UIHelper.Margins.medium8px)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Private methods

    @objc private func didTap(_ sender: UIButton) {
        viewModel?.onTap()
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




