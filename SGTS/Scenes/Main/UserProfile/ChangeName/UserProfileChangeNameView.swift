//
//  UserProfileChangeNameView.swift
//  SGTS
//
//  Created by Roman Vakulenko on 24.06.2024.
//

import UIKit
import SnapKit

protocol UserProfileChangeNameViewOutput: AnyObject,
                                          UserProfileChangeNameViewModelOutput {
    func didTapCancel()
    func didTapSave()
}

protocol UserProfileChangeNameViewLogic: UIView {
    func update(viewModel: UserProfileChangeNameViewModel)
    func displayWaitIndicator(viewModel: UserProfileChangeNameFlow.OnWaitIndicator.ViewModel)

    var output: UserProfileChangeNameViewOutput? { get set }
}

final class UserProfileChangeNameView: UIView, UserProfileChangeNameViewLogic, SpinnerDisplayable {

    // MARK: - Public methods

    // MARK: - Public properties

    private enum Constants {
        static let padding10px: CGFloat = 10
        static let medium15px: CGFloat = 15
    }

    private lazy var grayView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()

    private lazy var changeNameView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = UIHelper.Margins.large24px
        return view
    }()
//
    private lazy var titleOfChangeNameView: UILabel = {
        var view = UILabel()
        return view
    }()
//
    private lazy var userNameSubtitle: UILabel = {
        var view = UILabel()
        return view
    }()

    private lazy var userFullName: UILabel = {
        var view = UILabel()
        return view
    }()
