//
//  EnterPasswordAfterQRView.swift
//  SGTS
//
//  Created by Roman Vakulenko on 09.04.2024.
//

import UIKit
import SnapKit

protocol EnterPasswordAfterQRViewOutput: AnyObject,
                                         TextCellWithTitleAtBorderViewModelOutput,
                                         NextStepButtonViewModelOutput { }

protocol EnterPasswordAfterQRViewLogic: UIView {
    func update(viewModel: EnterPasswordAfterQRModel.ViewModel)
//    func displayWaitIndicator(viewModel: EnterPasswordAfterQRFlow.OnWaitIndicator.ViewModel)
    
    var output: EnterPasswordAfterQRViewOutput? { get set }
}


final class EnterPasswordAfterQRView: UIView, EnterPasswordAfterQRViewLogic, SpinnerDisplayable {
    
//    private enum Constants {
//        static let someConstant =
//    }
    
    private lazy var backView: UIView = {
        let view = UIView()
        return view
    }()


    private lazy var separatorView: UIView = {
        let line = UIView()
        line.layer.borderWidth = UIHelper.Margins.small1px        
        return line
    }()

    private let tableView = UITableView()

    private(set) var viewModel: EnterPasswordAfterQRModel.ViewModel?

    private var keyboardWillShowObserver: Any?
    private var keyboardWillHideObserver: Any?

    // MARK: - Init

    deinit {
        removeKeyboardObservers()
    }

    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        configure()
        addKeyboardObservers()
    }
  
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal Methods
  
    weak var output: EnterPasswordAfterQRViewOutput?
    
    // MARK: - Public Methods
    
    func update(viewModel: EnterPasswordAfterQRModel.ViewModel) {
        self.viewModel = viewModel

        backgroundColor = viewModel.backViewColor
        backView.backgroundColor = viewModel.backViewColor
        
        separatorView.layer.borderColor = viewModel.separatorColor.cgColor
        tableView.reloadData()
    }
    
//    func displayWaitIndicator(viewModel: EnterPasswordAfterQRFlow.OnWaitIndicator.ViewModel) {
//        if viewModel.isShow {
//            showSpinner()
//        } else {
//            hideSpinner()
//        }
//    }
      // MARK: - Private Methods
    
    private func configure() {
        addSubviews()
        configureConstraints()
        tableView.register(cellType: TitleAndSubTitleCell.self)
        tableView.register(cellType: TextCellWithTitleAtBorder.self)
        tableView.register(cellType: NextStepButtonCell.self)
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = true
        tableView.showsHorizontalScrollIndicator = false
        tableView.delaysContentTouches = false
    }

    private func addSubviews() {
        self.addSubview(backView)
        [separatorView, tableView].forEach {backView.addSubview($0)}
    }

    private func configureConstraints() {
        let view = self
        
        backView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        separatorView.snp.makeConstraints {
            $0.top.equalTo(backView.snp.top)
            $0.leading.equalTo(backView.snp.leading)
            $0.trailing.equalTo(backView.snp.trailing)
            $0.height.equalTo(UIHelper.Margins.small1px)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
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

    // MARK: - Actions
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
            tableView.contentInset = contentInset
            tableView.scrollIndicatorInsets = contentInset
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.contentInset = contentInset
        tableView.scrollIndicatorInsets = contentInset
    }

}


// MARK: - UITableViewDataSource

extension EnterPasswordAfterQRView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.items.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel?.items[indexPath.row].base

        if let vm = item as? TitleAndSubTitleCellViewModel {
            let cell = tableView.dequeueReusableCell(for: indexPath) as TitleAndSubTitleCell
            cell.viewModel = vm
            return cell
        } else if let vm = item as? TextCellWithTitleAtBorderViewModel {
            let cell = tableView.dequeueReusableCell(for: indexPath) as TextCellWithTitleAtBorder
            cell.viewModel = vm
            cell.viewModel?.output = output
            return cell
        } else if let vm = item as? NextStepButtonCellViewModel {
            let cell = tableView.dequeueReusableCell(for: indexPath) as NextStepButtonCell
            cell.viewModel = vm
            cell.viewModel?.output = output
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
