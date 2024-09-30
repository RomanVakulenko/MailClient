//
//  SendReportUpperView.swift
//  SGTS
//
//  Created by Roman Vakulenko on 01.07.2024.
//

import UIKit
import SnapKit

protocol SendReportUpperViewOutput: AnyObject {
    func useEnteredTextAt(subject: String?)
}

protocol SendReportUpperViewLogic: UIView {
    func update(viewModel: SendReportUpperModel.ViewModel)
//    func displayWaitIndicator(viewModel: NewEmailCreateHeaderFlow.OnWaitIndicator.ViewModel)
    var output: SendReportUpperViewOutput? { get set }
}


final class SendReportUpperView: UIView, SendReportUpperViewLogic {

    // MARK: - Public properties

    var viewModel: SendReportUpperModel.ViewModel?
    weak var output: SendReportUpperViewOutput?

    // MARK: - Private properties

    private enum Constants {
        static let emailAdressOffset: CGFloat = 67
    }

    private lazy var backView: UIView = {
        let view = UIView()
        return view
    }()

    private(set) lazy var subjectLabel: UILabel = {
        let view = UILabel()
        return view
    }()

    private(set) lazy var subjectText: UITextField = {
        let view = UITextField()
        view.delegate = self
        view.font = UIHelper.Font.RobotoRegular14
        return view
    }()
//
    private lazy var separatorUnderSubject: UIView = {
        let line = UIView()
        return line
    }()

    private(set) lazy var toLabel: UILabel = {
        let view = UILabel()
        return view
    }()

    private(set) lazy var toEmailAddress: UITextField = {
        let view = UITextField()
        view.textAlignment = .left
        view.font = UIHelper.Font.RobotoMedium14 // ", " - UIHelper.Font.RobotoRegular14
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//        view.delegate = self
        view.isUserInteractionEnabled = false
        return view
    }()

    private(set) lazy var addressBookIconForToField: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = false
        return view
    }()
    private lazy var viewUnderAddressBookIconAtToField: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
//
    private lazy var separatorUnderToTitle: UIView = {
        let line = UIView()
        return line
    }()

    private(set) lazy var copyLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        return view
    }()

    private(set) lazy var copyEmailAdresses: UITextField = {
        let view = UITextField()
        view.textAlignment = .left
        view.font = UIHelper.Font.RobotoMedium14 // ", " - UIHelper.Font.RobotoRegular14
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//        view.delegate = self
        view.isUserInteractionEnabled = false
        return view
    }()

    private(set) lazy var addressBookIconForCopyField: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = false
        return view
    }()

    private lazy var separatorUnderCopyTitle: UIView = {
        let line = UIView()
        return line
    }()

    // MARK: - Init

    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        configure()
        self.layer.backgroundColor = .none// нужно ли ?
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Public Methods
    func update(viewModel: SendReportUpperModel.ViewModel) {
        self.viewModel = viewModel
        self.layer.backgroundColor = viewModel.backColor.cgColor

        subjectLabel.attributedText = viewModel.subjectLabel
        subjectText.text = viewModel.subjectText
        separatorUnderSubject.backgroundColor = viewModel.separatorColor

        toLabel.attributedText = viewModel.toLabel
        toEmailAddress.text = viewModel.toEmailAddressesText
        toEmailAddress.textColor = viewModel.toCopyTextColor
        separatorUnderToTitle.backgroundColor = viewModel.separatorColor

        copyLabel.attributedText = viewModel.copyLabel
        copyEmailAdresses.textColor = viewModel.toCopyTextColor
        separatorUnderCopyTitle.backgroundColor = viewModel.separatorColor

        addressBookIconForToField.image = viewModel.toRectIcon
        addressBookIconForCopyField.image = viewModel.copyRectIcon

        updateConstraints(insets: viewModel.insets)
        layoutIfNeeded()
    }

    // MARK: - Actions
    //may be it will be needed later
