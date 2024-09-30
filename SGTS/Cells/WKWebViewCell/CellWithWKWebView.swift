//
//  CellWithWKWebView.swift
//  SGTS
//
//  Created by Roman Vakulenko on 15.07.2024.
//

import UIKit
import SnapKit
import WebKit

final class CellWithWKWebView: BaseTableViewCell<CellWithWKWebViewViewModel>, WKNavigationDelegate {
    
    // MARK: - Private properties
    
    private enum Constants {
        static let heightOfWKWebViewForText: CGFloat = 100
    }
    var savedViewModel: CellWithWKWebViewViewModel?
    var needContentHeightUpdate: Bool = false
    var currentHeight: CGFloat = Constants.heightOfWKWebViewForText
    
    // MARK: - SubTypes
    
    private(set) lazy var backView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let wkWebView: WKWebView = {
        let view = WKWebView()
        view.scrollView.isScrollEnabled = false
        return view
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    // MARK: - Public methods
    
    override func update(with viewModel: CellWithWKWebViewViewModel) {
        if viewModel != savedViewModel {
            needContentHeightUpdate = true
        }

        backView.backgroundColor = viewModel.backColor
        wkWebView.isUserInteractionEnabled = viewModel.isUserInteractionEnabled ?? true
        wkWebView.scrollView.showsVerticalScrollIndicator = viewModel.showsVerticalScrollIndicator ?? false
        wkWebView.navigationDelegate = self
        
        if let htmlString = viewModel.htmlString {
            spinner.startAnimating()
            wkWebView.loadHTMLString(htmlString, baseURL: nil)
        }
        savedViewModel = viewModel
        updateConstraints(insets: viewModel.insets)
    }
    
    override func composeSubviews() {
        backView.addSubview(wkWebView)
        backView.addSubview(spinner) // Добавить спиннер
        contentView.addSubview(backView)
        backgroundColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD
    }
    
    override func setConstraints() {
        backView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        
        wkWebView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
            $0.height.equalTo(Constants.heightOfWKWebViewForText)
        }
        
        spinner.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func updateBodyHeightForWebView(height: CGFloat) {
        wkWebView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }
    
    // MARK: - Private methods
    
    private func updateConstraints(insets: UIEdgeInsets) {
        backView.snp.updateConstraints {
            $0.top.equalToSuperview().offset(insets.top)
            $0.leading.equalToSuperview().offset(insets.left)
            $0.bottom.equalToSuperview().inset(insets.bottom)
            $0.trailing.equalToSuperview().inset(insets.right)
        }
    }
    
    // MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
            self?.spinner.stopAnimating()
            guard let self = self else { return }
            let contentHeight = webView.scrollView.contentSize.height
            if contentHeight != self.currentHeight && self.needContentHeightUpdate {
                self.needContentHeightUpdate = false
                self.currentHeight = contentHeight
                print("contentHeight: \(contentHeight)")
                self.updateBodyHeightForWebView(height: contentHeight)
                self.layoutIfNeeded()
                NotificationCenter.default.post(name: .wkWebViewDidFinishLoading, object: nil)
            } else {
                self.layoutIfNeeded()
            }
        })
    }
}

extension Notification.Name {
    static let wkWebViewDidFinishLoading = Notification.Name("wkWebViewDidFinishLoading")
}
