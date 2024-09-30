//
//  LogInRegistrView.swift
//  SGTS
//
//  Created by Roman Vakulenko on 02.04.2024.
//

import UIKit
import SnapKit

protocol LogInRegistrViewOutput: AnyObject {
    func loadKeysTapped()
    func scanQRTapped()
}

protocol LogInRegistrViewLogic: UIView {
    func update(viewModel: LogInRegistrModel.ViewModel)
//    func displayWaitIndicator(viewModel: LogInRegistrFlow.OnWaitIndicator.ViewModel)

    var output: LogInRegistrViewOutput? { get set }
}


final class LogInRegistrView: UIView, LogInRegistrViewLogic {

    private enum Constants {
        static let huge88px: CGFloat = 88
        static let logoSize: CGFloat = 124
        static let cornerRadius8px: CGFloat = UIHelper.Margins.medium8px
    }

    private lazy var backView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var separatorView: UIView = {
        let line = UIView()
        return line
    }()

    private lazy var imgLogo: UIImageView = {
        let imgLogo = UIImageView()
        return imgLogo
    }()

    private lazy var companyName: UILabel = {
        var lbl = UILabel()
        lbl.textAlignment = .center
        return lbl
    }()

    private lazy var version: UILabel = {
        var lbl = UILabel()
        lbl.textAlignment = .center
        return lbl
    }()

    private lazy var loadKeysButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = Constants.cornerRadius8px
        return btn
    }()

    private lazy var scanQRButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.backgroundColor = .none
        btn.layer.cornerRadius = Constants.cornerRadius8px
        return btn
    }()
    

    // MARK: - Init

    private(set) var viewModel: LogInRegistrModel.ViewModel?

    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal Methods

    weak var output: LogInRegistrViewOutput?

    // MARK: - Actions

    @objc func buttonLoadKeys_touchUpInside(_ sender: UIButton) {
        output?.loadKeysTapped()
    }

    @objc func buttonScanQR_touchUpInside(_ sender: UIButton) {
        output?.scanQRTapped()
    }

    // MARK: - Public Methods

    func update(viewModel: LogInRegistrModel.ViewModel) {
        self.viewModel = viewModel
        backgroundColor = viewModel.backColor
        backView.backgroundColor = viewModel.backColor

        separatorView.layer.borderWidth = UIHelper.Margins.small1px
        separatorView.layer.borderColor = viewModel.separatorColor.cgColor

        imgLogo.image = viewModel.imgLogo
        companyName.attributedText = viewModel.companyName
               version.attributedText = viewModel.version

               loadKeysButton.setAttributedTitle(viewModel.loadKeysButton, for: .normal)
               loadKeysButton.layer.backgroundColor = UIHelper.Color.blue.cgColor
               loadKeysButton.layer.cornerRadius = Constants.cornerRadius8px

        scanQRButton.setAttributedTitle(viewModel.scanQRTitleButton, for: .normal)
        scanQRButton.layer.borderWidth = UIHelper.Margins.small1px
        scanQRButton.layer.borderColor = UIHelper.Color.blue.cgColor

        scanQRButton.layer.cornerRadius = Constants.cornerRadius8px
    }
    // MARK: - Private Methods

    private func configure() {
        addSubviews()
        configureConstraints()
        loadKeysButton.addTarget(self, action: #selector(buttonLoadKeys_touchUpInside(_:)), for: .touchUpInside)
        scanQRButton.addTarget(self, action: #selector(buttonScanQR_touchUpInside(_:)), for: .touchUpInside)
    }

    private func addSubviews() {
        self.addSubview(backView)
        [imgLogo, separatorView, companyName, version, loadKeysButton, scanQRButton].forEach { backView.addSubview($0)}
    }

    private func configureConstraints() {
        let view = self
        backView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        separatorView.snp.makeConstraints {
            $0.top.equalTo(backView.snp.top)
            $0.leading.equalTo(backView.snp.leading)
            $0.trailing.equalTo(backView.snp.trailing)
            $0.height.equalTo(UIHelper.Margins.small1px)
        }

        imgLogo.snp.makeConstraints {
//            $0.bottom.equalTo(backView.snp.centerY).inset(Constants.logoSize/2)
            $0.bottom.equalTo(view.snp.centerY)
            $0.centerX.equalTo(backView.snp.centerX)
            $0.width.equalTo(Constants.logoSize)
            $0.height.equalTo(Constants.logoSize)
        }

        companyName.snp.makeConstraints {
            $0.top.equalTo(imgLogo.snp.bottom).offset(UIHelper.Margins.medium16px)
            $0.centerX.equalTo(backView.snp.centerX)
        }

        version.snp.makeConstraints {
            $0.top.equalTo(companyName.snp.bottom)
            $0.centerX.equalTo(backView.snp.centerX)
        }

        loadKeysButton.snp.makeConstraints {
            $0.leading.equalTo(backView.snp.leading).offset(UIHelper.Margins.medium16px)
            $0.trailing.equalTo(backView.snp.trailing).inset(UIHelper.Margins.medium16px)
            $0.height.equalTo(UIHelper.Margins.huge56px)
            $0.bottom.equalTo(scanQRButton.snp.top).inset(-UIHelper.Margins.large24px)
        }

        scanQRButton.snp.makeConstraints {
            $0.leading.equalTo(backView.snp.leading).offset(UIHelper.Margins.medium16px)
            $0.trailing.equalTo(backView.snp.trailing).inset(UIHelper.Margins.medium16px)
            $0.height.equalTo(UIHelper.Margins.huge56px)
            $0.bottom.equalTo(backView.snp.bottom).inset(Constants.huge88px)
        }
    }
}
