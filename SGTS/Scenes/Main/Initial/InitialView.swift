//
//  InitialView.swift
// 01.04.2024.
//

import UIKit
import SnapKit

protocol InitialViewOutput: AnyObject {

}

protocol InitialViewLogic: UIView {
    func update(viewModel: InitialModel.ViewModel)
    func displayWaitIndicator(viewModel: InitialFlow.OnWaitIndicator.ViewModel)
    
    var output: InitialViewOutput? { get set }
}


final class InitialView: UIView, InitialViewLogic, SpinnerDisplayable {

    // MARK: - Private properties

    private enum Constants {
        static let huge60px: CGFloat = 60
        static let logoSize: CGFloat = 124
    }

    private lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.shared.isLight ? UIHelper.Color.blue : UIHelper.Color.blackLightD
        return view
    }()

    private let imgLogo: UIImageView = {
        let imgLogo = UIImageView()
        return imgLogo
    }()

    private lazy var companyName: UILabel = {
        var lbl = UILabel()
        lbl.textAlignment = .center
        return lbl
    }()

    private lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        return view
    }()

    // MARK: - Init

    private(set) var viewModel: InitialModel.ViewModel?

    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal Methods

    weak var output: InitialViewOutput?

    // MARK: - Public Methods

    func update(viewModel: InitialModel.ViewModel) {
        self.viewModel = viewModel
        backView.layer.backgroundColor = viewModel.backColor.cgColor
        imgLogo.image = viewModel.imgLogo

        companyName.attributedText = viewModel.title
        progressView.progressTintColor = viewModel.progressTintColor
        progressView.trackTintColor = viewModel.trackTintColor
        progressView.layer.cornerRadius = UIHelper.Margins.large24px
    }

    func displayWaitIndicator(viewModel: InitialFlow.OnWaitIndicator.ViewModel) {

    }

    // MARK: - Private Methods

    private func configure() {
        addSubviews()
        configureConstraints()
        backgroundColor = .none
    }

    private func addSubviews() {
        self.addSubview(backView)
        [imgLogo, companyName, progressView].forEach { backView.addSubview($0)}
    }

    private func configureConstraints() {
        backView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }

        imgLogo.snp.makeConstraints {
            $0.bottom.equalTo(backView.snp.centerY)
            $0.centerX.equalTo(backView.snp.centerX)
            $0.width.equalTo(Constants.logoSize)
            $0.height.equalTo(Constants.logoSize)
        }

        companyName.snp.makeConstraints {
            $0.top.equalTo(imgLogo.snp.bottom).offset(UIHelper.Margins.medium16px)
            $0.centerX.equalTo(backView.snp.centerX)
        }

        progressView.snp.makeConstraints {
            $0.leading.equalTo(backView.snp.leading).offset(Constants.huge60px)
            $0.trailing.equalTo(backView.snp.trailing).inset(Constants.huge60px)
            $0.height.equalTo(UIHelper.Margins.medium8px)
            $0.bottom.equalTo(backView.snp.bottom).inset(UIHelper.Margins.huge40px)
        }
    }
}

