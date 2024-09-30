//
//  DigitalKeyboardView.swift
// 09.11.2023.
//

import UIKit
import SnapKit

protocol DigitalKeyboardDelegate: AnyObject {
//    func didTapDigit(digit: Int)
//    func didTapBackspace()
//    func didTapFaceId()
}

class DigitalKeyboard: UIView {

//    let verticalStackView: UIStackView = {
//        let view = UIStackView()
//        view.axis = .vertical
//        view.spacing = 0
//        view.distribution = .fillEqually
//        view.backgroundColor = .clear
//        return view
//    }()
//
//    var viewsDictionary = [Int: UIView]()
//    let imagesArray = [UIHelper.Image.pinCodeSignOne,UIHelper.Image.pinCodeSignTwo,
//                       UIHelper.Image.pinCodeSignThree, UIHelper.Image.pinCodeSignFour,
//                       UIHelper.Image.pinCodeSignFive, UIHelper.Image.pinCodeSignSix,
//                       UIHelper.Image.pinCodeSignSeven, UIHelper.Image.pinCodeSignEight,
//                       UIHelper.Image.pinCodeSignNine, UIHelper.Image.pinCodeFaceIdIcon,
//                       UIHelper.Image.pinCodeSignZero, UIHelper.Image.pinCodeBackSpaceIcon]

    weak var delegate: DigitalKeyboardDelegate?

    init(delegate: DigitalKeyboardDelegate? = nil) {
        super.init(frame: .zero)
//        self.delegate = delegate
        configureSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureSubviews() {
        self.backgroundColor = .clear
//        self.addSubview(verticalStackView)
//        createDigitItems()

//        verticalStackView.snp.makeConstraints {
//            $0.leading.trailing.top.bottom.equalToSuperview()
//        }
    }

//    private func createDigitItems() {
//        var horizontalStackView = createHorizontalStack()
//        imagesArray.enumerated().forEach {
//            let item = createItem(index: $0, image: $1)
//            viewsDictionary[$0] = item
//            horizontalStackView.addArrangedSubview(item)
//            if ($0 + 1) % 3 == 0 {
//                verticalStackView.addArrangedSubview(horizontalStackView)
//                horizontalStackView = createHorizontalStack()
//            }
//        }
//    }

//    private func createHorizontalStack() -> UIStackView {
//        let view = UIStackView()
//        view.axis = .horizontal
//        view.spacing = 0
//        view.distribution = .fillEqually
//        view.backgroundColor = .clear
//        return view
//    }
//
//    private func createItem(index: Int, image: UIImage) -> UIView {
//        let backView = UIView()
//        backView.backgroundColor = .clear
//        let imageView = UIImageView(image: image)
//        imageView.contentMode = .center//.scaleAspectFit
//        backView.addSubview(imageView)
//
//        let tap = UITapGestureRecognizer(target: self,
//                                         action: #selector(onTap(_:)))
//        backView.addGestureRecognizer(tap)
//        imageView.snp.makeConstraints {
//            $0.leading.trailing.top.bottom.equalToSuperview()
//        }
//        return backView
//    }

//    @objc private func onTap(_ recognizer: UITapGestureRecognizer) {
//        guard let view = recognizer.view,
//              let index = viewsDictionary.first(where: { $0.value == view })?.key
//        else { return }
//
//        switch index {
//        case 0...8:
//            delegate?.didTapDigit(digit: index + 1)
//        case 9:
//            delegate?.didTapFaceId()
//        case 10:
//            delegate?.didTapDigit(digit: 0)
//        case 11:
//            delegate?.didTapBackspace()
//        default:
//            break
//        }
//    }

}

