//
//  PinCodeView.swift
//  SGTS
//
//  Created by Roman Vakulenko on 04.04.2024.
//

import UIKit
import SnapKit

protocol PinCodeViewOutput: AnyObject {
    func didTapDigit(digit: Int)
    func didTapBackspace()
    func didTapFaceID()
}

protocol PinCodeViewLogic: UIView {
    func update(viewModel: PinCodeModel.ViewModel)
//    func displayWaitIndicator(viewModel: PinCodeFlow.OnWaitIndicator.ViewModel)
    
    var output: PinCodeViewOutput? { get set }
}


final class PinCodeView: UIView, PinCodeViewLogic, SpinnerDisplayable {

    // MARK: - Public properties

    weak var output: PinCodeViewOutput?

    private(set) var viewModel: PinCodeModel.ViewModel?
    
    // MARK: - Private properties

    private enum Constants {
        static let huge100px: CGFloat = 100
        static let huge128px: CGFloat = 128
        static let hStackCircleWidth: CGFloat = 160
        static let hStackCircleSpacing: CGFloat = 13
        static let vStackWidth: CGFloat = 266
        static let vStackSpacing: CGFloat = 17
        static let vStackHeight: CGFloat = 251
    }

    private lazy var backView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var title: UILabel = {
        var lbl = UILabel()
        lbl.textAlignment = .center
        return lbl
    }()

    private lazy var separatorView: UIView = {
        let line = UIView()
        line.layer.borderWidth = UIHelper.Margins.small1px
        return line
    }()

    private lazy var enterPinLabel: UILabel = { 
        var lbl = UILabel()
        lbl.textAlignment = .center
        return lbl
    }()

    private lazy var circleStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = UIHelper.Margins.large32px
        view.backgroundColor = .clear
        return view
    }()

    private lazy var сircleArr = [UIView]()

    private lazy var verticalStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Constants.vStackSpacing
        view.distribution = .fillEqually
        view.backgroundColor = .clear
        return view
    }()

    private var viewsDictionary = [Int: UIView]()

    private let imagesDigitsArray = [
        Theme.shared.isLight ? UIHelper.Image.pinCodeSignOne : UIHelper.Image.pinCodeSignOneD,
        Theme.shared.isLight ? UIHelper.Image.pinCodeSignTwo : UIHelper.Image.pinCodeSignTwoD,
        Theme.shared.isLight ? UIHelper.Image.pinCodeSignThree : UIHelper.Image.pinCodeSignThreeD,
        Theme.shared.isLight ? UIHelper.Image.pinCodeSignFour : UIHelper.Image.pinCodeSignFourD,
        Theme.shared.isLight ? UIHelper.Image.pinCodeSignFive : UIHelper.Image.pinCodeSignFiveD,
        Theme.shared.isLight ? UIHelper.Image.pinCodeSignSix : UIHelper.Image.pinCodeSignSixD,
        Theme.shared.isLight ? UIHelper.Image.pinCodeSignSeven : UIHelper.Image.pinCodeSignSevenD,
        Theme.shared.isLight ? UIHelper.Image.pinCodeSignEight : UIHelper.Image.pinCodeSignEightD,
        Theme.shared.isLight ? UIHelper.Image.pinCodeSignNine : UIHelper.Image.pinCodeSignNineD,
        UIHelper.Image.pinCodeFaceIdIcon,
        Theme.shared.isLight ? UIHelper.Image.pinCodeSignZero : UIHelper.Image.pinCodeSignZeroD,
        Theme.shared.isLight ? UIHelper.Image.pinCodeBackSpaceIcon : UIHelper.Image.pinCodeBackSpaceIconD]

    // MARK: - Init

    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions

    @objc private func onTap(_ recognizer: UITapGestureRecognizer) {
        guard let view = recognizer.view,
              let index = viewsDictionary.first(where: { $0.value == view })?.key
        else { return }

        switch index {
        case 0...8:
            output?.didTapDigit(digit: index + 1)
        case 9:
            output?.didTapFaceID()
        case 10:
            output?.didTapDigit(digit: 0)
        case 11:
            output?.didTapBackspace()
        default:
            break
        }
    }

    // MARK: - Public Methods

    func update(viewModel: PinCodeModel.ViewModel) {
        self.viewModel = viewModel
        self.backView.backgroundColor = viewModel.backColor
        self.title.attributedText = viewModel.title
        self.separatorView.layer.borderColor = viewModel.separatorColor.cgColor
        self.enterPinLabel.attributedText = viewModel.enterPinLabel

        if viewModel.didDeleteDigit {
            for i in 0..<viewModel.enteredDigitsCount + 1 {
                updateCircles(i, viewModel)
            }
        } else {
            for i in 0..<viewModel.enteredDigitsCount {
                updateCircles(i, viewModel)
            }
        }
    }
    