//    @objc func didTapAddressBookIconForToField(_: UITapGestureRecognizer) {
//        output?.didTapAddressBookIcon(toOrCopyFieldTapped: SendReportUpperModel.AddressField.toField)
//    }
//
//    @objc func didTapAddressBookIconForCopyField(_: UITapGestureRecognizer) {
//        output?.didTapAddressBookIcon(toOrCopyFieldTapped: SendReportUpperModel.AddressField.copyField)
//    }
    // MARK: - Private Methods

    private func configure() {
        addSubviews()
        configureConstraints()
    }

    private func addSubviews() {
        self.addSubview(backView)
        [subjectLabel, subjectText, separatorUnderSubject,
         toLabel, toEmailAddress, addressBookIconForToField, viewUnderAddressBookIconAtToField, separatorUnderToTitle,
         copyLabel, copyEmailAdresses, addressBookIconForCopyField, separatorUnderCopyTitle].forEach { backView.addSubview($0) }
        //may be it will be needed later
//        let tapGestureRecognizerForToField = UITapGestureRecognizer(target: self, action: #selector(didTapAddressBookIconForToField(_:)))
//        addressBookIconForToField.addGestureRecognizer(tapGestureRecognizerForToField)
//
//        let tapGestureRecognizerForCopyField = UITapGestureRecognizer(target: self, action: #selector(didTapAddressBookIconForCopyField(_:)))
//        addressBookIconForCopyField.addGestureRecognizer(tapGestureRecognizerForCopyField)
    }

    private func configureConstraints() {
        backView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
//
        subjectLabel.snp.makeConstraints {
            $0.top.equalTo(backView.snp.top).offset(UIHelper.Margins.medium8px)
            $0.leading.equalTo(backView.snp.leading).offset(UIHelper.Margins.medium16px)
        }

        subjectText.snp.makeConstraints {
            $0.top.equalTo(backView.snp.top).offset(UIHelper.Margins.medium8px)
            $0.leading.equalTo(backView.snp.leading).offset(Constants.emailAdressOffset) //67
            $0.trailing.equalTo(backView.snp.trailing).inset(UIHelper.Margins.medium16px)
        }

        separatorUnderSubject.snp.makeConstraints {
            $0.top.equalTo(subjectLabel.snp.bottom).offset(UIHelper.Margins.medium8px)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(UIHelper.Margins.small1px)
        }
//
        toLabel.snp.makeConstraints {
            $0.top.equalTo(separatorUnderSubject.snp.bottom).offset(UIHelper.Margins.medium8px)
            $0.leading.equalTo(backView.snp.leading).offset(UIHelper.Margins.medium16px)
        }

        toEmailAddress.snp.makeConstraints {
            $0.centerY.equalTo(toLabel.snp.centerY)
            $0.leading.equalTo(backView.snp.leading).offset(Constants.emailAdressOffset) //67
            $0.trailing.equalTo(viewUnderAddressBookIconAtToField.snp.leading)
        }

        addressBookIconForToField.snp.makeConstraints {
            $0.centerY.equalTo(toLabel.snp.centerY)
            $0.trailing.equalTo(backView.snp.trailing).inset(UIHelper.Margins.medium16px)
            $0.width.height.equalTo(UIHelper.Margins.medium18px)
        }
        viewUnderAddressBookIconAtToField.snp.makeConstraints {
            $0.centerY.equalTo(toLabel.snp.centerY)
            $0.trailing.equalTo(backView.snp.trailing).inset(UIHelper.Margins.small4px)
            $0.height.equalTo(UIHelper.Margins.large30px)
            $0.width.equalTo(UIHelper.Margins.huge40px)
        }

        separatorUnderToTitle.snp.makeConstraints {
            $0.top.equalTo(toLabel.snp.bottom).offset(UIHelper.Margins.medium8px)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(UIHelper.Margins.small1px)
        }
//
        copyLabel.snp.makeConstraints {
            $0.top.equalTo(separatorUnderToTitle.snp.bottom).offset(UIHelper.Margins.medium8px)
            $0.leading.equalTo(backView.snp.leading).offset(UIHelper.Margins.medium16px)
        }

        copyEmailAdresses.snp.makeConstraints {
            $0.centerY.equalTo(copyLabel.snp.centerY)
            $0.leading.equalTo(backView.snp.leading).offset(Constants.emailAdressOffset) //67
            $0.trailing.equalTo(addressBookIconForCopyField.snp.leading).inset(UIHelper.Margins.small4px)
        }

        addressBookIconForCopyField.snp.makeConstraints {
            $0.centerY.equalTo(copyLabel.snp.centerY)
            $0.trailing.equalTo(backView.snp.trailing).inset(UIHelper.Margins.medium16px)
            $0.width.height.equalTo(UIHelper.Margins.medium18px)
        }

        separatorUnderCopyTitle.snp.makeConstraints {
            $0.top.equalTo(copyLabel.snp.bottom).offset(UIHelper.Margins.medium8px)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(UIHelper.Margins.small1px)
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


// MARK: - UITextFieldDelegate
extension SendReportUpperView: UITextFieldDelegate {

//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) {
//
//            if textField == self.subjectText {
//                self.subjectText.text = updatedText.lowercased()
//                output?.useEnteredTextAt(subject: self.subjectText.text)
//            }
//
////            if textField == self.toEmailAddress {
////                self.toEmailAddress.text = updatedText.lowercased()
////            }
//
////            if textField == self.copyEmailAddresses {
////                self.copyEmailAddresses.text = updatedText.lowercased()
////            }
//
//            output?.useEnteredTextAt(subject: self.subjectText.text)
////                toEmailAddressText: self.toEmailAddress.text,
////                copyEmailAddressesText: self.copyEmailAddresses.text)
//        }
//        return false
//    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text as NSString? else { return true }

        guard let cursorPosition = textField.selectedTextRange else { return true }
        let updatedText = currentText.replacingCharacters(in: range, with: string)

        if textField == self.subjectText {
            self.subjectText.text = updatedText.lowercased()
            output?.useEnteredTextAt(subject: self.subjectText.text)
        }

        output?.useEnteredTextAt(subject: self.subjectText.text)

        // Вычисляем новое положение курсора
        let currentCursorPosition = textField.offset(from: textField.beginningOfDocument, to: cursorPosition.start)
        let newCursorPosition: Int

        if string.isEmpty { // Если удаляем символ
            newCursorPosition = max(currentCursorPosition - 1, 0)
        } else { // Если вводим символ
            newCursorPosition = currentCursorPosition + string.count
        }

        // Устанавливаем новое положение курсора
        if let newPosition = textField.position(from: textField.beginningOfDocument, offset: newCursorPosition) {
            textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
        }

        return false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

