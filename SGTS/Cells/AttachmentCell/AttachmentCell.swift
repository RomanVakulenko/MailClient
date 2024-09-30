//
//  AttachmentCell.swift
//  SGTS
//
//  Created by Roman Vakulenko on 12.06.2024.
//

import Foundation
import SnapKit

protocol AttachmentCellOutput: AnyObject { }

final class AttachmentCell: BaseTableViewCell<AttachmentCellViewModel> {

    // MARK: - SubTypes

    private enum Constants {
        static let iconOfAttachmentExtensionWidthHeight = 32
    }

    private(set) lazy var backView: UIView = {
        let view = UIView()
        return view
    }()

    private(set) lazy var iconOfAttachmentExtension: UIImageView = {
        let view = UIImageView()
        return view
    }()

    private(set) lazy var fileNameWithExt: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.lineBreakMode = .byTruncatingTail
        return view
    }()

    private(set) lazy var nameAndSurname: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.lineBreakMode = .byTruncatingTail
        return view
    }()

    private(set) lazy var downloadingDate: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        return view
    }()

    private(set) lazy var downloadingSize: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        return view
    }()


    // MARK: - Public properties

    weak var output: AttachmentCellOutput?

    // MARK: - Public methods

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func update(with viewModel: AttachmentCellViewModel) {
        contentView.backgroundColor = viewModel.backColor
        iconOfAttachmentExtension.image = viewModel.iconOfAttachmentExtension
        fileNameWithExt.attributedText = viewModel.fileNameWithExt
        nameAndSurname.attributedText = viewModel.nameAndSurname
        downloadingDate.attributedText = viewModel.downloadingDate
        downloadingSize.attributedText = viewModel.downloadingSize

        updateConstraints(insets: viewModel.insets)
        self.separatorInset = viewModel.separatorInsets
    }

    override func composeSubviews() {
        [iconOfAttachmentExtension, fileNameWithExt, nameAndSurname, downloadingDate, downloadingSize].forEach { backView.addSubview($0) }
        contentView.addSubview(backView)
        backgroundColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapAtCell(_:)))
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(tapGestureRecognizer)
    }

    override func setConstraints() {
        backView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }

        iconOfAttachmentExtension.snp.makeConstraints {
            $0.centerY.equalTo(backView.snp.centerY)
            $0.leading.equalToSuperview()
            $0.width.height.equalTo(Constants.iconOfAttachmentExtensionWidthHeight)
        }

        fileNameWithExt.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(iconOfAttachmentExtension.snp.trailing).offset(UIHelper.Margins.medium8px)
            $0.trailing.lessThanOrEqualTo(downloadingDate.snp.leading)
//            $0.height.equalTo(UIHelper.Margins.large23px)
        }
        fileNameWithExt.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        nameAndSurname.snp.makeConstraints {
            $0.top.equalTo(fileNameWithExt.snp.bottom)
            $0.leading.equalTo(iconOfAttachmentExtension.snp.trailing).offset(UIHelper.Margins.medium8px)
            $0.trailing.lessThanOrEqualTo(downloadingSize.snp.leading)
            $0.bottom.equalToSuperview()
        }
        nameAndSurname.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        downloadingDate.snp.makeConstraints {
            $0.top.equalTo(backView.snp.top).offset(UIHelper.Margins.small2px)
            $0.trailing.equalToSuperview()
//            $0.height.equalTo(Constants.emailTitleAndTextHeight)
        }

        downloadingSize.snp.makeConstraints {
            $0.top.equalTo(downloadingDate.snp.bottom)
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(backView.snp.bottom).inset(UIHelper.Margins.small2px)
        }
    }

    // MARK: - Actions
    @objc private func didTapAtCell(_ sender: UITapGestureRecognizer) {
        viewModel?.didTapAttachmentCell()
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
