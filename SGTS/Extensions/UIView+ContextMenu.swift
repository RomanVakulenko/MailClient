//
//  UIView+ContextMenu.swift
// 10.01.2024.
//

import UIKit

extension UIView {
    public func createContextImage(title: String?, image: UIImage?, color: UIColor?) -> UIImage? {
        let backgroundColor = color ?? .white
        let tintColor = backgroundColor == .white ? UIColor.black : UIColor.white
        let containerView = createContextView(title: title,
                                              image: image,
                                              color: backgroundColor,
                                              tintColor: tintColor)
        containerView.layoutIfNeeded()
        return renderImage(from: containerView)
    }
    
    private func renderImage(from view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        view.layer.render(in: context)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
    
    
    private func createContextView(title: String?, image: UIImage?, color: UIColor, tintColor: UIColor) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = color
        
        let containerSize: CGFloat = 100
        let contentMultiplier: CGFloat = 0.6
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        containerView.addSubview(stackView)
        
        if let image = image {
            let imageView = UIImageView(image: image)
            imageView.tintColor = tintColor
            imageView.contentMode = .scaleAspectFit
            stackView.addArrangedSubview(imageView)
            
            imageView.snp.makeConstraints {
                $0.width.equalTo(containerView.snp.width).multipliedBy(contentMultiplier)
                $0.height.equalTo(imageView.snp.width)
            }
        }
        
        if let title = title, !title.isEmpty {
            let label = UILabel()
            label.text = title
            label.numberOfLines = 0
            label.textColor = tintColor
            label.font = UIFont.systemFont(ofSize: label.font.pointSize,
                                           weight: .medium)
            label.textAlignment = .center
            stackView.addArrangedSubview(label)
            
            label.snp.makeConstraints {
                $0.width.equalTo(containerView.snp.width)
            }
        }
        
        stackView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalTo(containerView.snp.width)
        }
        
        containerView.snp.makeConstraints {
            $0.width.height.equalTo(containerSize)
        }
        
        return containerView
    }
}

extension UIView {
    func viewWithTagRecursively(_ tag: Int) -> UIView? {
        if self.tag == tag {
            return self
        }
        for subview in self.subviews {
            if let foundView = subview.viewWithTagRecursively(tag) {
                return foundView
            }
        }
        return nil
    }
}

extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    func removeChild() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
