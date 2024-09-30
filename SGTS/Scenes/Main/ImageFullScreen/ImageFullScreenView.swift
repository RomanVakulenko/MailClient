//
//  ImageFullScreenView.swift
//  SGTS
//
//  Created by Roman Vakulenko on 02.05.2024.
//

import UIKit
import SnapKit

protocol ImageFullScreenViewOutput: AnyObject {
    func didTapSomeDropdownMenuTitle(titleViewModel: ImageFullScreenModel.oneTitleOfDropdownMenu)
    func didTapBackArrow()
    func didTapThreeDotsIcon()
}

protocol ImageFullScreenViewLogic: UIView {
    func update(viewModel: ImageFullScreenModel.ViewModel)
    func displayThreeDotsDropdownMenu(viewModel: ImageFullScreenFlow.OnDropdownMenu.ViewModel)

    func displayWaitIndicator(viewModel: ImageFullScreenFlow.OnWaitIndicator.ViewModel)

    var output: ImageFullScreenViewOutput? { get set }
}


final class ImageFullScreenView: UIView, ImageFullScreenViewLogic, SpinnerDisplayable {

    // MARK: - Public properties

    weak var output: ImageFullScreenViewOutput?

    // MARK: - Private properties

    private enum Constants {
        static let dropdownMenuOffset: CGFloat = 32 + 4 + 28
        static let dropdownMenuWidth: CGFloat = 237
        static let dropdownMenuHeight: CGFloat = 84
        static let upperNavigationViewHeight: CGFloat = 56
        static let widthHeightForBackArrow16px: CGFloat = 16
        static let widthHeightForUpperElements24px: CGFloat = 24
    }

    private var transparentView: UIView?
    private var dropdownMenu: UIView?
    private var shadowView: UIView?
    private var isMenuVisible = false
    private var dropdownMenuViewModel = [ImageFullScreenModel.oneTitleOfDropdownMenu]()


    private lazy var upperNavigationView = UIView()
    private lazy var backArrowButton = UIButton(type: .system)
    private lazy var threeDotsMenuButton = UIButton(type: .system)

    private lazy var screenTitle: UILabel = {
        let view = UILabel()
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return view
    }()

    private lazy var imageSizeSubtitle = UILabel()

    private lazy var backViewForImage: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()

    //    private lazy var imageFullScreenView: UIImageView = {
    //        let view = UIImageView()
    //        view.contentMode = .scaleAspectFit
    //        return view
    //    }()

    private lazy var scrollView: ImageScrollView = {
        let view = ImageScrollView(frame: self.bounds)
        return view
    }()

    private var currentRotation: CGFloat = 0.0

    private(set) var viewModel: ImageFullScreenModel.ViewModel?



    // MARK: - Init

    deinit { }

    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Public Methods

    func update(viewModel: ImageFullScreenModel.ViewModel) {
        self.viewModel = viewModel

        backgroundColor = viewModel.statusBarBackground
        backViewForImage.backgroundColor = viewModel.backViewColor
        upperNavigationView.backgroundColor = viewModel.upperNavigationViewBackground

        screenTitle.attributedText = viewModel.screenTitle
        imageSizeSubtitle.attributedText = viewModel.imageSizeSubtitle
        backArrowButton.setImage(viewModel.backArrowIcon, for: .normal)
        threeDotsMenuButton.setImage(viewModel.threeDotsMenuIcon, for: .normal)
        //        imageFullScreenView.image = viewModel.imageFullScreen
        scrollView.set(image: viewModel.imageFullScreen)
        removeOpenedDropdownMenuShadowTransparentView()
    }

    func displayThreeDotsDropdownMenu(viewModel: ImageFullScreenFlow.OnDropdownMenu.ViewModel) {
        removeOpenedDropdownMenuShadowTransparentView()
        setupTransparentView()
        setupShadowForMenu(width: Constants.dropdownMenuWidth,
                           height: Constants.dropdownMenuHeight)

        setupDropdownMenuWith(viewModel: viewModel)

        toggleMenu(offset: Constants.dropdownMenuOffset,
                   width: Constants.dropdownMenuWidth,
                   height: Constants.dropdownMenuHeight)
    }


