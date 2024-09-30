//
//  TextCellWithTitleAtBorder.swift
//  SGTS
//
//  Created by Roman Vakulenko on 09.04.2024.
//

import UIKit
import SnapKit


final class TextCellWithTitleAtBorder: BaseTableViewCell<TextCellWithTitleAtBorderViewModel> {

    private enum Constants {
        static let padding10px: CGFloat = 10
        static let medium15px: CGFloat = 15
    }

    // MARK: - SubTypes

    private let backView: UIView = {
        let view = UIView()
        return view
    }()

    private let borderTitle: UILabel = {
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
        view.layer.cornerRadius = UIHelper.Margins.medium8px
        view.isSecureTextEntry = true
        let paddingView = UIView(frame: CGRect(x: 0,
                                               y: 0,
                                               width: Constants.padding10px,
                                               height: view.frame.height))
        view.leftView = paddingView
        view.leftViewMode = .always
        return view
    }()

    // MARK: - Public methods

    override func update(with viewModel: TextCellWithTitleAtBorderViewModel) {
        borderTitleBackView.backgroundColor = viewModel.borderTitleBackground
        borderTitle.attributedText = viewModel.borderTitle

        textInputField.layer.borderWidth = UIHelper.Margins.small1px
        textInputField.layer.borderColor = viewModel.borderColor.cgColor
        textInputField.keyboardType = viewModel.keyboardType ?? .default
        textInputField.attributedPlaceholder = viewModel.placeholder

        if viewModel.isPasswordFieldActiveNeedsForConfirmPassword == true,
           containsExactlyFourDigits(input: viewModel.password ?? "") {
            textInputField.isUserInteractionEnabled = true
            textInputField.text = viewModel.password
        } else {
            textInputField.text = nil
            textInputField.isUserInteractionEnabled = false
        }

        NotificationCenter.default.removeObserver(self)
        if let notification = viewModel.switchStateNotificationName {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(changeActiveState(_:)),
                                                   name: notification,
                                                   object: nil)
        }
        updateTextFieldState(isActive: viewModel.isPasswordFieldActiveNeedsForConfirmPassword) //start state
        updateConstraints(insets: viewModel.insets)
        layoutIfNeeded()
    }

    // MARK: - Private methods
    override func composeSubviews() {
        backgroundColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD
        contentView.addSubview(backView)
        backView.addSubview(borderTitleBackView)
        borderTitleBackView.addSubview(borderTitle)
        backView.addSubview(textInputField)
        backView.bringSubviewToFront(borderTitleBackView)

        textInputField.delegate = self
    }

    override func setConstraints() {
        backView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }

        textInputField.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(backView.snp.top)
            $0.height.equalTo(UIHelper.Margins.huge56px)
        }

        borderTitleBackView.snp.makeConstraints {
            $0.centerY.equalTo(textInputField.snp.top)
            $0.leading.equalTo(textInputField.snp.leading).offset(UIHelper.Margins.medium8px)
            $0.height.equalTo(Constants.medium15px)
        }

        borderTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(UIHelper.Margins.small4px)
            $0.trailing.equalToSuperview().inset(UIHelper.Margins.small4px)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Private methods
    private func containsExactlyFourDigits(input: String) -> Bool {
        if viewModel?.isOnlyDigits == false {
            return true
        }
        let pattern = "^\\d{4}$"
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let range = NSRange(location: 0, length: input.utf16.count)
            let matches = regex.matches(in: input, options: [], range: range)
            return matches.count == 1
        } catch {
            print("Ошибка при создании регулярного выражения: \(error)")
            return false
        }
    }


    @objc private func changeActiveState(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any],
              let isActiveKey = viewModel?.isActiveKey,
              let isActive = userInfo[isActiveKey] as? Bool else {
            return
        }
        updateTextFieldState(isActive: isActive)
    }

    private func updateTextFieldState(isActive: Bool) {
        textInputField.isUserInteractionEnabled = isActive //updated state
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

// MARK: - UITextFieldDelegate

extension TextCellWithTitleAtBorder: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text as NSString?
        var newText: NSString?

        if let currentTextLength = currentText?.length {
            switch viewModel?.type {
            case .only4Digits:
                if string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil, // only digits
                   let maxCharacters = viewModel?.maxCharacters,
                   currentTextLength - range.length + string.count <= maxCharacters { // no longer than maxCharacters
                    newText = currentText?.replacingCharacters(in: range, with: string) as NSString?
                } else {
                    newText = currentText
                }
            case .noLimits:
                newText = currentText?.replacingCharacters(in: range, with: string) as NSString?
            default:
                break
            }
        } else {
            newText = currentText
        }

        viewModel?.onChangeText(currentText: newText as String?)
        return newText != currentText
    }
}
