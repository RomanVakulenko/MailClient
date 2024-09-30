//
//  NewEmailCreateView.swift
//  SGTS
//
//  Created by Roman Vakulenko on 02.05.2024.
//

import UIKit
import SnapKit

protocol NewEmailCreateViewOutput: AnyObject,
                                   NewEmailCreateUpperViewOutput,
                                   OneEmailAttachmentViewOutput,
                                   TextViewCellViewModelOutput,
                                   FotoCellViewModelOutput {
    func didTapSendButton(viewModel: NewEmailCreateFlow.RoutePayload.ViewModel)
    func didTapSomeDropdownMenuTitle(titleViewModel: NewEmailCreateModels.oneTitleOfDropdownMenu)
}

protocol NewEmailCreateViewLogic: UIView {
    func update(viewModel: NewEmailCreateModels.ViewModel)
    func displayDropdownMenuAtNavBarIcons(viewModel: NewEmailCreateFlow.OnDropdownMenu.ViewModel, dropdownMenuOffset: CGFloat)
    func displayWaitIndicator(viewModel: NewEmailCreateFlow.OnWaitIndicator.ViewModel)
    
    var output: NewEmailCreateViewOutput? { get set }
}


final class NewEmailCreateView: UIView, NewEmailCreateViewLogic, SpinnerDisplayable {

    // MARK: - Public properties
    weak var output: NewEmailCreateViewOutput?

    // MARK: - Private properties

    private enum Constants {
        static let sendButtonHeight: CGFloat = 56
        static let heightOfViewWithButton = (16 * 2 + Constants.sendButtonHeight)
        static let dropdownMenuWidth: CGFloat = 208
        static let dropdownMenuHeight: CGFloat = 84
    }

    private var transparentView: UIView?
    private var dropdownMenu: UIView?
    private var shadowView: UIView?
    private var isMenuVisible = false
    private var dropdownMenuViewModel = [NewEmailCreateModels.oneTitleOfDropdownMenu]()

    private lazy var backView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var navBarSeparatorView: UIView = {
        let line = UIView()
        return line
    }()

    private lazy var upperView: NewEmailCreateUpperView = {
        let view = NewEmailCreateUpperView()
        return view
    }()

    private lazy var attachmentView: OneEmailAttachmentView = {
        let view = OneEmailAttachmentView()
        return view
    }()

    private let tableView = UITableView()

    private lazy var separatorUnderTableView: UIView = {
        let line = UIView()
        return line
    }()

    private lazy var sendButton: UIButton = {
        let view = UIButton(type: .system)
        view.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
        return view
    }()

    private(set) var viewModel: NewEmailCreateModels.ViewModel?

    private var keyboardWillShowObserver: Any?
    private var keyboardWillHideObserver: Any?

    private var updateCounts = 0
    private var currentMenuIdentifier: NewEmailCreateModels.DropdownMenuID?

    // MARK: - Init

