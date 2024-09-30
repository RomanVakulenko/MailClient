//
//  MailStartScreenView.swift
//  SGTS
//
//  Created by Roman Vakulenko on 17.04.2024.
//

import UIKit
import SnapKit

protocol MailStartScreenViewOutput: AnyObject,
                                    EmailCellViewModelOutput {
    func bottomCellHasBeenDisplayed()
    func didPullToReftesh()
}

protocol MailStartScreenViewLogic: UIView {
    func update(viewModel: MailStartScreenModel.ViewModel)
    func displayWaitIndicator(viewModel: MailStartScreenFlow.OnWaitIndicator.ViewModel)
    
    var output: MailStartScreenViewOutput? { get set }
}


final class MailStartScreenView: UIView, MailStartScreenViewLogic, SpinnerDisplayable {
    
    //    private enum Constants {
    //        static let someConstant =
    //    }
    
    private lazy var backView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()

    private lazy var separatorView: UIView = {
        let line = UIView()
        return line
    }()

    private let tableView = UITableView()

    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.attributedTitle = NSAttributedString(string: "Fetchnig mails")
        control.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        return control
    }()

    private(set) var viewModel: MailStartScreenModel.ViewModel?

    // MARK: - Init

    deinit { }

    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        configure()
        backgroundColor = Theme.shared.isLight ? UIHelper.Color.white : UIHelper.Color.blackLightD
        tableView.refreshControl = self.refreshControl
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal Methods

    weak var output: MailStartScreenViewOutput?
    
    // MARK: - Public Methods
    
    func update(viewModel: MailStartScreenModel.ViewModel) {
        self.viewModel = viewModel

        backgroundColor = viewModel.backViewColor
        backView.backgroundColor = viewModel.backViewColor
        separatorView.layer.borderWidth = UIHelper.Margins.small1px
        separatorView.layer.borderColor = viewModel.separatorColor.cgColor

        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
        func displayWaitIndicator(viewModel: MailStartScreenFlow.OnWaitIndicator.ViewModel) {
            if viewModel.isShow {
                showSpinner()
            } else {
                hideSpinner()
            }
        }

    // MARK: - Actions
    @objc func didPullToRefresh() {
        output?.didPullToReftesh()
    }

    // MARK: - Private Methods

    private func configure() {
        addSubviews()
        configureConstraints()
        tableView.register(cellType: EmailCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = true
        tableView.showsHorizontalScrollIndicator = false
        tableView.isUserInteractionEnabled = true
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview()
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
}

// MARK: - UITableViewDataSource

extension MailStartScreenView: UITableViewDataSource, UITableViewDelegate {
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

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
            output?.bottomCellHasBeenDisplayed()
        }
    }
}



