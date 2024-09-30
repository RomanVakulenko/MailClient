//
//  UserProfileView.swift
//  SGTS
//
//  Created by Roman Vakulenko on 16.06.2024.
//

import UIKit
import SnapKit

protocol UserProfileViewOutput: AnyObject,
                                UserProfileCellViewModelOutput,
                                IconTextAndChevronCellViewModelOutput,
                                IconTextAndSwitchCellViewModelOutput { }

protocol UserProfileViewLogic: UIView {
    func update(viewModel: UserProfileModel.ViewModel)
    func displayWaitIndicator(viewModel: UserProfileFlow.OnWaitIndicator.ViewModel)

    var output: UserProfileViewOutput? { get set }
}


final class UserProfileView: UIView, UserProfileViewLogic, SpinnerDisplayable {

//    private enum Constants {
//        static let someConstant =
//    }

    private lazy var backView: UIView = {
        let view = UIView()
        return view
    }()


    private lazy var separatorViewUnderNavBar: UIView = {
        let line = UIView()
        return line
    }()

    private let tableView = UITableView()

    private(set) var viewModel: UserProfileModel.ViewModel?

    // MARK: - Init

    deinit { }

    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        configure()
        layer.backgroundColor = Theme.shared.isLight ? UIHelper.Color.white.cgColor : UIHelper.Color.blackLightD.cgColor
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal Methods

    weak var output: UserProfileViewOutput?

    // MARK: - Public Methods

    func update(viewModel: UserProfileModel.ViewModel) {
        self.viewModel = viewModel

        self.layer.backgroundColor = viewModel.backViewColor.cgColor
        backView.layer.backgroundColor = viewModel.backViewColor.cgColor

        separatorViewUnderNavBar.layer.borderWidth = UIHelper.Margins.small1px
        separatorViewUnderNavBar.layer.borderColor = viewModel.separatorUnderNavBarColor.cgColor
        tableView.reloadData()
    }

    func displayWaitIndicator(viewModel: UserProfileFlow.OnWaitIndicator.ViewModel) {
        if viewModel.isShow {
            showSpinner()
        } else {
            hideSpinner()
        }
    }
      // MARK: - Private Methods

    private func configure() {
        addSubviews()
        configureConstraints()
        tableView.register(cellType: UserProfileCell.self)
        tableView.register(cellType: IconTextAndChevronCell.self)
        tableView.register(cellType: IconTextAndSwitchCell.self)
        tableView.register(cellType: SeparatorCell.self)
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = true
        tableView.showsHorizontalScrollIndicator = false
        tableView.delaysContentTouches = false
    }

    private func addSubviews() {
        self.addSubview(backView)
        [separatorViewUnderNavBar, tableView].forEach {backView.addSubview($0)}
    }

    private func configureConstraints() {
        let view = self
        backView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        separatorViewUnderNavBar.snp.makeConstraints {
            $0.top.equalTo(backView.snp.top)
            $0.leading.equalTo(backView.snp.leading)
            $0.trailing.equalTo(backView.snp.trailing)
            $0.height.equalTo(UIHelper.Margins.small1px)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(separatorViewUnderNavBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

}


// MARK: - UITableViewDataSource

extension UserProfileView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.items.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel?.items[indexPath.row].base

        if let vm = item as? UserProfileCellViewModel {
            let cell = tableView.dequeueReusableCell(for: indexPath) as UserProfileCell
            cell.viewModel = vm
            cell.viewModel?.output = output
            return cell
        } else if let vm = item as? IconTextAndChevronCellViewModel {
            let cell = tableView.dequeueReusableCell(for: indexPath) as IconTextAndChevronCell
            cell.viewModel = vm
            cell.viewModel?.output = output
            return cell
        } else if let vm = item as? IconTextAndSwitchCellViewModel {
            let cell = tableView.dequeueReusableCell(for: indexPath) as IconTextAndSwitchCell
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

