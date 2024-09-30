//
//  EmailPickingScreenView.swift
//  SGTS
//
//  Created by Roman Vakulenko on 20.05.2024.
//

import UIKit
import SnapKit

protocol EmailPickingScreenViewOutput: AnyObject, EmailCellViewModelOutput {
    func didTapBackArrow()
    func didTapPickAllBox()

    func didTapArchiveNavBarIcon()
    func didTapTrashNavBarIcon()
    func didTapUnreadNavBarIcon()
    func didTapThreeDotsNavBarIcon()

    func displayThreeDotsDropdownMenu(viewModel: EmailPickingScreenFlow.OnDropdownMenu.ViewModel)
    func didTapThreeDotsDropDownMenuAt(oneTitleViewModel: EmailPickingScreenModel.oneTitleOfDropdownMenu)
}

protocol EmailPickingScreenViewLogic: UIView {
    func update(viewModel: EmailPickingScreenModel.ViewModel)
    func displayWaitIndicator(viewModel: EmailPickingScreenFlow.OnWaitIndicator.ViewModel)
    func displayThreeDotsDropdownMenu(viewModel: EmailPickingScreenFlow.OnDropdownMenu.ViewModel)

    var output: EmailPickingScreenViewOutput? { get set }
}

final class EmailPickingScreenView: UIView, EmailPickingScreenViewLogic, SpinnerDisplayable {

    // MARK: - Public properties

    // MARK: - Private properties
    private enum Constants {
        static let rightBarIconsStackHeight = 56
        static let rightBarIconsStackViewWidth = 176
        static let oneEmailPickedDropdownMenuWidth: CGFloat = 208
        static let oneEmailPickedDropdownMenuHeight: CGFloat = 152
        static let someEmailsPickedDropdownMenuWidth: CGFloat = 229
        static let someEmailsPickedDropdownMenuHeight: CGFloat = 118
        static let dropDownMenuOffset: CGFloat = 32 + 4 + 28
    }

    private lazy var backView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()

    private lazy var leftBarButton: UIButton = {
        let btn = UIButton(type: .system)
        return btn
    }()

    private lazy var screenTitle: UILabel = {
        var lbl = UILabel()
        return lbl
    }()

    private lazy var archiveNavBarButton = UIButton(type: .system)
    private lazy var trashNavBarButton = UIButton(type: .system)
    private lazy var unreadNavBarButton = UIButton(type: .system)
    private lazy var menuNavBarButton = UIButton(type: .system)