//    func displayWaitIndicator(viewModel: PinCodeFlow.OnWaitIndicator.ViewModel) {
//        if viewModel.isShow {
//            showSpinner()
//        } else {
//            hideSpinner()
//        }
//    }

    // MARK: - Private methods
    private func configure() {
        createCircleItems()
        createDigitItems()
        addSubviews()
        configureConstraints()
    }

    private func addSubviews() {
        self.addSubview(backView)
        [title, separatorView, enterPinLabel,
         circleStackView, verticalStackView].forEach {backView.addSubview($0)}
    }

    private func updateCircles(_ i: Int, _ viewModel: PinCodeModel.ViewModel) {
        if i >= 0 && i < self.сircleArr.count {
            if let circleView = self.сircleArr[i].subviews.first as? UIImageView {
                circleView.tintColor = viewModel.circleColors[i]
                layoutIfNeeded()
            }
        }
    }

    private func createHorizontalStack() -> UIStackView {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = Constants.hStackCircleSpacing
        view.distribution = .fillEqually
        view.backgroundColor = .clear
        return view
    }

    private func createItem(index: Int, image: UIImage) -> UIView {
        let backView = UIView()
        backView.backgroundColor = .clear

        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        if image == UIHelper.Image.pinCodeFaceIdIcon {
            imageView.tintColor = Theme.shared.isLight ? UIHelper.Color.blackMiddleL : UIHelper.Color.whiteStrong
            }
        backView.addSubview(imageView)

        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(onTap(_:)))
        backView.addGestureRecognizer(tap)
        imageView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        return backView
    }

    private func createDigitItems() {
        var horizontalStackView = createHorizontalStack()

        imagesDigitsArray.enumerated().forEach {
            let item = createItem(index: $0, image: $1)
            viewsDictionary[$0] = item
            horizontalStackView.addArrangedSubview(item)

            if ($0 + 1) % 3 == 0 {
                verticalStackView.addArrangedSubview(horizontalStackView)
                horizontalStackView = createHorizontalStack()
            }
        }
    }

    private func createCircle() -> UIView {
        let backView = UIView()
        backView.backgroundColor = .clear

        let circleView = UIImageView(image: Theme.shared.isLight ? UIHelper.Image.pinCodeCircleL : UIHelper.Image.pinCodeCircleD)
        circleView.contentMode = .center
        circleView.tintColor = Theme.shared.isLight ? UIHelper.Color.grayLightL : UIHelper.Color.grayStrongD

        backView.addSubview(circleView)
        circleView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        return backView
    }

    private func createCircleItems() {
        for _ in 0...3 {
            let item = createCircle()
            circleStackView.addArrangedSubview(item)
            сircleArr.append(item)
        }
    }

    private func configureConstraints() {
        let view = self
        backView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }

        title.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(backView.snp.leading)
            $0.trailing.equalTo(backView.snp.trailing)
            $0.height.equalTo(UIHelper.Margins.huge56px)
        }

        separatorView.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).inset(UIHelper.Margins.small1px) // Inner alignment (Figma)
            $0.leading.equalTo(backView.snp.leading)
            $0.trailing.equalTo(backView.snp.trailing)
            $0.height.equalTo(UIHelper.Margins.small1px)
        }

        enterPinLabel.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(Constants.huge100px)
            $0.centerX.equalTo(backView.snp.centerX)
            $0.height.equalTo(UIHelper.Margins.large23px)
        }

        circleStackView.snp.makeConstraints {
            $0.top.equalTo(enterPinLabel.snp.bottom).offset(UIHelper.Margins.large32px)
            $0.centerX.equalTo(backView.snp.centerX)
            $0.width.equalTo(Constants.hStackCircleWidth)
            $0.height.equalTo(UIHelper.Margins.medium16px)
        }

        verticalStackView.snp.makeConstraints {
            $0.centerX.equalTo(backView.snp.centerX)
            $0.width.equalTo(Constants.vStackWidth)
            $0.height.equalTo(Constants.vStackHeight)
            $0.bottom.equalTo(backView.snp.bottom).inset(Constants.huge128px)
        }
    }
}
