//
//  CloudEmailAttachmentCollectionViewCell.swift
//  SGTS
//
//  Created by Roman Vakulenko on 20.04.2024.
//


import UIKit
import SnapKit

final class CloudEmailAttachmentCollectionViewCell: BaseCollectionViewCell<CloudEmailAttachmentViewModel> {

    enum Constants {
        static let cornerRadius: CGFloat = 11 //in figma 42!!!!- is wrong
        static let topBottomOffset: CGFloat = 5
        static let leftRightInset: CGFloat = 8
        static let insideCellSpacing: CGFloat = 2
        static let imageWidth: CGFloat = 12
    }

    private(set) lazy var backView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }()

    private(set) lazy var cloudAttachmentImage: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        return view
    }()

    private(set) lazy var cloudAttachmentTitle: UILabel = {
        let view = UILabel()
        view.lineBreakMode = .byTruncatingTail
        return view
    }()

    private(set) lazy var closeXButton: UIButton = {
        let view = UIButton(type: .system)
        return view
    }()

    private var isNewCreatingEmail = false


    // MARK: - Public methods
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

   override func update(with viewModel: CloudEmailAttachmentViewModel) {
       contentView.backgroundColor = .none
       backView.backgroundColor = viewModel.backColor
       backView.layer.borderWidth = UIHelper.Margins.small1px
       backView.layer.borderColor = viewModel.borderColor.cgColor
       cloudAttachmentImage.image = viewModel.attachmentIconOfCloud
       cloudAttachmentTitle.attributedText = viewModel.filenameWithoutExt

       isNewCreatingEmail = viewModel.isNewCreatingEmail ?? false
       if isNewCreatingEmail {
           backView.addSubview(closeXButton)

           cloudAttachmentTitle.snp.remakeConstraints {
               $0.centerY.equalTo(cloudAttachmentImage.snp.centerY)
               $0.leading.equalTo(cloudAttachmentImage.snp.trailing).offset(UIHelper.Margins.small2px)
               $0.trailing.equalTo(closeXButton.snp.leading).offset(-UIHelper.Margins.small2px)
           }

           closeXButton.snp.makeConstraints {
               $0.centerY.equalTo(cloudAttachmentTitle.snp.centerY)
               $0.width.height.equalTo(GlobalConstants.xButtonWidth)
               $0.trailing.equalToSuperview().offset(-UIHelper.Margins.medium8px)
           }

           closeXButton.setImage(viewModel.xButton, for: .normal)
           closeXButton.addTarget(self, action: #selector(didTapXButtonAtCloud(_:)), for: .touchUpInside)
       }
       
       updateConstraints(insets: viewModel.insets)
       layoutIfNeeded()
   }

    override func composeSubviews() {
        backgroundColor = .none
        contentView.addSubview(backView)
        backView.addSubview(cloudAttachmentImage)
        backView.addSubview(cloudAttachmentTitle)

        let attachmentTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapAttachment(_:)))
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(attachmentTapGestureRecognizer)
    }

    override func setConstraints() {
        backView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }

        cloudAttachmentImage.snp.makeConstraints {
            $0.top.equalTo(backView.snp.top).offset(Constants.topBottomOffset)
            $0.bottom.equalTo(backView.snp.bottom).inset(Constants.topBottomOffset)
            $0.leading.equalTo(backView.snp.leading).offset(UIHelper.Margins.medium8px)
            $0.width.height.equalTo(UIHelper.Margins.medium12px)
        }
        cloudAttachmentTitle.snp.makeConstraints {
            $0.centerY.equalTo(cloudAttachmentImage.snp.centerY)
            $0.leading.equalTo(cloudAttachmentImage.snp.trailing).offset(UIHelper.Margins.small2px)
            $0.trailing.equalToSuperview().offset(-UIHelper.Margins.medium8px)
        }
    }

    // MARK: - Private methods

    @objc private func didTapXButtonAtCloud(_ sender: UIButton) {
        viewModel?.tapAt(CloudEmailAttachmentViewModel.TapAt.xButton)
    }

    @objc private func didTapAttachment(_ sender: UITapGestureRecognizer) {
        viewModel?.tapAt(CloudEmailAttachmentViewModel.TapAt.cloudAttachment)
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
