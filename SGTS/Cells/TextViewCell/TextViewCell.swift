//
//  TextViewCell.swift
//  SGTS
//
//  Created by Roman Vakulenko on 06.05.2024.
//

import UIKit
import SnapKit

final class TextViewCell: BaseTableViewCell<TextViewCellViewModel> {

    // MARK: - Public properties
    var textViewTextDidChange: (() -> Void)?

    // MARK: - Private properties

    private enum Constants {
//        static let heightOfTextView = 32 //in figma установлена высота поля текста как 56, но для 1ой строки этого много, т.к. при вводе второй строки ячейка уменьшается по высоте - подобрал оптимальное значение для одной строки, чтобы ячейка только увеличивалась бы по высоте при вводе 2ой строки
        static let heightOfSignatureTextView = 176
        static let leftRightTextContainerInset12px: CGFloat = 12
        static let topBottomTextContainerInset16px: CGFloat = 16
    }

    // MARK: - SubTypes

    private(set) lazy var backView: UIView = {
        let view = UIView()
        return view
    }()

    private(set) lazy var textView: UITextView = {
        let view = UITextView()
        view.textAlignment = .left
        view.textContainer.lineBreakMode = .byWordWrapping
        view.delegate = self
        view.isScrollEnabled = false
        return view
    }()

    private var isTextInFocus = false
    private var hasTextViewEditingStarted = false 
    private var placeholderForView = NSAttributedString()
    private lazy var signature: String = {
        let signature = UserDefaults.standard.string(forKey: GlobalConstants.userSignature) ?? ""
//        let signature = "\n\n\((UserDefaults.standard.string(forKey: GlobalConstants.userSignature)) ?? "")"
        return signature
    }()

    // MARK: - Public methods
    
    override func update(with viewModel: TextViewCellViewModel) {
        backView.backgroundColor = viewModel.backColor

        textView.textContainerInset = UIEdgeInsets(
            top: 3.5,
            left: Constants.leftRightTextContainerInset12px,
            bottom: 0,
            right: Constants.leftRightTextContainerInset12px) //был баг с отступом - этим вылечил

        //signature не установлена - только placeholder
        if viewModel.isCreatingNewEmail && signature == "" {
            placeholderForView = viewModel.placeholder ?? NSAttributedString()
            textView.attributedText = placeholderForView // только placeholder
        }
        //signature установлена (текст пустой) - placeholder.string + "\n\n" + signature
        if viewModel.isCreatingNewEmail && signature != "" {
            textView.attributedText = viewModel.attributedText
        }
        //signature установлена, текст != "placeholder\n\nSignature"
        if viewModel.isCreatingNewEmail &&
            viewModel.attributedText.string != (getString(.newEmailCreateTextViewPlaceholder) + "\n\n" + signature) {
            textView.attributedText = viewModel.attributedText //текст + "\n\n" + signature
        }

        if viewModel.isMakingSignature && viewModel.attributedText.string.isEmpty { //for UserProfileSetSignature
            placeholderForView = viewModel.placeholder ?? NSAttributedString()
            textView.attributedText = placeholderForView

            textView.textContainerInset = UIEdgeInsets(
                top: Constants.topBottomTextContainerInset16px,
                left: Constants.leftRightTextContainerInset12px,
                bottom: 0,
                right: Constants.leftRightTextContainerInset12px) //был баг с отступом - этим вылечил

            textView.snp.remakeConstraints {
                $0.leading.trailing.top.bottom.equalToSuperview()
                $0.height.equalTo(Constants.heightOfSignatureTextView)
            }
        } else if viewModel.isMakingSignature {
            textView.attributedText = viewModel.attributedText
            textView.textContainerInset = UIEdgeInsets(
                top: Constants.topBottomTextContainerInset16px,
                left: Constants.leftRightTextContainerInset12px,
                bottom: 0,
                right: Constants.leftRightTextContainerInset12px) //был баг с отступом - этим вылечил
        }
        
        if viewModel.borderColor != nil {
            textView.layer.cornerRadius = UIHelper.Margins.medium8px
            textView.layer.borderWidth = viewModel.borderWidth ?? 0
            textView.layer.borderColor = viewModel.borderColor?.cgColor
        }
        
        textView.isUserInteractionEnabled = viewModel.isUserInteractionEnabled ?? false
        textView.isEditable = viewModel.isEditable ?? false
        textView.isScrollEnabled = viewModel.isScrollEnabled ?? false
        textView.showsVerticalScrollIndicator = viewModel.showsVerticalScrollIndicator ?? false
        
        updateConstraints(insets: viewModel.insets)
        layoutIfNeeded()
    }
    
    override func composeSubviews() {
        backView.addSubview(textView)
        contentView.addSubview(backView)
        backgroundColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD
    }

    override func setConstraints() {
        backView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }

        textView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
            $0.height.equalTo(Constants.heightOfSignatureTextView)
        }
    }

//    func setNewTextViewHeight(height: CGFloat) {
//        textView.snp.updateConstraints {
//            $0.height.equalTo(height)
//            textViewTextDidChange?()
//        }
//    }

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

    private func updateTextViewHeight() {
        let size = textView.bounds.size
        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            textView.snp.updateConstraints {
                $0.height.equalTo(newSize.height)
            }
            textViewTextDidChange?()
        }
        textView.scrollRangeToVisible(textView.selectedRange)
    }

    private func setCursorToEndOfText(_ textView: UITextView) {
        if let text = textView.attributedText {
            textView.selectedRange = NSMakeRange(text.length, 0)
        }
    }
}

// MARK: - UITextViewDelegate

extension TextViewCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if hasTextViewEditingStarted == false && textView.attributedText == placeholderForView {
            isTextInFocus = true
            self.textView.text = ""
            viewModel?.onChangeText(currentText: "")
            hasTextViewEditingStarted = true
        } else {
            if textView.attributedText == placeholderForView {
                textView.text = ""
            }
            setCursorToEndOfText(self.textView)
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.attributedText = placeholderForView
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let textRange = Range(range, in: currentText) else { return false }

        let updatedText = currentText.replacingCharacters(in: textRange, with: text)

        viewModel?.onChangeText(currentText: updatedText)

        // Вызов метода для обновления высоты textView
        updateTextViewHeight()

        return true
    }
}


