//
//  AboutAppScreenView.swift
//  SGTS
//
//  Created by Roman Vakulenko on 24.06.2024.
//

import UIKit
import SnapKit

protocol AboutAppScreenViewOutput: AnyObject {
    func didTapCancel()
    func didFiveTapOnLogo()
}

protocol AboutAppScreenViewLogic: UIView {
    func update(viewModel: AboutAppScreenViewModel)
    var output: AboutAppScreenViewOutput? { get set }
}

final class AboutAppScreenView: UIView, AboutAppScreenViewLogic {

    // MARK: - Public properties

    private enum Constants {
        static let padding10px: CGFloat = 10
        static let medium15px: CGFloat = 15
        static let leadingForFirstLogo46px: CGFloat = 46
        static let topForFirstLogo: CGFloat = 17.68
        static let topForFirstLineText: CGFloat = 23.5
        static let leadingForFirstAndSecondLinesText: CGFloat = 39
        static let bottomForFirstLogo: CGFloat = 16.47
        static let firstLogoWidth: CGFloat = 46
        static let firstLogoHeight: CGFloat = 45.85

        static let secondLogoWidth: CGFloat = 85
        static let secondLogoHeight: CGFloat = 56
    }

    private lazy var grayView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()

    private lazy var whiteView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = UIHelper.Margins.large24px
        return view
    }()
//
    private lazy var titleOfWhiteView: UILabel = {
        var view = UILabel()
        return view
    }()
//
    private lazy var firstLogo: UIImageView = {
        var view = UIImageView()
        return view
    }()

    private lazy var branNameAndAppVersion: UILabel = {
        var view = UILabel()
        view.numberOfLines = 2
        return view
    }()
//
    private lazy var separatorView: UIView = {
        let line = UIView()
        return line
    }()
//
    private lazy var secondLogo: UIImageView = {
        var view = UIImageView()
        return view
    }()

    private lazy var copyRightsText: UILabel = {
        var view = UILabel()
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        return view
    }()
//
    private lazy var cancelButton: UIButton = {
        let btn = UIButton(type: .system)
        return btn
    }()

    private lazy var saveButton: UIButton = {
        let btn = UIButton(type: .system)
        return btn
    }()

    private(set) var viewModel: AboutAppScreenViewModel?

    // MARK: - Init

    deinit { }

    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    weak var output: AboutAppScreenViewOutput?
    
    // MARK: - Public Methods
    
    func update(viewModel: AboutAppScreenViewModel) {
        self.viewModel = viewModel
        grayView.layer.backgroundColor = viewModel.grayViewBackColor.cgColor

        whiteView.layer.backgroundColor = viewModel.backColorOfWhiteView.cgColor
        titleOfWhiteView.attributedText = viewModel.titleOfWhiteView

        firstLogo.image = viewModel.firstLogo
        branNameAndAppVersion.attributedText = viewModel.branNameAndAppVersion

        separatorView.layer.borderColor = viewModel.separatorColor.cgColor
        separatorView.layer.borderWidth = viewModel.separatorBorderWidth

        secondLogo.image = viewModel.secondLogo
        copyRightsText.attributedText = viewModel.copyRightsText

        cancelButton.setAttributedTitle(viewModel.cancelTitle, for: .normal)
    }

    // MARK: - Actions
    @objc func didTapCancel(_ sender: UIButton) {
        output?.didTapCancel()
    }

    // MARK: - Private Methods

    private func configure() {
        addSubviews()
        configureConstraints()
        cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        firstLogo.isUserInteractionEnabled = true
        let fiveTapGesture = UITapGestureRecognizer(target: self, action: #selector(didFiveTapOnLogo))
        fiveTapGesture.numberOfTapsRequired = 5
        firstLogo.addGestureRecognizer(fiveTapGesture)
    }

    @objc private func didFiveTapOnLogo() {
        Log.i("Five tap")
        output?.didFiveTapOnLogo()
    }
    
    private func addSubviews() {
        self.addSubview(grayView)
        grayView.addSubview(whiteView)
        [titleOfWhiteView, firstLogo, branNameAndAppVersion, separatorView,
         secondLogo, copyRightsText, cancelButton].forEach { whiteView.addSubview($0) }
    }

    private func configureConstraints() {
        let view = self

        grayView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }

        whiteView.snp.makeConstraints {
            $0.leading.equalTo(view.snp.leading).offset(UIHelper.Margins.large24px)
            $0.trailing.equalTo(view.snp.trailing).offset(-UIHelper.Margins.large24px)
            $0.center.equalToSuperview()
        }

        titleOfWhiteView.snp.makeConstraints {
            $0.top.equalTo(whiteView.snp.top).offset(UIHelper.Margins.large24px)
            $0.leading.equalTo(whiteView.snp.leading).offset(UIHelper.Margins.large24px)
            $0.trailing.equalTo(whiteView.snp.trailing).offset(-UIHelper.Margins.huge56px)
            $0.height.equalTo(UIHelper.Margins.large23px)
        }
//
        firstLogo.snp.makeConstraints {
            $0.top.equalTo(titleOfWhiteView.snp.bottom).offset(Constants.topForFirstLogo)
            $0.leading.equalToSuperview().offset(Constants.leadingForFirstLogo46px)
            $0.width.equalTo(Constants.firstLogoWidth)
            $0.height.equalTo(Constants.firstLogoHeight)
        }

        branNameAndAppVersion.snp.makeConstraints {
            $0.top.equalTo(titleOfWhiteView.snp.bottom).offset(Constants.topForFirstLineText)
            $0.leading.equalTo(firstLogo.snp.trailing).offset(Constants.leadingForFirstAndSecondLinesText)
            $0.trailing.equalTo(whiteView.snp.trailing).offset(-UIHelper.Margins.large24px)
        }
//
        separatorView.snp.makeConstraints {
            $0.top.equalTo(firstLogo.snp.bottom).offset(Constants.bottomForFirstLogo)
            $0.leading.equalTo(firstLogo.snp.trailing).offset(UIHelper.Margins.large24px)
            $0.trailing.equalTo(whiteView.snp.trailing).offset(-UIHelper.Margins.large24px)
        }
//
        secondLogo.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(UIHelper.Margins.medium16px)
            $0.leading.equalToSuperview().offset(UIHelper.Margins.large24px)
            $0.width.equalTo(Constants.secondLogoWidth)
            $0.height.equalTo(Constants.secondLogoHeight)
        }

        copyRightsText.snp.makeConstraints {
            $0.centerY.equalTo(secondLogo.snp.centerY)
            $0.leading.equalTo(secondLogo.snp.trailing).offset(UIHelper.Margins.large22px)
            $0.trailing.equalTo(whiteView.snp.trailing).offset(-UIHelper.Margins.large24px)
        }

        cancelButton.snp.makeConstraints {
            $0.top.equalTo(copyRightsText.snp.bottom).offset(UIHelper.Margins.medium16px)
            $0.trailing.equalToSuperview().offset(-UIHelper.Margins.large24px)
            $0.bottom.equalToSuperview().offset(-UIHelper.Margins.large24px)
        }
    }
}