    private lazy var rightBarIconsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = UIHelper.Margins.large24px
        return view
    }()

    private lazy var checkBoxButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: #selector(didTapPickAll(_:)), for: .touchUpInside)
        return btn
    }()

    private lazy var checkBoxTitle: UILabel = {
        var lbl = UILabel()
        return lbl
    }()

    private lazy var separatorView: UIView = {
        let line = UIView()
        return line
    }()

    private var tableView = UITableView()

    private(set) var viewModel: EmailPickingScreenModel.ViewModel?

    private var transparentView: UIView?
    private var dropdownMenu: UIView?
    private var shadowView: UIView?
    private var isMenuVisible = false

    private var dropdownMenuViewModel = [EmailPickingScreenModel.oneTitleOfDropdownMenu]()


    // MARK: - Properties for dropdownMenu width and height
    private var dropdownMenuTitlesArray = [NSAttributedString]()
    private var dropdownMenuWidth: CGFloat {
        if dropdownMenuTitlesArray[0].string == getString(.reply) {
            return Constants.oneEmailPickedDropdownMenuWidth
        } else {
            return Constants.someEmailsPickedDropdownMenuWidth
        }
    }
    private var dropdownMenuHeight: CGFloat {
        if dropdownMenuTitlesArray[0].string == getString(.reply) {
            return Constants.oneEmailPickedDropdownMenuHeight
        } else {
            return Constants.someEmailsPickedDropdownMenuHeight
        }
    }

    // MARK: - Init

    deinit { }

    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        configure()
        backgroundColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    weak var output: EmailPickingScreenViewOutput?
    
    // MARK: - Public Methods
    
    func update(viewModel: EmailPickingScreenModel.ViewModel) {
        self.viewModel = viewModel

        backgroundColor = viewModel.backViewColor
        backView.backgroundColor = viewModel.backViewColor
        separatorView.layer.borderWidth = UIHelper.Margins.small1px
        separatorView.layer.borderColor = viewModel.separatorColor.cgColor

        leftBarButton.setImage(viewModel.leftBarButtonImage, for: .normal)
        leftBarButton.tintColor = viewModel.backNavBarButtonColor

        screenTitle.attributedText = viewModel.screenTitle

        archiveNavBarButton.setImage(viewModel.archiveNavBarIcon, for: .normal)
        trashNavBarButton.setImage(viewModel.trashNavBarIcon, for: .normal)
        unreadNavBarButton.setImage(viewModel.unreadNavBarIcon, for: .normal)
        menuNavBarButton.setImage(viewModel.threeDotsNavBarIcon, for: .normal)

        rightBarIconsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        rightBarIconsStackView.addArrangedSubview(archiveNavBarButton)
        rightBarIconsStackView.addArrangedSubview(trashNavBarButton)
        rightBarIconsStackView.addArrangedSubview(unreadNavBarButton)
        rightBarIconsStackView.addArrangedSubview(menuNavBarButton)

        checkBoxButton.setImage(viewModel.checkBoxButtonImage, for: .normal)
        checkBoxTitle.attributedText = viewModel.checkBoxTitle

        removeOpenedDropdownMenuShadowTransparentView()//when menu opened tap at table closes menu
        tableView.reloadData()
    }

    func displayThreeDotsDropdownMenu(viewModel: EmailPickingScreenFlow.OnDropdownMenu.ViewModel) {
        for oneTitleViewModel in viewModel.dropdownMenuTitlesViewModel {
            dropdownMenuTitlesArray.append(oneTitleViewModel.attributedString) //for dropdownWidthHeight
        }

        removeOpenedDropdownMenuShadowTransparentView()
        setupTransparentView()
        setupShadowForMenu(width: dropdownMenuWidth, height: dropdownMenuHeight)
        setupDropdownMenuWith(viewModel: viewModel)

        toggleMenu(offset: Constants.dropDownMenuOffset,
                   width: dropdownMenuWidth,
                   height: dropdownMenuHeight)
    }
    
    func displayWaitIndicator(viewModel: EmailPickingScreenFlow.OnWaitIndicator.ViewModel) {
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
        shadowView.tag = GlobalConstants.shadowForDropdownMenuTagEmailPickingView

        shadowView.isHidden = true
        self.shadowView = shadowView
    }

    private func setupDropdownMenuWith(viewModel: EmailPickingScreenFlow.OnDropdownMenu.ViewModel) {
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
        dropdownMenu.tag = GlobalConstants.dropdownMenuTagEmailPickingView
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

    private func recursiveRemoveSubviews(_ view: UIView) {
        for subview in view.subviews {
            if subview.tag == GlobalConstants.dropdownMenuTagEmailPickingView ||
                subview.tag == GlobalConstants.shadowForDropdownMenuTagEmailPickingView ||
                subview.tag == GlobalConstants.transparentViewTag {
                subview.removeFromSuperview()
            } else if !subview.subviews.isEmpty {
                recursiveRemoveSubviews(subview)
            }
        }
    }

    private func createViewWithLabel(attributedString: NSAttributedString,
                                     indexOfLineInDropDownMenu: Int) -> UIView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = UIHelper.Margins.small4px

        let label = UILabel()
        label.attributedText = attributedString
        label.isUserInteractionEnabled = true

        if attributedString.string == getString(.moveEmailTo) {
            let chevronImageView = UIImageView(image: Theme.shared.isLight ? UIHelper.Image.chevronRightL : UIHelper.Image.chevronRightD)
            stackView.addArrangedSubview(label)
            stackView.addArrangedSubview(chevronImageView)
        } else {
            stackView.addArrangedSubview(label)
        }

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didSelectMenuAction(_:)))
        label.addGestureRecognizer(tapGestureRecognizer)

        return label
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
        output?.didTapThreeDotsDropDownMenuAt(oneTitleViewModel: selectedTitle)
        removeOpenedDropdownMenuShadowTransparentView()
    }

    @objc func handleBackArrowTap(_ sender: UIButton) {
        output?.didTapBackArrow()
    }

    @objc func didTapPickAll(_ sender: UIButton) {
        output?.didTapPickAllBox()
    }

    @objc func didTapArchiveNavBarIcon(_ sender: UIButton) {
        output?.didTapArchiveNavBarIcon()
    }

    @objc func didTapTrashNavBarIcon(_ sender: UIButton) {
        output?.didTapTrashNavBarIcon()
    }

    @objc func didTapUnreadNavBarIcon(_ sender: UIButton) {
        output?.didTapUnreadNavBarIcon()
    }

    @objc func didTapThreeDotsNavBarIcon(_ sender: UIButton) {
        output?.didTapThreeDotsNavBarIcon()
    }



    // MARK: - Private Methods

    private func configure() {
        addSubviews()
        configureConstraints()
        tableView.register(cellType: EmailCell.self)
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = true
        tableView.showsHorizontalScrollIndicator = false
        tableView.isUserInteractionEnabled = true
        tableView.delaysContentTouches = false

        archiveNavBarButton.addTarget(self, action: #selector(didTapArchiveNavBarIcon), for: .touchUpInside)
        trashNavBarButton.addTarget(self, action: #selector(didTapTrashNavBarIcon), for: .touchUpInside)
        unreadNavBarButton.addTarget(self, action: #selector(didTapUnreadNavBarIcon), for: .touchUpInside)
        menuNavBarButton.addTarget(self, action: #selector(didTapThreeDotsNavBarIcon), for: .touchUpInside)
    }

    private func addSubviews() {
        self.addSubview(backView)
        [leftBarButton, screenTitle, rightBarIconsStackView,
         checkBoxButton, checkBoxTitle,
         separatorView, tableView].forEach {backView.addSubview($0)}

        leftBarButton.addTarget(self, action: #selector(handleBackArrowTap), for: .touchUpInside)
    }

    private func configureConstraints() {
        let view = self

        backView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }

        leftBarButton.snp.makeConstraints {
            $0.centerY.equalTo(rightBarIconsStackView.snp.centerY)
            $0.leading.equalTo(backView.snp.leading).offset(UIHelper.Margins.large20px)
            $0.height.width.equalTo(UIHelper.Margins.medium16px)
        }

        screenTitle.snp.makeConstraints {
            $0.centerY.equalTo(rightBarIconsStackView.snp.centerY)
            $0.leading.equalTo(leftBarButton.snp.trailing).offset(UIHelper.Margins.huge36px)
            $0.trailing.equalTo(rightBarIconsStackView.snp.leading)
        }

        rightBarIconsStackView.snp.makeConstraints {
            $0.top.equalTo(backView.snp.top).offset(UIHelper.Margins.medium16px)
            $0.trailing.equalTo(backView.snp.trailing).offset(-UIHelper.Margins.large24px)
        }

        checkBoxButton.snp.makeConstraints {
            $0.top.equalTo(leftBarButton.snp.bottom).offset(UIHelper.Margins.large20px)
            $0.centerX.equalTo(leftBarButton.snp.centerX)
            $0.height.width.equalTo(UIHelper.Margins.medium16px)
        }

        checkBoxTitle.snp.makeConstraints {
            $0.leading.equalTo(checkBoxButton.snp.trailing).offset(UIHelper.Margins.huge36px)
            $0.centerY.equalTo(checkBoxButton.snp.centerY)
        }

        separatorView.snp.makeConstraints {
            $0.top.equalTo(checkBoxButton.snp.bottom).offset(UIHelper.Margins.medium8px)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(UIHelper.Margins.small1px)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDataSource

extension EmailPickingScreenView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.items.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel?.items[indexPath.row].base

        if let vm = item as? EmailCellViewModel {
            let cell = tableView.dequeueReusableCell(for: indexPath) as EmailCell
            cell.viewModel = vm
            cell.viewModel?.output = output
            return cell
        } else {
            return UITableViewCell()
        }
    }

}