    deinit {
        removeKeyboardObservers()
    }

    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        configure()
        addKeyboardObservers()
        self.layer.backgroundColor = Theme.shared.isLight ? UIHelper.Color.white.cgColor : UIHelper.Color.blackLightD.cgColor

    }
  
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Public Methods

    func update(viewModel: NewEmailCreateModels.ViewModel) {
        self.viewModel = viewModel

        self.layer.backgroundColor = viewModel.backViewColor.cgColor
        backView.backgroundColor = viewModel.backViewColor
        navBarSeparatorView.layer.borderWidth = UIHelper.Margins.small1px
        navBarSeparatorView.layer.borderColor = viewModel.separatorColor.cgColor

        for (i, _) in viewModel.views.enumerated() {

            let viewModel = viewModel.views[i].base

            switch viewModel {
            case let vm as NewEmailCreateUpperModel.ViewModel:
                upperView.viewModel = vm
                upperView.update(viewModel: vm)
                upperView.output = output

            case let vm as OneEmailAttachmentViewModel:
                attachmentView.viewModel = vm
                attachmentView.update(viewModel: vm)
                attachmentView.output = output
            default:
                break
            }
        }
        separatorUnderTableView.layer.borderColor = viewModel.separatorColor.cgColor
        separatorUnderTableView.layer.borderWidth = UIHelper.Margins.small1px

        sendButton.layer.cornerRadius = UIHelper.Margins.medium8px
        ///static color - will not change due to theme changing
        sendButton.layer.backgroundColor = UIHelper.Color.blue.cgColor
        sendButton.setAttributedTitle(NSAttributedString(string: getString(.newEmailCreateScreenSendButtonTitle), attributes: UIHelper.Attributed.whiteRobotoMedium14), for: .normal)

        if updateCounts > 0 && viewModel.hasAttachment == false {
            attachmentView.removeFromSuperview()
            layoutIfNeeded()
        }
        updateCounts += 1

        if viewModel.hasAttachment {
            backView.addSubview(attachmentView)

            attachmentView.snp.makeConstraints {
                $0.top.equalTo(upperView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
            }

            tableView.snp.remakeConstraints {
                $0.top.equalTo(attachmentView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
            }
        } else {
            attachmentView.removeFromSuperview()
            tableView.snp.remakeConstraints {
                $0.top.equalTo(upperView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
            }
        }
        removeOpenedDropdownMenuShadowTransparentView()
        tableView.reloadData()
    }

    func displayDropdownMenuAtNavBarIcons(viewModel: NewEmailCreateFlow.OnDropdownMenu.ViewModel, dropdownMenuOffset: CGFloat) {

        //если повторно нажали на иконку уже открытого меню
        if isMenuVisible && currentMenuIdentifier == viewModel.menuID {
            removeOpenedDropdownMenuShadowTransparentView()
            currentMenuIdentifier = nil 
        } else {
            if isMenuVisible {
                removeOpenedDropdownMenuShadowTransparentView()
            }

            setupTransparentView()
            setupShadowForMenu(width: Constants.dropdownMenuWidth,
                               height: Constants.dropdownMenuHeight)

            setupDropdownMenuWith(viewModel: viewModel)

            toggleMenu(offset: dropdownMenuOffset,
                       width: Constants.dropdownMenuWidth,
                       height: Constants.dropdownMenuHeight)

            currentMenuIdentifier = viewModel.menuID
        }
    }

    func displayWaitIndicator(viewModel: NewEmailCreateFlow.OnWaitIndicator.ViewModel) {
        if viewModel.isShow {
            showSpinner()
        } else {
            hideSpinner()
        }
    }


    private func setupTransparentView() {
        let transparentView = UIView()
        transparentView.backgroundColor = .clear
        transparentView.isUserInteractionEnabled = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(catchTransparentViewTap(_:)))

        transparentView.addGestureRecognizer(tapGesture)
        self.addSubview(transparentView)
        transparentView.tag = GlobalConstants.transparentViewTag
        self.transparentView = transparentView
    }

    private func setupShadowForMenu(width: CGFloat, height: CGFloat) {
        let shadowView = UIView()
        shadowView.frame = CGRect(x: 0, y: 0, width: width, height: height)

        let shadows = UIView()
        shadows.frame = shadowView.frame
        shadows.clipsToBounds = false
        shadowView.addSubview(shadows)

        let shadowPath0 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 0)
        let layer0 = CALayer()
        layer0.shadowPath = shadowPath0.cgPath
        layer0.shadowColor = Theme.shared.isLight ? UIHelper.Color.shadowForMenuAtThreeDotsL.cgColor : UIHelper.Color.shadowD.cgColor
        layer0.shadowOpacity = 1
        layer0.shadowRadius = UIHelper.Margins.small6px
        layer0.shadowOffset = CGSize(width: 0, height: 3)
        layer0.bounds = shadows.bounds
        layer0.position = shadows.center
        shadows.layer.addSublayer(layer0)

        self.addSubview(shadowView)
        shadowView.tag = GlobalConstants.shadowForDropdownMenuTagNewEmailCreateView

        shadowView.isHidden = true
        self.shadowView = shadowView
    }

    private func setupDropdownMenuWith(viewModel: NewEmailCreateFlow.OnDropdownMenu.ViewModel) {
        dropdownMenuViewModel = viewModel.dropdownMenuTitlesViewModel

        let dropdownMenu = UIView()
        dropdownMenu.backgroundColor = Theme.shared.isLight ? .white : UIHelper.Color.darkBackD
        dropdownMenu.layer.cornerRadius = UIHelper.Margins.medium8px
        dropdownMenu.isHidden = true

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = UIHelper.Margins.medium16px
        dropdownMenu.addSubview(stackView)

        for (index, oneTitleViewModel) in dropdownMenuViewModel.enumerated() {
            let viewForLabel = createViewWithLabel(
                attributedString: oneTitleViewModel.attributedString,
                indexOfLineInDropDownMenu: index)

            stackView.addArrangedSubview(viewForLabel)
        }

        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(
                top: UIHelper.Margins.medium16px,
                left: UIHelper.Margins.medium16px,
                bottom: UIHelper.Margins.medium16px,
                right: UIHelper.Margins.medium16px))
        }

        self.addSubview(dropdownMenu)
        dropdownMenu.tag = GlobalConstants.dropdownMenuTagNewEmailCreateView
        dropdownMenu.isHidden = true
        self.dropdownMenu = dropdownMenu
    }

    private func toggleMenu(offset: CGFloat, width: CGFloat, height: CGFloat) {
        if isMenuVisible {
            dropdownMenu?.isHidden = true
            shadowView?.isHidden = true
            transparentView?.isHidden = true
        } else {
            transparentView?.snp.remakeConstraints{
                $0.top.bottom.leading.trailing.equalToSuperview()
            }
            shadowView?.snp.remakeConstraints {
                $0.top.equalToSuperview().offset(offset)
                $0.trailing.equalToSuperview().offset(-UIHelper.Margins.medium8px)
                $0.width.equalTo(width)
                $0.height.equalTo(height)
            }
            dropdownMenu?.snp.remakeConstraints {
                $0.top.equalToSuperview().offset(offset)
                $0.trailing.equalToSuperview().offset(-UIHelper.Margins.medium8px)
                $0.width.equalTo(width)
                $0.height.equalTo(height)
            }
            self.layoutIfNeeded()
            shadowView?.isHidden = false
            dropdownMenu?.isHidden = false
            transparentView?.isHidden = false
        }
        isMenuVisible.toggle()
    }

    private func removeOpenedDropdownMenuShadowTransparentView() {
        if isMenuVisible {
            isMenuVisible = false
            dropdownMenu?.isHidden = true
            shadowView?.isHidden = true

            recursiveRemoveSubviews(self)
        }
    }
    
    // MARK: - Actions
    @objc func catchTransparentViewTap(_ gesture: UITapGestureRecognizer) {
        if transparentView?.isUserInteractionEnabled == true {
            transparentView?.isUserInteractionEnabled = false
            removeOpenedDropdownMenuShadowTransparentView()
        }
    }

    @objc func didSelectMenuAction(_ gesture: UITapGestureRecognizer) {
        guard let title = (gesture.view as? UILabel)?.text,
              let selectedTitle = dropdownMenuViewModel.first(where: { $0.attributedString.string == title }) else {
            return
        }
        output?.didTapSomeDropdownMenuTitle(titleViewModel: selectedTitle)
        removeOpenedDropdownMenuShadowTransparentView()
    }

    // MARK: - Private methods

    private func recursiveRemoveSubviews(_ view: UIView) {
        for subview in view.subviews {
            if subview.tag == GlobalConstants.dropdownMenuTagNewEmailCreateView || 
                subview.tag == GlobalConstants.shadowForDropdownMenuTagNewEmailCreateView ||
                subview.tag == GlobalConstants.transparentViewTag {
                subview.removeFromSuperview()
            } else if !subview.subviews.isEmpty {
                recursiveRemoveSubviews(subview)
            }
        }
    }

    private func createViewWithLabel(attributedString: NSAttributedString,
                                     indexOfLineInDropDownMenu: Int) -> UIView {
        let label = UILabel()
        label.attributedText = attributedString
        label.isUserInteractionEnabled = true
        label.tag = indexOfLineInDropDownMenu //нужен ли?

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didSelectMenuAction(_:)))
        label.addGestureRecognizer(tapGestureRecognizer)

        return label
    }

    private func configure() {
        addSubviews()
        configureConstraints()
        tableView.register(cellType: TextFieldCell.self)
        tableView.register(cellType: TextViewCell.self)
        tableView.register(cellType: FotoCell.self)
        tableView.register(cellType: SeparatorCell.self)
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = true
        tableView.showsHorizontalScrollIndicator = false
        tableView.delaysContentTouches = false
    }

    private func addSubviews() {
        self.addSubview(backView)
        [navBarSeparatorView, upperView,
         tableView, separatorUnderTableView, sendButton].forEach { backView.addSubview($0) }
    }

    private func configureConstraints() {
        backView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
        }

        navBarSeparatorView.snp.makeConstraints {
            $0.top.equalTo(backView.snp.top)
            $0.height.equalTo(UIHelper.Margins.small1px)
            $0.leading.trailing.equalToSuperview()
        }

        upperView.snp.makeConstraints {
            $0.top.equalTo(navBarSeparatorView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(upperView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }

        separatorUnderTableView.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom).offset(UIHelper.Margins.medium16px)
            $0.height.equalTo(UIHelper.Margins.small1px)
            $0.leading.trailing.equalToSuperview()
        }

        sendButton.snp.makeConstraints {
            $0.top.equalTo(separatorUnderTableView.snp.bottom).offset(UIHelper.Margins.medium16px)
            $0.leading.equalToSuperview().offset(UIHelper.Margins.medium16px)
            $0.trailing.equalToSuperview().offset(-UIHelper.Margins.medium16px)
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-UIHelper.Margins.small4px)
            $0.height.equalTo(Constants.sendButtonHeight)
        }
    }

    private func addKeyboardObservers() {
        keyboardWillShowObserver = NotificationCenter.default.addObserver(
            forName: .keyboardWillShow,
            object: nil,
            queue: nil) { [weak self] notification in
                self?.keyboardWillShow(notification)
            }

        keyboardWillHideObserver = NotificationCenter.default.addObserver(
            forName: .keyboardWillHide,
            object: nil,
            queue: nil) { [weak self] notification in
                self?.keyboardWillHide(notification)
            }
    }

    private func removeKeyboardObservers() {
        if let observer = keyboardWillShowObserver {
            NotificationCenter.default.removeObserver(observer)
        }

        if let observer = keyboardWillHideObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height - Constants.heightOfViewWithButton, right: 0)
            tableView.contentInset = contentInset
            tableView.scrollIndicatorInsets = contentInset
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        tableView.contentInset = .zero
        tableView.scrollIndicatorInsets = .zero
    }

    @objc private func didTapSendButton(_ sender: UIButton) {
        output?.didTapSendButton(viewModel: NewEmailCreateFlow.RoutePayload.ViewModel())
    }
}


// MARK: - UITableViewDataSource

extension NewEmailCreateView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.items.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel?.items[indexPath.row].base

        if let vm = item as? TextFieldCellViewModel {
            let cell = tableView.dequeueReusableCell(for: indexPath) as TextFieldCell
            cell.viewModel = vm
            return cell
        } else if let vm = item as? TextViewCellViewModel {
            let cell = tableView.dequeueReusableCell(for: indexPath) as TextViewCell
            cell.viewModel = vm
            cell.viewModel?.output = output

            cell.textViewTextDidChange = { [weak self] in //for increasing lines of entered text in textView
                self?.tableView.beginUpdates()
                self?.tableView.endUpdates()
            }
            return cell
        } else if let vm = item as? FotoCellViewModel {
            let cell = tableView.dequeueReusableCell(for: indexPath) as FotoCell
            cell.viewModel = vm
            cell.viewModel?.output = output
            return cell
        } else if let vm = item as? SeparatorCellViewModel {
            let cell = tableView.dequeueReusableCell(for: indexPath) as SeparatorCell
            cell.viewModel = vm
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

