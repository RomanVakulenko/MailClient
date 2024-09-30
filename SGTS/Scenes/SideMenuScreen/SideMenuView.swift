//
//  SideMenuView.swift
//  SGTS
//
//  Created by Roman Vakulenko on 03.07.2024.
//

import UIKit
import SnapKit
import DifferenceKit

protocol SideMenuViewOutput: AnyObject,
                             UserProfileCellViewModelOutput,
                             IconTextAndCounterCellViewModelOutput {
    func didTapAtGrayView()
}

protocol SideMenuViewLogic: UIView {
    func update(viewModel: SideMenuModel.ViewModel)
//    func updateIncoming(viewModel: SideMenuModel.ItemViewModel)

    var output: SideMenuViewOutput? { get set }
    var grayView: UIView { get }
    var tableView: UITableView { get }
}


final class SideMenuView: UIView, SideMenuViewLogic{

    private enum Constants {
        static let insetForTableView: CGFloat = 60
    }

    lazy var grayView: UIView = {
        let view = UIView()
        return view
    }()

    var tableView = UITableView()

    private(set) var viewModel: SideMenuModel.ViewModel?
    private(set) var incomingItemViewModel: SideMenuModel.ItemViewModel?

    // MARK: - Init

    deinit { }

    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal Methods

    weak var output: SideMenuViewOutput?

    // MARK: - Public Methods

    func update(viewModel: SideMenuModel.ViewModel) {
        self.viewModel = viewModel
        grayView.layer.backgroundColor = viewModel.grayViewColor.cgColor
        tableView.reloadData()
    }

//    func updateIncoming(viewModel: SideMenuModel.ItemViewModel) {
//        self.incomingItemViewModel = viewModel
//        let indexPath = IndexPath(row: 2, section: 0)
//        tableView.reloadRows(at: [indexPath], with: .automatic)
//    }


    // MARK: - Actions
    @objc private func didTapAtGrayView(_ sender: UITapGestureRecognizer) {
        output?.didTapAtGrayView()
    }

    // MARK: - Private Methods

    private func configure() {
        addSubviews()
        configureConstraints()
        tableView.register(cellType: UserProfileCell.self)
        tableView.register(cellType: IconTextAndCounterCell.self)
        tableView.register(cellType: SeparatorCell.self)
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.delaysContentTouches = false

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapAtGrayView(_:)))
        grayView.isUserInteractionEnabled = true
        grayView.addGestureRecognizer(tapGestureRecognizer)

    }


    private func addSubviews() {
        self.addSubview(grayView)
        grayView.addSubview(tableView)
    }

    private func configureConstraints() {
        let view = self
        grayView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }

        tableView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.trailing.equalTo(grayView.snp.trailing).inset(Constants.insetForTableView)
        }
    }
}


// MARK: - UITableViewDataSource

extension SideMenuView: UITableViewDataSource {
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
        } else if let vm = item as? IconTextAndCounterCellViewModel {
            let cell = tableView.dequeueReusableCell(for: indexPath) as IconTextAndCounterCell
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
