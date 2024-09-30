//
//  TextFieldCell.swift
//  SGTS
//
//  Created by Roman Vakulenko on 24.04.2024.
//

import UIKit
import SnapKit


final class TextFieldCell: BaseTableViewCell<TextFieldCellViewModel> {

    // MARK: - SubTypes

    private(set) lazy var backView: UIView = {
        let view = UIView()
        return view
    }()

    private(set) lazy var textField: UITextField = {
        let view = UITextField()
        view.textAlignment = .left
        return view
    }()


    // MARK: - Public methods

    override func update(with viewModel: TextFieldCellViewModel) {
        textField.attributedText = viewModel.text
        textField.isUserInteractionEnabled = viewModel.isUserInteractionEnabled ?? false

        backView.backgroundColor = viewModel.backColor
        updateConstraints(insets: viewModel.insets)
        layoutIfNeeded()
    }

    override func composeSubviews() {
        backView.addSubview(textField)
        contentView.addSubview(backView)
        backgroundColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD
    }

    override func setConstraints() {
        backView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }

        textField.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
    }

    // MARK: - Private methods

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


extension TextFieldCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string

        self.textField.text = updatedText
        viewModel?.onChangeText(currentText: updatedText)

        return true
    }
}


