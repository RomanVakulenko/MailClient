//
//  EmailCell.swift
//  SGTS
//
//  Created by Roman Vakulenko on 17.04.2024.
//

import UIKit
import SnapKit

protocol EmailCellOutput: AnyObject, CloudEmailAttachmentViewModelOutput { }

final class EmailCell: BaseTableViewCell<EmailCellViewModel> {

    // MARK: - SubTypes

    private enum Constants {
        static let mainImageWidthHeight = 45
        static let leadingForSenderTitleText = 69 - 16
        static let cloudNewEmailBackViewWidth = 49
        static let emailTitleAndTextHeight = 17
        static let topSpaceToIconsStack = 3.5
        static let collectionViewHeght: CGFloat = 22
        static let cloudNewEmailBackViewCornerRadius: CGFloat = 9
    }

    private(set) lazy var backView: UIView = {
        let view = UIView()
        return view
    }()

    private(set) lazy var avatarImage: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        return view
    }()

    private(set) lazy var emailSender: UILabel = {
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

    private(set) lazy var emailText: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.lineBreakMode = .byTruncatingTail
        return view
    }()

    private(set) lazy var emailDate: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        return view
    }()

    private(set) lazy var iconsAndDateStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = UIHelper.Margins.small4px
        return view
    }()

    private(set) lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()

    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(cellType: CloudEmailAttachmentCollectionViewCell.self)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isUserInteractionEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .none
        collectionView.isScrollEnabled = false
        return collectionView
    }()

    private(set) lazy var cloudNewEmailBackView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.cloudNewEmailBackViewCornerRadius
        return view
    }()

    private(set) lazy var cloudNewEmailTitle: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        return view
    }()

    private var cellWidths = [CGFloat]()

    // MARK: - Public properties

    weak var output: EmailCellOutput?

    // MARK: - Public methods

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func update(with viewModel: EmailCellViewModel) {
        contentView.backgroundColor = viewModel.backColor
        avatarImage.image = viewModel.avatarImage
        emailSender.attributedText = viewModel.emailSender
        emailTitle.attributedText = viewModel.emailTitle
        emailText.attributedText = viewModel.emailText
        emailDate.attributedText = viewModel.emailDate

        iconsAndDateStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        if let iconsViews = viewModel.allIconViewsForOneCell {
            for oneIconView in iconsViews {
                iconsAndDateStackView.addArrangedSubview(oneIconView)
            }
        }
        iconsAndDateStackView.addArrangedSubview(emailDate)

        if viewModel.isNewEmailIconDisplaying {
            cloudNewEmailBackView.isHidden = false
            cloudNewEmailBackView.backgroundColor = viewModel.newEmailCloudBackColor
            cloudNewEmailTitle.attributedText = viewModel.newEmailCloudTitle
        } else {
            cloudNewEmailBackView.isHidden = true
        }

        cellWidths = viewModel.widths
        updateConstraints(insets: viewModel.insets)
        self.separatorInset = viewModel.separatorInset

        collectionView.reloadData()
    }

    override func composeSubviews() {
        cloudNewEmailBackView.addSubview(cloudNewEmailTitle)
        [avatarImage, emailSender, emailTitle, emailText, iconsAndDateStackView, cloudNewEmailBackView, collectionView].forEach { backView.addSubview($0) }
        contentView.addSubview(backView)
        backgroundColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 1.0
        backView.addGestureRecognizer(longPressGesture)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapAtCell(_:)))
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(tapGestureRecognizer)
    }

    override func setConstraints() {
        backView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }

        avatarImage.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.height.equalTo(Constants.mainImageWidthHeight)
        }

        emailSender.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(backView.snp.leading).offset(Constants.leadingForSenderTitleText)
            $0.trailing.lessThanOrEqualTo(iconsAndDateStackView.snp.leading).inset(UIHelper.Margins.small4px)
            $0.height.equalTo(UIHelper.Margins.large23px)
        }
        emailSender.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        iconsAndDateStackView.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.centerY.equalTo(emailSender.snp.centerY)
        }

        emailTitle.snp.makeConstraints {
            $0.top.equalTo(emailSender.snp.bottom).offset(UIHelper.Margins.small2px)
            $0.leading.equalTo(backView.snp.leading).offset(Constants.leadingForSenderTitleText)
            $0.trailing.lessThanOrEqualTo(cloudNewEmailBackView.snp.leading)
            $0.height.equalTo(Constants.emailTitleAndTextHeight)
        }

        cloudNewEmailBackView.snp.makeConstraints {
            $0.centerY.equalTo(emailTitle.snp.centerY)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(Constants.cloudNewEmailBackViewWidth)
            $0.height.equalTo(UIHelper.Margins.medium18px)
        }

        cloudNewEmailTitle.snp.makeConstraints{
            $0.center.equalToSuperview()
        }

        emailText.snp.makeConstraints {
            $0.top.equalTo(emailTitle.snp.bottom)
            $0.leading.equalTo(emailTitle.snp.leading)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(Constants.emailTitleAndTextHeight)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(emailText.snp.bottom).offset(UIHelper.Margins.medium8px)
            $0.leading.equalTo(emailTitle.snp.leading)
            $0.trailing.bottom.equalToSuperview()
            $0.height.equalTo(UIHelper.Margins.large22px)

        }
    }

    // MARK: - Actions
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


// MARK: - UICollectionViewDelegateFlowLayout

extension EmailCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard indexPath.item < cellWidths.count else { return CGSize.zero }
        let cellWidth = cellWidths[indexPath.item]

        return CGSize(width: cellWidth, height: Constants.collectionViewHeght)
    }
}

// MARK: - UICollectionViewDataSource
extension EmailCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.items.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let item = viewModel?.items[indexPath.item].base

        if let vm = item as? CloudEmailAttachmentViewModel {
            let cell = collectionView.dequeueReusableCell(for: indexPath) as CloudEmailAttachmentCollectionViewCell
            cell.viewModel = vm
            cell.viewModel?.output = output
            return cell
        } else {
            return UICollectionViewCell()
        }
    }

}