    // MARK: - Private methods

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
        shadowView.frame = CGRect(x: 0, y: 0, width: width, height: height) //Constants.dropdownMenuWidth и Constants.dropdownMenuHeight

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
        shadowView.tag = GlobalConstants.shadowForDropdownMenuTagImageFullScreenView

        shadowView.isHidden = true
        self.shadowView = shadowView
    }

    private func setupDropdownMenuWith(viewModel: ImageFullScreenFlow.OnDropdownMenu.ViewModel) {
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
        dropdownMenu.tag = GlobalConstants.dropdownMenuTagImageFullScreenView
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

    func displayWaitIndicator(viewModel: ImageFullScreenFlow.OnWaitIndicator.ViewModel) {
        if viewModel.isShow {
            showSpinner()
        } else {
            hideSpinner()
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

    @objc private func didTapBack(_ sender: UIButton) {
        output?.didTapBackArrow()
    }

    @objc private func didTapThreeDotsMenu(_ sender: UIButton) {
        output?.didTapThreeDotsIcon()
    }

    @objc private func handleRotationGesture(_ recognizer: UIRotationGestureRecognizer) {
        guard let view = recognizer.view else { return }

        switch recognizer.state {
        case .began, .changed:
            let newRotation = currentRotation + recognizer.rotation
            view.transform = view.transform.rotated(by: newRotation - currentRotation)
            currentRotation = newRotation
            recognizer.rotation = 0.0
        default:
            break
        }
    }

    // MARK: - Private Methods

    private func recursiveRemoveSubviews(_ view: UIView) {
        for subview in view.subviews {
            if subview.tag == GlobalConstants.dropdownMenuTagImageFullScreenView ||
                subview.tag == GlobalConstants.shadowForDropdownMenuTagImageFullScreenView ||
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
        label.tag = indexOfLineInDropDownMenu //нужен ли? если мы разбираем не по этому тегу(как раньше), а просто текст передаем нажатого лейбла (полагаю не нужен - так?)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didSelectMenuAction(_:)))
        label.addGestureRecognizer(tapGestureRecognizer)

        return label
    }


    private func configure() {
        addSubviews()
        configureConstraints()
    }

    private func addSubviews() {
        self.addSubview(backViewForImage)
        backViewForImage.addSubview(scrollView)
//        scrollView.addSubview(imageFullScreenView)
        self.addSubview(upperNavigationView)
        [backArrowButton, screenTitle, imageSizeSubtitle, threeDotsMenuButton].forEach { upperNavigationView.addSubview($0)}

        backArrowButton.addTarget(self, action:  #selector(didTapBack), for: .touchUpInside)
        threeDotsMenuButton.addTarget(self, action:  #selector(didTapThreeDotsMenu), for: .touchUpInside)
//        imageFullScreenView.isUserInteractionEnabled = true
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self,
                                                                    action: #selector(handleRotationGesture(_:)))
        scrollView.addGestureRecognizer(rotationGestureRecognizer)
    }

    private func configureConstraints() {
        backViewForImage.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        scrollView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        upperNavigationView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.upperNavigationViewHeight)
        }

        backArrowButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(UIHelper.Margins.large20px)
            $0.leading.equalToSuperview().offset(UIHelper.Margins.large20px)
            $0.bottom.equalToSuperview().inset(UIHelper.Margins.large20px)
            $0.height.width.equalTo(Constants.widthHeightForBackArrow16px)
        }

        threeDotsMenuButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(UIHelper.Margins.medium16px)
            $0.trailing.equalToSuperview().inset(UIHelper.Margins.medium16px)
            $0.bottom.equalToSuperview().inset(UIHelper.Margins.medium16px)
            $0.height.width.equalTo(Constants.widthHeightForUpperElements24px)
        }

        screenTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(UIHelper.Margins.medium8px)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(Constants.widthHeightForUpperElements24px)
        }

        imageSizeSubtitle.snp.makeConstraints {
            $0.top.equalTo(screenTitle.snp.bottom)
            $0.leading.equalTo(screenTitle.snp.leading)
            $0.height.equalTo(UIHelper.Margins.medium16px)
            $0.bottom.equalToSuperview().inset(UIHelper.Margins.medium8px)
        }
    }

}
