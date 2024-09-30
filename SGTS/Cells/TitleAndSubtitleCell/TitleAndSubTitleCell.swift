//
//  TitleAndSubTitleCell.swift
//  SGTS
//
//  Created by Roman Vakulenko on 09.04.2024.
//

import UIKit
import SnapKit


final class TitleAndSubTitleCell: BaseTableViewCell<TitleAndSubTitleCellViewModel> {

    // MARK: - SubTypes

    private(set) lazy var backView: UIView = {
        let view = UIView()
        return view
    }()

    private(set) lazy var title: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        return lbl
    }()

    private(set) lazy var subTitle: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }() 

    // MARK: - Public methods
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func update(with viewModel: TitleAndSubTitleCellViewModel) {
        self.title.attributedText = viewModel.title
        self.subTitle.attributedText = viewModel.subTitle
        updateConstraints(insets: viewModel.insets)
        layoutIfNeeded()
    }

    override func composeSubviews() {
        [title, subTitle].forEach { backView.addSubview($0) }
        contentView.addSubview(backView)
        contentView.backgroundColor = .clear
    }

    override func setConstraints() {

        backView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }

        title.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(backView)
        }

        subTitle.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(UIHelper.Margins.small4px)
            $0.leading.equalTo(backView.snp.leading)
            $0.trailing.equalTo(backView.snp.trailing)
            $0.bottom.equalTo(backView.snp.bottom)
        }
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

