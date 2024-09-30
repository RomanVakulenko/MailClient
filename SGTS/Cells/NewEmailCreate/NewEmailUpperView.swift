//
//  NewEmailUpperView.swift
//  SGTS
//
//  Created by Roman Vakulenko on 03.05.2024.
//

import UIKit
import SnapKit

protocol NewEmailCreateUpperViewOutput: AnyObject {
    func useCurrent(toEmailAdressText: String?,
                    copyEmailAdressesText: String?,
                    textThemeOfEmailText: String?,
                    isEmptyViewVisible: Bool)

    func didTapChevronOpenCloseMoreEmails(isEmptyViewVisible: Bool)
    func didTapAddressBookIcon(toOrCopyFieldTapped: NewEmailCreateUpperModel.AddressField)
}

protocol NewEmailCreateUpperViewLogic: UIView {
    func update(viewModel: NewEmailCreateUpperModel.ViewModel)
//    func displayWaitIndicator(viewModel: NewEmailCreateHeaderFlow.OnWaitIndicator.ViewModel)

    var output: NewEmailCreateUpperViewOutput? { get set }
}


final class NewEmailCreateUpperView: UIView, NewEmailCreateUpperViewLogic {

    // MARK: - Public properties

    var viewModel: NewEmailCreateUpperModel.ViewModel?
    weak var output: NewEmailCreateUpperViewOutput?

    // MARK: - Private properties

    private enum Constants {
        static let emailAdressOffset: CGFloat = 67
        static let emptyViewWithChevronHeight: CGFloat = 4 + 16 + 4
    }

    private lazy var backViewWithChevronDown: UIView = {
        let view = UIView()
        return view
    }()

    private(set) lazy var fromLabel: UILabel = {
        let view = UILabel()
        return view
    }()

    private(set) lazy var fromEmailAdress: UILabel = {
        let view = UILabel()
        return view
    }()

    private lazy var separatorViewUnderFromTitle: UIView = {
        let line = UIView()
        return line
    }()

    private(set) lazy var toLabel: UILabel = {
        let view = UILabel()
        return view
    }()

    private(set) lazy var toEmailAdress: UITextField = {
        let view = UITextField()
        view.textAlignment = .left
        view.font = UIHelper.Font.RobotoMedium14 // ", " - UIHelper.Font.RobotoRegular14
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.delegate = self
        return view
    }()

