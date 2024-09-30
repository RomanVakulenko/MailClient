//
//  BrowseButtonCell.swift
//  SGTS
//
//  Created by Roman Vakulenko on 12.04.2024.
//

import UIKit
import SnapKit


final class BrowseButtonCell: BaseTableViewCell<BrowseButtonCellViewModel> {

    enum Constants {
      static let browseWidth: CGFloat = 166
    }

    // MARK: - SubTypes

    private(set) lazy var backView: UIView = {
        let view = UIView()
        return view
    }()

    private(set) lazy var browseButton: UIButton = {
        let view = UIButton(type: .system)
        view.backgroundColor = .clear
        return view
    }()

    // MARK: - Public methods

    override func update(with viewModel: BrowseButtonCellViewModel) {
        browseButton.setAttributedTitle(viewModel.title, for: .normal)
        browseButton.layer.borderColor = viewModel.borderColor.cgColor

        browseButton.layer.cornerRadius = UIHelper.Margins.medium8px
        browseButton.layer.borderWidth = UIHelper.Margins.small1px
        updateConstraints(insets: viewModel.insets)
        layoutIfNeeded()
    }

    override func composeSubviews() {
        backgroundColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD
        contentView.addSubview(backView)
        backView.addSubview(browseButton)
        browseButton.addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }

    override func setConstraints() {
        backView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }

        browseButton.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview() //deleted trailing, cause of width
            $0.width.equalTo(Constants.browseWidth)
            $0.height.equalTo(UIHelper.Margins.huge40px)
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



