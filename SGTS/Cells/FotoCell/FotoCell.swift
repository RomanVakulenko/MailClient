//
//  FotoCell.swift
//  SGTS
//
//  Created by Roman Vakulenko on 24.04.2024.
//

import UIKit
import SnapKit


final class FotoCell: BaseTableViewCell<FotoCellViewModel> {

    // MARK: - SubTypes

    private enum Constants {
        static let fotoHeight: CGFloat = 139
    }


    private(set) lazy var backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = UIHelper.Margins.medium8px
        view.layer.borderWidth = UIHelper.Margins.small1px
        view.clipsToBounds = true
        return view
    }()

    private(set) lazy var fotoImage: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()

    private(set) lazy var fileIcon: UIImageView = {
        let view = UIImageView()
        return view
    }()

    private(set) lazy var fileName: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.lineBreakMode = .byTruncatingTail
        return view
    }()

    private(set) lazy var downloadIcon: UIImageView = {
        let view = UIImageView()
        return view
    }()

    private(set) lazy var quattroIcon: UIImageView = {
        let view = UIImageView()
        return view
    }()

    // MARK: - Public methods

    override func update(with viewModel: FotoCellViewModel) {
        self.backView.backgroundColor = viewModel.backColor
        self.backView.layer.borderColor = viewModel.borderColor.cgColor

        self.fotoImage.image = viewModel.fotoImage
        self.fileIcon.image = viewModel.fileIcon
        self.fileName.attributedText = viewModel.fileNameWithExt
        self.downloadIcon.image = viewModel.downloadIcon
        self.quattroIcon.image = viewModel.quattroIcon

        updateConstraints(insets: viewModel.insets)
        layoutIfNeeded()
    }

    override func composeSubviews() {
        [fotoImage, fileIcon, fileName, downloadIcon, quattroIcon].forEach{ backView.addSubview($0) }
        contentView.addSubview(backView)

        let fotoTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapFoto(_:)))
        fotoImage.isUserInteractionEnabled = true
        fotoImage.addGestureRecognizer(fotoTapGestureRecognizer)

        let downloadTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapDownloadIcon(_:)))
        downloadIcon.isUserInteractionEnabled = true
        downloadIcon.addGestureRecognizer(downloadTapGestureRecognizer)

        let quattroTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapQuattroIcon(_:)))
        quattroIcon.isUserInteractionEnabled = true
        quattroIcon.addGestureRecognizer(quattroTapGestureRecognizer)
    }

    override func setConstraints() {
        backView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }

        fotoImage.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(Constants.fotoHeight)
        }

        fileName.snp.makeConstraints {
            $0.top.equalTo(fotoImage.snp.bottom).offset(UIHelper.Margins.medium10px)
            $0.bottom.equalToSuperview().inset(UIHelper.Margins.medium10px)
            $0.leading.equalTo(fileIcon.snp.trailing).offset(UIHelper.Margins.small4px)
            $0.trailing.lessThanOrEqualTo(downloadIcon.snp.leading).inset(UIHelper.Margins.medium10px)
        }

        fileIcon.snp.makeConstraints {
            $0.centerY.equalTo(fileName.snp.centerY)
            $0.leading.equalToSuperview().offset(UIHelper.Margins.medium12px)
        }

        downloadIcon.snp.makeConstraints {
            $0.centerY.equalTo(fileName.snp.centerY)
            $0.width.height.equalTo(UIHelper.Margins.medium18px)
            $0.trailing.equalTo(quattroIcon.snp.leading).offset(-UIHelper.Margins.medium8px)
        }

        quattroIcon.snp.makeConstraints {
            $0.centerY.equalTo(fileName.snp.centerY)
            $0.width.height.equalTo(UIHelper.Margins.medium18px)
            $0.trailing.equalToSuperview().inset(UIHelper.Margins.medium12px)
        }
    }

    // MARK: - Private methods

    @objc private func didTapFoto(_ sender: UITapGestureRecognizer) {
        viewModel?.onTap(FotoCellViewModel.TapAt.foto)
    }
    @objc private func didTapDownloadIcon(_ sender: UIButton) {
        viewModel?.onTap(FotoCellViewModel.TapAt.downloadIcon)
    }
    @objc private func didTapQuattroIcon(_ sender: UIButton) {
        viewModel?.onTap(FotoCellViewModel.TapAt.quattroIcon)
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

