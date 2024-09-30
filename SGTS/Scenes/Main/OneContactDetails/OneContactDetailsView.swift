//
//  OneContactDetailsView.swift
//  SGTS
//
//  Created by Roman Vakulenko on 02.04.2024.
//

import UIKit
import SnapKit

protocol OneContactDetailsViewOutput: AnyObject {
    func didTapAtEmailAddress()
    func didTapAtPhone()
}

protocol OneContactDetailsViewLogic: UIView {
    func update(viewModel: OneContactDetailsModel.ViewModel)
    //    func displayWaitIndicator(viewModel: OneContactDetailsFlow.OnWaitIndicator.ViewModel)
    
    var output: OneContactDetailsViewOutput? { get set }
}


final class OneContactDetailsView: UIView, OneContactDetailsViewLogic {
    
    private enum Constants {
        static let huge62px: CGFloat = 62
        static let avatarSize: CGFloat = 124
        static let avatarRadius40px: CGFloat = UIHelper.Margins.huge40px
    }
    
    private lazy var backView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var separatorView: UIView = {
        let line = UIView()
        return line
    }()
    
    private lazy var avatar: UIImageView = {
        let imgLogo = UIImageView()
        return imgLogo
    }()
    
    private lazy var fullName: UILabel = {
        var lbl = UILabel()
        lbl.textAlignment = .center
        return lbl
    }()
//
    private lazy var emailTitle: UILabel = {
        var lbl = UILabel()
        return lbl
    }()

    private lazy var emailAddress: UILabel = {
        var lbl = UILabel()
        return lbl
    }()

    private(set) lazy var emailHorizontalStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = UIHelper.Margins.small2px
        return view
    }()
//
    private lazy var phoneTitle: UILabel = {
        var lbl = UILabel()
        return lbl
    }()

    private lazy var phoneNumber: UILabel = {
        var lbl = UILabel()
        return lbl
    }()

    private(set) lazy var phoneHorizontalStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = UIHelper.Margins.small2px
        return view
    }()
//
    private lazy var iinTitle: UILabel = {
        var lbl = UILabel()
        return lbl
    }()

    private lazy var iin: UILabel = {
        var lbl = UILabel()
        return lbl
    }()

    private(set) lazy var iinHorizontalStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = UIHelper.Margins.small2px
        return view
    }()
//
    private(set) lazy var verticatStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = UIHelper.Margins.medium16px
        return view
    }()

    
    // MARK: - Init
    
    private(set) var viewModel: OneContactDetailsModel.ViewModel?
    
    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal Methods
    
    weak var output: OneContactDetailsViewOutput?
    
    // MARK: - Actions
    
    @objc func didTapAtEmailAddress(_: UITapGestureRecognizer) {
        output?.didTapAtEmailAddress()
    }

    @objc func didTapAtPhone(_: UITapGestureRecognizer) {
        output?.didTapAtPhone()
    }

    // MARK: - Public Methods
    
    func update(viewModel: OneContactDetailsModel.ViewModel) {
        self.viewModel = viewModel
        backgroundColor = viewModel.backColor
        backView.backgroundColor = viewModel.backColor
        
        separatorView.layer.borderWidth = UIHelper.Margins.small1px
        separatorView.layer.borderColor = viewModel.separatorColor.cgColor
        
        avatar.image = viewModel.avatarImg
        avatar.layer.cornerRadius = Constants.avatarRadius40px
        fullName.attributedText = viewModel.fullName

        emailTitle.attributedText = viewModel.emailTitle
        emailAddress.attributedText = viewModel.emailAddress

        emailHorizontalStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        emailHorizontalStackView.addArrangedSubview(emailTitle) //1.1
        emailHorizontalStackView.addArrangedSubview(emailAddress) //1.2
//
        phoneTitle.attributedText = viewModel.phoneTitle
        phoneNumber.attributedText = viewModel.phoneNumber

        phoneHorizontalStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        phoneHorizontalStackView.addArrangedSubview(phoneTitle) //2.1
        phoneHorizontalStackView.addArrangedSubview(phoneNumber) //2.2
//
        iinTitle.attributedText = viewModel.iinTitle
        iin.attributedText = viewModel.iin

        iinHorizontalStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        iinHorizontalStackView.addArrangedSubview(iinTitle) //3.1
        iinHorizontalStackView.addArrangedSubview(iin) //3.2
//
        verticatStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        verticatStackView.addArrangedSubview(emailHorizontalStackView) //1
        verticatStackView.addArrangedSubview(phoneHorizontalStackView) //2
        verticatStackView.addArrangedSubview(iinHorizontalStackView) //3
    }

    // MARK: - Private Methods
    
    private func configure() {
        addSubviews()
        configureConstraints()

        let emailTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapAtEmailAddress(_:)))
        emailHorizontalStackView.isUserInteractionEnabled = true
        emailAddress.isUserInteractionEnabled = true
        emailAddress.addGestureRecognizer(emailTapGestureRecognizer)

        let phoneTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapAtPhone(_:)))
        phoneNumber.isUserInteractionEnabled = true
        phoneNumber.addGestureRecognizer(phoneTapGestureRecognizer)
    }
    
    private func addSubviews() {
        self.addSubview(backView)
        [emailHorizontalStackView, phoneHorizontalStackView, iinHorizontalStackView, ].forEach { verticatStackView.addArrangedSubview($0) }
        [separatorView, avatar, fullName, verticatStackView ].forEach { backView.addSubview($0)}
    }
    
    private func configureConstraints() {
        let view = self
        backView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints {
            $0.top.equalTo(backView.snp.top)
            $0.leading.equalTo(backView.snp.leading)
            $0.trailing.equalTo(backView.snp.trailing)
            $0.height.equalTo(UIHelper.Margins.small1px)
        }
        
        avatar.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(Constants.avatarSize * 2)
            $0.centerX.equalTo(backView.snp.centerX)
            $0.width.equalTo(Constants.avatarSize)
            $0.height.equalTo(Constants.avatarSize)
        }

        fullName.snp.makeConstraints {
            $0.top.equalTo(avatar.snp.bottom).offset(UIHelper.Margins.medium16px)
            $0.centerX.equalTo(backView.snp.centerX)
        }
        
        verticatStackView.snp.makeConstraints {
            $0.top.equalTo(fullName.snp.bottom).offset(Constants.huge62px)
            $0.leading.equalTo(backView.snp.leading).offset(UIHelper.Margins.medium16px)
            $0.trailing.equalTo(backView.snp.trailing).inset(UIHelper.Margins.medium16px)
        }
    }
}
