//
//  OneEmailDetailsUpperView.swift
//  SGTS
//
//  Created by Roman Vakulenko on 22.04.2024.
//

import UIKit
import SnapKit

protocol OneEmailDetailsUpperViewOutput: AnyObject {
    func chevronOpenCloseAddressesTapped()
}

protocol OneEmailDetailsHeaderViewLogic: UIView {
    func update(viewModel: OneEmailDetailsUpperModel.ViewModel)
//    func displayWaitIndicator(viewModel: OneEmailDetailsHeaderFlow.OnWaitIndicator.ViewModel)

    var output: OneEmailDetailsUpperViewOutput? { get set }
}


final class OneEmailDetailsUpperView: UIView, OneEmailDetailsHeaderViewLogic {

    // MARK: - Public properties

    var viewModel: OneEmailDetailsUpperModel.ViewModel?
    weak var output: OneEmailDetailsUpperViewOutput?

    // MARK: - Private properties

    private enum Constants {
        static let emailTitleHeight = 72
        static let mainImageWidthHeight = 45
        static let collectionViewHeght: CGFloat = 22
        static let offset28pxForBottomSeparatorView: CGFloat = 28
    }

    private lazy var backView: UIView = {
        let view = UIView()
        return view
    }()

    private(set) lazy var oneEmailTitle: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.numberOfLines = 2
        lbl.setContentCompressionResistancePriority(.required, for: .vertical)
        return lbl
    }()

    private(set) lazy var receivedTitle: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()

    private(set) lazy var dateTimeSubTitle: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()

    private(set) lazy var attachmentIcon: UIImageView = {
        let view = UIImageView()
        view.isHidden = true
        return view
    }()

    private(set) lazy var mainImage: UIImageView = {
        let view = UIImageView()
        return view
    }()

    private(set) lazy var fromTitleAndAddress: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.lineBreakMode = .byTruncatingTail
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return view
    }()

    private(set) lazy var chevronOpenCloseMoreAdresses: UIButton = {
        let view = UIButton(type: .system)
        view.addTarget(self, action: #selector(didTapOpenCloseMoreAdressesChevron(_:)), for: .touchUpInside)
        return view
    }()

    private(set) lazy var toTitleAndAddresses: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.numberOfLines = 2
        view.lineBreakMode = .byTruncatingTail

        return view
    }()

    private(set) lazy var didSendTitle: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        return view
    }()

    private(set) lazy var dateTimeDidSend: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()

    private(set) lazy var didSendTitleAndDateTimeHorizontalStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = UIHelper.Margins.small2px
        return view
    }()


    private(set) lazy var didReceiveTitle: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        return view
    }()

    private(set) lazy var dateTimeDidReceive: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()

    private(set) lazy var didReceiveTitleDateTimeStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = UIHelper.Margins.small2px
        return view
    }()

    private(set) lazy var verticatStackViewFromToSendReceive: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()

    private lazy var bottomSeparatorView: UIView = {
        let line = UIView()
        return line
    }()

    private var toTitleAndAdressesNumberOfLines = 2
    private var areMoreAdressesShown = false
    private var shouldExpandAddresses = false
    private var didTapChevron = false
    private var isFirstLoad = true
    private var chevronImageAtAddresses = UIImage()

    // MARK: - Init

    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        configure()
        self.layer.backgroundColor = .none
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Actions
    @objc func didTapOpenCloseMoreAdressesChevron(_ sender: UIButton) {
        didTapChevron = true
        output?.chevronOpenCloseAddressesTapped()
    }

    // MARK: - Public Methods
    func update(viewModel: OneEmailDetailsUpperModel.ViewModel) {
        self.viewModel = viewModel
        backgroundColor = viewModel.backColor
        backView.backgroundColor = viewModel.backColor
        oneEmailTitle.attributedText = viewModel.oneEmailTitle
        receivedTitle.attributedText = viewModel.subTitleReceived
        dateTimeSubTitle.attributedText = viewModel.dateTimeSubTitle
        if viewModel.hasAttachments {
            attachmentIcon.isHidden = false
            attachmentIcon.image = viewModel.attachmentIcon
        }
        mainImage.image = viewModel.mainImage
        fromTitleAndAddress.attributedText = viewModel.fromTitleAndAdress
        toTitleAndAddresses.attributedText = viewModel.toTitleAndAdresses

        var updatedLinesForAllAddresses = 0
        if isFirstLoad && viewModel.neededLinesForAllAdresses >= 2 {
            isFirstLoad = false
            updatedLinesForAllAddresses = 2
            updateChevronImage()
        } else if !areMoreAdressesShown && viewModel.neededLinesForAllAdresses <= 2 && didTapChevron {
            updatedLinesForAllAddresses = 2
        } else if !areMoreAdressesShown && viewModel.neededLinesForAllAdresses > 2 && didTapChevron {
            updatedLinesForAllAddresses = 0
            shouldExpandAddresses = true
        } else if areMoreAdressesShown && toTitleAndAddresses.numberOfLines == 0 && didTapChevron {
            updatedLinesForAllAddresses = 2
            areMoreAdressesShown = false
            shouldExpandAddresses = false
        }

        toTitleAndAddresses.numberOfLines = updatedLinesForAllAddresses
        if viewModel.neededLinesForAllAdresses == 1 {
            bottomSeparatorView.snp.remakeConstraints {
                $0.top.equalTo(verticatStackViewFromToSendReceive.snp.bottom).offset(Constants.offset28pxForBottomSeparatorView) //for >=2 lines offset is 16px, for 1 - 28
                $0.height.equalTo(UIHelper.Margins.small1px)
                $0.leading.equalToSuperview().offset(-UIHelper.Margins.medium16px) //goes wider that backView
                $0.trailing.equalToSuperview().offset(UIHelper.Margins.medium16px)
                $0.bottom.equalToSuperview()
            }
        }

        verticatStackViewFromToSendReceive.arrangedSubviews.forEach { $0.removeFromSuperview() }
        verticatStackViewFromToSendReceive.addArrangedSubview(fromTitleAndAddress) //1 step
        fromTitleAndAddress.setContentCompressionResistancePriority(.required, for: .vertical)
        verticatStackViewFromToSendReceive.addArrangedSubview(toTitleAndAddresses) //2 step

        if shouldExpandAddresses && didTapChevron {
            showSendReceiveTimeStacks(viewModel: viewModel) // 3 + 4 steps
            areMoreAdressesShown = true
        }

        updateChevronImage()
        didTapChevron = false //for future tap

        bottomSeparatorView.layer.borderColor = viewModel.separatorColor.cgColor
        bottomSeparatorView.layer.borderWidth = UIHelper.Margins.small1px

        updateConstraints(insets: viewModel.insets)
        layoutIfNeeded()
    }

    // MARK: - Private Methods

    private func showSendReceiveTimeStacks(viewModel: OneEmailDetailsUpperModel.ViewModel) {
        didSendTitle.attributedText = viewModel.didSendTitle
        dateTimeDidSend.attributedText = viewModel.dateTimeDidSend

        didSendTitleAndDateTimeHorizontalStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        didSendTitleAndDateTimeHorizontalStack.addArrangedSubview(didSendTitle) //3.1
        didSendTitleAndDateTimeHorizontalStack.addArrangedSubview(dateTimeDidSend) //3.2

        didReceiveTitle.attributedText = viewModel.didReceiveTitle
        dateTimeDidReceive.attributedText = viewModel.dateTimeDidReceive

        didReceiveTitleDateTimeStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        didReceiveTitleDateTimeStackView.addArrangedSubview(didReceiveTitle) //4.1
        didReceiveTitleDateTimeStackView.addArrangedSubview(dateTimeDidReceive) //4.2
        didReceiveTitleDateTimeStackView.setContentCompressionResistancePriority(.required, for: .vertical)

        verticatStackViewFromToSendReceive.addArrangedSubview(didSendTitleAndDateTimeHorizontalStack) //3
        verticatStackViewFromToSendReceive.addArrangedSubview(didReceiveTitleDateTimeStackView) //4
    }

    private func updateChevronImage() {
        if areMoreAdressesShown {
            chevronImageAtAddresses = Theme.shared.isLight ? UIHelper.Image.chevronUpL : UIHelper.Image.chevronUpD
        } else {
            chevronImageAtAddresses = Theme.shared.isLight ? UIHelper.Image.chevronDownL : UIHelper.Image.chevronDownD
        }
        chevronOpenCloseMoreAdresses.setImage(chevronImageAtAddresses, for: .normal)
    }

    private func configure() {
        addSubviews()
        configureConstraints()
    }

    private func addSubviews() {
        self.addSubview(backView)
        [fromTitleAndAddress, toTitleAndAddresses, didSendTitleAndDateTimeHorizontalStack, didReceiveTitleDateTimeStackView].forEach { verticatStackViewFromToSendReceive.addArrangedSubview($0) }

        [oneEmailTitle, receivedTitle, dateTimeSubTitle, attachmentIcon, mainImage, chevronOpenCloseMoreAdresses, verticatStackViewFromToSendReceive, bottomSeparatorView].forEach { backView.addSubview($0) }
    }

    private func configureConstraints() {
        backView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.bottom.equalToSuperview()
        }

        oneEmailTitle.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(receivedTitle.snp.top).offset(-UIHelper.Margins.medium8px)
        }

        receivedTitle.snp.makeConstraints {
            $0.top.equalTo(oneEmailTitle.snp.bottom)
            $0.leading.equalToSuperview()
            $0.height.equalTo(UIHelper.Margins.medium16px)
        }

        dateTimeSubTitle.snp.makeConstraints {
            $0.top.equalTo(receivedTitle.snp.top)
            $0.leading.equalTo(receivedTitle.snp.trailing).offset(UIHelper.Margins.small2px)
            $0.trailing.lessThanOrEqualTo(attachmentIcon.snp.leading).inset(UIHelper.Margins.small2px) //for some space between
            $0.height.equalTo(UIHelper.Margins.medium16px)
        }

        attachmentIcon.snp.makeConstraints {
            $0.top.equalTo(receivedTitle.snp.top)
            $0.centerY.equalTo(dateTimeSubTitle.snp.centerY)
            $0.trailing.equalToSuperview()
            $0.height.width.equalTo(UIHelper.Margins.medium16px)
        }

        mainImage.snp.makeConstraints {
            $0.top.equalTo(receivedTitle.snp.bottom).offset(UIHelper.Margins.medium12px)
            $0.leading.equalToSuperview()
            $0.height.width.equalTo(Constants.mainImageWidthHeight)
        }

        verticatStackViewFromToSendReceive.snp.makeConstraints {
            $0.top.equalTo(mainImage.snp.top)
            $0.leading.equalTo(mainImage.snp.trailing).offset(UIHelper.Margins.medium8px)
            $0.trailing.lessThanOrEqualTo(chevronOpenCloseMoreAdresses.snp.leading).inset(UIHelper.Margins.small2px) //for some space between
        }

        chevronOpenCloseMoreAdresses.snp.makeConstraints {
            $0.top.equalTo(verticatStackViewFromToSendReceive.snp.top)
            $0.trailing.equalToSuperview()
            $0.height.width.equalTo(UIHelper.Margins.medium16px)
        }

        bottomSeparatorView.snp.makeConstraints {
            $0.top.equalTo(verticatStackViewFromToSendReceive.snp.bottom).offset(UIHelper.Margins.medium16px)
            $0.height.equalTo(UIHelper.Margins.small1px)
            $0.leading.equalToSuperview().offset(-UIHelper.Margins.medium16px) //goes wider that backView
            $0.trailing.equalToSuperview().offset(UIHelper.Margins.medium16px)
            $0.bottom.equalToSuperview()
        }
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