//
    private lazy var senderTitleAtBorder: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.sizeToFit()
        return view
    }()

    private let borderTitleBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private let textInputField: UITextField = {
        let view = UITextField()
        view.layer.borderWidth = UIHelper.Margins.small1px
        view.layer.cornerRadius = UIHelper.Margins.medium8px
        let paddingView = UIView(frame: CGRect(x: 0,
                                               y: 0,
                                               width: Constants.padding10px,
                                               height: view.frame.height))
        view.leftView = paddingView
        view.leftViewMode = .always
        return view
    }()

    private lazy var cancelButton: UIButton = {
        let btn = UIButton(type: .system)
        return btn
    }()

    private lazy var saveButton: UIButton = {
        let btn = UIButton(type: .system)
        return btn
    }()

    private(set) var viewModel: UserProfileChangeNameViewModel?

    // MARK: - Init

    deinit { }

    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    weak var output: UserProfileChangeNameViewOutput?
    
    // MARK: - Public Methods
    
    func update(viewModel: UserProfileChangeNameViewModel) {
        self.viewModel = viewModel
        grayView.layer.backgroundColor = viewModel.grayViewBackColor.cgColor

        changeNameView.layer.backgroundColor = viewModel.backColorOfChangeNameView.cgColor
        titleOfChangeNameView.attributedText = viewModel.titleOfChangeNameView

        userNameSubtitle.attributedText = viewModel.userNameSubtitle
        userFullName.attributedText = viewModel.userFullName
        senderTitleAtBorder.attributedText = viewModel.senderTitleAtBorder
        borderTitleBackView.layer.backgroundColor = viewModel.borderTitleBackColor.cgColor

        textInputField.text = viewModel.senderName
        textInputField.layer.borderColor = viewModel.borderColor.cgColor

        cancelButton.setAttributedTitle(viewModel.cancelTitle, for: .normal)
        saveButton.setAttributedTitle(viewModel.saveTitle, for: .normal)
    }
    
        func displayWaitIndicator(viewModel: UserProfileChangeNameFlow.OnWaitIndicator.ViewModel) {
            if viewModel.isShow {
                showSpinner()
            } else {
                hideSpinner()
            }
        }


    // MARK: - Actions
    @objc func didTapCancel(_ sender: UIButton) {
        output?.didTapCancel()
    }

    @objc func didTapSave(_ sender: UIButton) {
        output?.didTapSave()
    }

    // MARK: - Private Methods

    private func configure() {
        addSubviews()
        configureConstraints()

        cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
    }

    private func addSubviews() {
        self.addSubview(grayView)
        grayView.addSubview(changeNameView)
        [titleOfChangeNameView, userNameSubtitle, userFullName, textInputField, borderTitleBackView, cancelButton, saveButton].forEach{changeNameView.addSubview($0)}

        borderTitleBackView.addSubview(senderTitleAtBorder)
    }

    private func configureConstraints() {
        let view = self

        grayView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }

        changeNameView.snp.makeConstraints {
            $0.leading.equalTo(view.snp.leading).offset(UIHelper.Margins.medium16px)
            $0.trailing.equalTo(view.snp.trailing).offset(-UIHelper.Margins.medium16px)
            $0.center.equalToSuperview()
        }

        titleOfChangeNameView.snp.makeConstraints {
            $0.top.equalTo(changeNameView.snp.top).offset(UIHelper.Margins.large24px)
            $0.leading.equalTo(changeNameView.snp.leading).offset(UIHelper.Margins.large24px)
            $0.trailing.equalTo(changeNameView.snp.trailing).offset(-UIHelper.Margins.huge56px)
            $0.height.equalTo(UIHelper.Margins.large23px)
        }

        userNameSubtitle.snp.makeConstraints {
            $0.top.equalTo(titleOfChangeNameView.snp.bottom).offset(UIHelper.Margins.medium16px)
            $0.leading.equalToSuperview().offset(UIHelper.Margins.huge36px)
            $0.trailing.equalTo(changeNameView.snp.trailing).offset(-UIHelper.Margins.huge56px)
            $0.height.equalTo(UIHelper.Margins.large24px)
        }

        userFullName.snp.makeConstraints {
            $0.top.equalTo(userNameSubtitle.snp.bottom)
            $0.leading.equalToSuperview().offset(UIHelper.Margins.huge36px)
            $0.trailing.equalTo(changeNameView.snp.trailing).offset(-UIHelper.Margins.huge40px)
            $0.height.equalTo(UIHelper.Margins.large24px)
        }

        textInputField.snp.makeConstraints {
            $0.top.equalTo(userFullName.snp.bottom).offset(UIHelper.Margins.medium16px)
            $0.leading.equalToSuperview().offset(UIHelper.Margins.large24px)
            $0.trailing.equalToSuperview().offset(-UIHelper.Margins.large24px)
            $0.height.equalTo(UIHelper.Margins.huge56px)
        }

        borderTitleBackView.snp.makeConstraints {
            $0.centerY.equalTo(textInputField.snp.top)
            $0.leading.equalTo(textInputField.snp.leading).offset(UIHelper.Margins.medium8px)
            $0.height.equalTo(Constants.medium15px)
        }

        senderTitleAtBorder.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(UIHelper.Margins.small4px)
            $0.trailing.equalToSuperview().inset(UIHelper.Margins.small4px)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        cancelButton.snp.makeConstraints {
            $0.top.equalTo(textInputField.snp.bottom).offset(UIHelper.Margins.medium16px)
            $0.trailing.equalTo(saveButton.snp.leading).offset(-UIHelper.Margins.large24px)
        }

        saveButton.snp.makeConstraints {
            $0.top.equalTo(textInputField.snp.bottom).offset(UIHelper.Margins.medium16px)
            $0.trailing.equalToSuperview().offset(-UIHelper.Margins.large24px)
            $0.bottom.equalToSuperview().offset(-UIHelper.Margins.large32px)
        }

    }
}

// MARK: - UITextFieldDelegate
extension UserProfileChangeNameView: UITextFieldDelegate {
    func textField(_ textField: UITextField, 
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        viewModel?.onChangeText(currentText: (textField.text as NSString?)?.replacingCharacters(in: range, with: string))
        return true
    }
}