    private(set) lazy var addressBookIconForToField: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        return view
    }()

    private lazy var viewUnderAddressBookIconAtToField: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private lazy var separatorViewUnderToTitle: UIView = {
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
        view.delegate = self
        return view
    }()

    private(set) lazy var addressBookIconForCopyField: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        return view
    }()

    private lazy var viewUnderAddressBookIconAtCopyField: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private lazy var separatorViewUnderCopyTitle: UIView = {
        let line = UIView()
        return line
    }()

    private(set) lazy var titleThemeOfEmail: UILabel = {
        let view = UILabel()
        return view
    }()

    private(set) lazy var textThemeOfEmail: UITextField = {
        let view = UITextField()
        view.delegate = self
        view.font = UIHelper.Font.RobotoRegular14
        return view
    }()

    private lazy var separatorViewUnderThemeTitle: UIView = {
        let line = UIView()
        return line
    }()

    private(set) lazy var chevronButtonDown: UIButton = {
        let view = UIButton(type: .system)
        view.addTarget(self, action: #selector(didTapOpenCloseMoreAdressesChevron(_:)), for: .touchUpInside)
        return view
    }()
    private(set) lazy var underChevronButtonDown: UIButton = {
        let view = UIButton(type: .system)
        view.backgroundColor = .clear
        view.addTarget(self, action: #selector(didTapOpenCloseMoreAdressesChevron(_:)), for: .touchUpInside)
        return view
    }()

    private var emptyViewWithChevron: UIView?
    private var chevronButtonUp = UIButton(type: .system)
    private var underChevronButtonUp = UIButton(type: .system)
    private var isEmptyViewVisible = false
    private var textInEmailTextCell = String()
    
    // MARK: - Init

    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        configure()
        self.layer.backgroundColor = .none
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Public Methods
    func update(viewModel: NewEmailCreateUpperModel.ViewModel) {
        self.viewModel = viewModel
        self.layer.backgroundColor = viewModel.backColor.cgColor
        fromLabel.attributedText = viewModel.fromLabel
        toLabel.attributedText = viewModel.toLabel
        copyLabel.attributedText = viewModel.copyLabel
        titleThemeOfEmail.attributedText = viewModel.titleThemeOfEmail
        chevronButtonDown.setImage(viewModel.chevronButtonDown, for: .normal)
        self.isEmptyViewVisible = viewModel.isEmptyViewVisible ?? false


        if isEmptyViewVisible { //1.первый запуск идет в else (тк не видима - не нажимали шеврон), если нажали, то 2.
            toggleEmptyViewWithChevronUp()
        } else {
            toggleEmptyViewWithChevronUp()
            backViewWithChevronDown.backgroundColor = viewModel.backColor

            fromEmailAdress.attributedText = viewModel.fromEmailAdressText
            separatorViewUnderFromTitle.backgroundColor = viewModel.separatorColor

            toEmailAdress.text = viewModel.toEmailAddressesText
            copyEmailAdresses.text = viewModel.copyEmailAdressesText

            toEmailAdress.textColor = viewModel.toCopyTextColor
            copyEmailAdresses.textColor = viewModel.toCopyTextColor
            
            addressBookIconForToField.image = viewModel.toRectIcon
            addressBookIconForCopyField.image = viewModel.copyRectIcon

            separatorViewUnderToTitle.backgroundColor = viewModel.separatorColor
            separatorViewUnderCopyTitle.backgroundColor = viewModel.separatorColor

            textThemeOfEmail.text = viewModel.textThemeOfEmail
            textThemeOfEmail.textColor = Theme.shared.isLight ? UIHelper.Color.grayAlpha06 : UIHelper.Color.whiteStrong
            separatorViewUnderThemeTitle.backgroundColor = viewModel.separatorColor

            updateConstraints(insets: viewModel.insets)

            layoutIfNeeded()
        }
    }

    // MARK: - Actions
    @objc func didTapOpenCloseMoreAdressesChevron(_ sender: UIButton) {
        isEmptyViewVisible.toggle()
        output?.didTapChevronOpenCloseMoreEmails(isEmptyViewVisible: isEmptyViewVisible)
    }

    @objc func didTapAddressBookIconForToField(_: UITapGestureRecognizer) {
        output?.didTapAddressBookIcon(toOrCopyFieldTapped: NewEmailCreateUpperModel.AddressField.toField)
    }

    @objc func didTapAddressBookIconForCopyField(_: UITapGestureRecognizer) {
        output?.didTapAddressBookIcon(toOrCopyFieldTapped: NewEmailCreateUpperModel.AddressField.copyField)
    }
    // MARK: - Private Methods

    private func setupEmptyViewWithChevronUp() {
        let emptyViewWithChevron = UIView()
        emptyViewWithChevron.backgroundColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD

        let chevronButtonUp = UIButton(type: .system)
        chevronButtonUp.addTarget(self, action: #selector(didTapOpenCloseMoreAdressesChevron(_:)), for: .touchUpInside)
        chevronButtonUp.setImage(Theme.shared.isLight ? UIHelper.Image.chevronUpL : UIHelper.Image.chevronUpD, for: .normal)
        emptyViewWithChevron.addSubview(chevronButtonUp)

        let underChevronButtonUp = UIButton(type: .system)
        underChevronButtonUp.backgroundColor = .clear
        underChevronButtonUp.addTarget(self, action: #selector(didTapOpenCloseMoreAdressesChevron(_:)), for: .touchUpInside)
        emptyViewWithChevron.addSubview(underChevronButtonUp)

        self.addSubview(emptyViewWithChevron)
        emptyViewWithChevron.isHidden = true
        self.emptyViewWithChevron = emptyViewWithChevron
        self.chevronButtonUp = chevronButtonUp
        self.underChevronButtonUp = underChevronButtonUp
    }

    private func toggleEmptyViewWithChevronUp() {
        if isEmptyViewVisible {
            backViewWithChevronDown.removeFromSuperview()
            setupEmptyViewWithChevronUp()

            emptyViewWithChevron?.snp.remakeConstraints {
                $0.top.equalToSuperview()
                $0.leading.trailing.bottom.equalToSuperview()
                $0.height.equalTo(Constants.emptyViewWithChevronHeight)
            }
            chevronButtonUp.snp.remakeConstraints {
                $0.top.equalToSuperview().offset(UIHelper.Margins.small4px)
                $0.trailing.equalToSuperview().inset(UIHelper.Margins.medium16px)
                $0.width.equalTo(UIHelper.Margins.medium14px)
                $0.height.equalTo(UIHelper.Margins.medium16px)
            }
            underChevronButtonUp.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.trailing.equalToSuperview()
                $0.width.equalTo(UIHelper.Margins.huge40px)
                $0.height.equalTo(UIHelper.Margins.large24px)
            }
            self.layoutIfNeeded()
            emptyViewWithChevron?.isHidden = false
        } else {
            emptyViewWithChevron?.removeFromSuperview()
            emptyViewWithChevron = nil
            configure()
        }
    }

    private func configure() {
        addSubviews()
        configureConstraints()
    }

    private func addSubviews() {
        self.addSubview(backViewWithChevronDown)

        [fromLabel, fromEmailAdress, chevronButtonDown, underChevronButtonDown, separatorViewUnderFromTitle,
         toLabel, toEmailAdress, addressBookIconForToField, viewUnderAddressBookIconAtToField, separatorViewUnderToTitle,
         copyLabel, copyEmailAdresses, addressBookIconForCopyField, viewUnderAddressBookIconAtCopyField,  separatorViewUnderCopyTitle,
         titleThemeOfEmail, textThemeOfEmail, separatorViewUnderThemeTitle].forEach { backViewWithChevronDown.addSubview($0) }

        let tapGestureRecognizerForToField = UITapGestureRecognizer(target: self, action: #selector(didTapAddressBookIconForToField(_:)))
        viewUnderAddressBookIconAtToField.addGestureRecognizer(tapGestureRecognizerForToField)

        let tapGestureRecognizerForCopyField = UITapGestureRecognizer(target: self, action: #selector(didTapAddressBookIconForCopyField(_:)))
        viewUnderAddressBookIconAtCopyField.addGestureRecognizer(tapGestureRecognizerForCopyField)
    }

    private func configureConstraints() {
        backViewWithChevronDown.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.bottom.equalToSuperview()
        }
//
        fromLabel.snp.makeConstraints {
            $0.top.equalTo(backViewWithChevronDown.snp.top).offset(UIHelper.Margins.medium8px)
            $0.leading.equalTo(backViewWithChevronDown.snp.leading).offset(UIHelper.Margins.medium16px)
        }

        fromEmailAdress.snp.makeConstraints {
            $0.top.equalTo(backViewWithChevronDown.snp.top).offset(UIHelper.Margins.medium8px)
            $0.leading.equalTo(backViewWithChevronDown.snp.leading).offset(Constants.emailAdressOffset) //67
            $0.trailing.equalTo(backViewWithChevronDown.snp.trailing).inset(UIHelper.Margins.huge42px)
        }

        chevronButtonDown.snp.makeConstraints {
            $0.centerY.equalTo(fromLabel.snp.centerY)
            $0.centerX.equalTo(addressBookIconForToField.snp.centerX)
            $0.width.equalTo(UIHelper.Margins.medium14px)
            $0.height.equalTo(UIHelper.Margins.medium16px)
        }
        underChevronButtonDown.snp.makeConstraints {
            $0.centerY.equalTo(fromLabel.snp.centerY)
            $0.centerX.equalTo(addressBookIconForToField.snp.centerX)
            $0.width.equalTo(UIHelper.Margins.huge36px)
            $0.height.equalTo(UIHelper.Margins.huge36px)
        }

        separatorViewUnderFromTitle.snp.makeConstraints {
            $0.top.equalTo(fromLabel.snp.bottom).offset(UIHelper.Margins.medium8px)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(UIHelper.Margins.small1px)
        }
//
        toLabel.snp.makeConstraints {
            $0.top.equalTo(separatorViewUnderFromTitle.snp.bottom).offset(UIHelper.Margins.medium8px)
            $0.leading.equalTo(backViewWithChevronDown.snp.leading).offset(UIHelper.Margins.medium16px)
        }

        toEmailAdress.snp.makeConstraints {
            $0.centerY.equalTo(toLabel.snp.centerY)
            $0.leading.equalTo(backViewWithChevronDown.snp.leading).offset(Constants.emailAdressOffset) //67
            $0.trailing.equalTo(viewUnderAddressBookIconAtToField.snp.leading)
        }

        addressBookIconForToField.snp.makeConstraints {
            $0.centerY.equalTo(toLabel.snp.centerY)
            $0.trailing.equalTo(backViewWithChevronDown.snp.trailing).inset(UIHelper.Margins.medium16px)
            $0.width.height.equalTo(UIHelper.Margins.medium18px)
        }
        viewUnderAddressBookIconAtToField.snp.makeConstraints {
            $0.centerY.equalTo(toLabel.snp.centerY)
            $0.trailing.equalTo(backViewWithChevronDown.snp.trailing).inset(UIHelper.Margins.small4px)
            $0.height.equalTo(UIHelper.Margins.large30px)
            $0.width.equalTo(UIHelper.Margins.huge40px)
        }

        separatorViewUnderToTitle.snp.makeConstraints {
            $0.top.equalTo(toLabel.snp.bottom).offset(UIHelper.Margins.medium8px)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(UIHelper.Margins.small1px)
        }
//
        copyLabel.snp.makeConstraints {
            $0.top.equalTo(separatorViewUnderToTitle.snp.bottom).offset(UIHelper.Margins.medium8px)
            $0.leading.equalTo(backViewWithChevronDown.snp.leading).offset(UIHelper.Margins.medium16px)
        }

        copyEmailAdresses.snp.makeConstraints {
            $0.centerY.equalTo(copyLabel.snp.centerY)
            $0.leading.equalTo(backViewWithChevronDown.snp.leading).offset(Constants.emailAdressOffset) //67
            $0.trailing.equalTo(viewUnderAddressBookIconAtCopyField.snp.leading)
        }

        addressBookIconForCopyField.snp.makeConstraints {
            $0.centerY.equalTo(copyLabel.snp.centerY)
            $0.trailing.equalTo(backViewWithChevronDown.snp.trailing).inset(UIHelper.Margins.medium16px)
            $0.width.height.equalTo(UIHelper.Margins.medium18px)
        }
        viewUnderAddressBookIconAtCopyField.snp.makeConstraints {
            $0.centerY.equalTo(copyLabel.snp.centerY)
            $0.trailing.equalTo(backViewWithChevronDown.snp.trailing).inset(UIHelper.Margins.small4px)
            $0.height.equalTo(UIHelper.Margins.large30px)
            $0.width.equalTo(UIHelper.Margins.huge40px)
        }

        separatorViewUnderCopyTitle.snp.makeConstraints {
            $0.top.equalTo(copyLabel.snp.bottom).offset(UIHelper.Margins.medium8px)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(UIHelper.Margins.small1px)
        }
//
        titleThemeOfEmail.snp.makeConstraints {
            $0.top.equalTo(separatorViewUnderCopyTitle.snp.bottom).offset(UIHelper.Margins.medium8px)
            $0.leading.equalTo(backViewWithChevronDown.snp.leading).offset(UIHelper.Margins.medium16px)
            $0.bottom.equalTo(backViewWithChevronDown.snp.bottom).offset(-UIHelper.Margins.medium8px)
        }

        textThemeOfEmail.snp.makeConstraints {
            $0.centerY.equalTo(titleThemeOfEmail.snp.centerY)
            $0.leading.equalTo(backViewWithChevronDown.snp.leading).offset(Constants.emailAdressOffset) //67
            $0.trailing.equalToSuperview()
        }

        separatorViewUnderThemeTitle.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(UIHelper.Margins.small1px)
        }

    }

    ///Must have the same set of constraints as makeConstraints method
    private func updateConstraints(insets: UIEdgeInsets) {
        backViewWithChevronDown.snp.updateConstraints {
            $0.top.equalToSuperview().offset(insets.top)
            $0.leading.equalToSuperview().offset(insets.left)
            $0.bottom.equalToSuperview().inset(insets.bottom)
            $0.trailing.equalToSuperview().inset(insets.right)
        }
    }
}


// MARK: - UITextFieldDelegate
extension NewEmailCreateUpperView: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text as NSString? else { return true }

        guard let cursorPosition = textField.selectedTextRange else { return true }
        let updatedText = currentText.replacingCharacters(in: range, with: string)

        // Устанавливаем текст в зависимости от текстового поля
        if textField == self.toEmailAdress {
            self.toEmailAdress.text = updatedText.lowercased()
        } else if textField == self.copyEmailAdresses {
            self.copyEmailAdresses.text = updatedText.lowercased()
        } else if textField == self.textThemeOfEmail {
            self.textThemeOfEmail.text = updatedText
        }

        output?.useCurrent(
            toEmailAdressText: self.toEmailAdress.text,
            copyEmailAdressesText: self.copyEmailAdresses.text,
            textThemeOfEmailText: self.textThemeOfEmail.text,
            isEmptyViewVisible: self.isEmptyViewVisible)

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
