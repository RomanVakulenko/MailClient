//
//  OneEmailAttachmentView.swift
//  SGTS
//
//  Created by Roman Vakulenko on 23.04.2024.
//

import UIKit
import SnapKit

protocol OneEmailAttachmentViewOutput: AnyObject,
                                       CloudEmailAttachmentViewModelOutput { }

protocol OneEmailAttachmentViewLogic: UIView {
    func update(viewModel: OneEmailAttachmentViewModel)
//    func displayWaitIndicator(viewModel: OneEmailAttachmentFlow.OnWaitIndicator.ViewModel)

    var output: OneEmailAttachmentViewOutput? { get set }
}


final class OneEmailAttachmentView: UIView, OneEmailAttachmentViewLogic {

    // MARK: - Public properties

    weak var output: OneEmailAttachmentViewOutput?
    var viewModel: OneEmailAttachmentViewModel?

    // MARK: - Private properties

    private enum Constants {
        static var collectionViewHeght: CGFloat = 0
    }

    private lazy var backView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var attachmentTitle: UILabel = {
        var view = UILabel()
        view.numberOfLines = 0
        return view
    }()

    private(set) lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()

    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(cellType: CloudEmailAttachmentCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = true
        return collectionView
    }()

    private var cellWidths = [CGFloat]()

    // MARK: - Init

    deinit {
        Constants.collectionViewHeght = 0
    }

    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func update(viewModel: OneEmailAttachmentViewModel) {
        self.viewModel = viewModel
        if viewModel.widths.count > 0 {
            Constants.collectionViewHeght = 22
        }
        backView.layer.backgroundColor = viewModel.backColor.cgColor
        attachmentTitle.attributedText = viewModel.attachmentTitle

        cellWidths = viewModel.widths

        updateConstraints(insets: viewModel.insets)
        collectionView.reloadData()
    }

    // MARK: - Private Methods

    private func configure() {
        addSubviews()
        configureConstraints()
    }

    private func addSubviews() {
        self.addSubview(backView)
        [attachmentTitle, collectionView].forEach { backView.addSubview($0)}
    }

    private func configureConstraints() {
        backView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }

        attachmentTitle.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(attachmentTitle.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(Constants.collectionViewHeght)
        }
    }

    ///Must have the same set of constraints as makeConstraints method
    private func updateConstraints(insets: UIEdgeInsets) {

        backView.snp.updateConstraints {
            $0.top.equalToSuperview().offset(insets.top)
            $0.leading.equalToSuperview().offset(insets.left)
            $0.bottom.equalToSuperview().inset(insets.bottom)
            $0.trailing.equalToSuperview().inset(insets.right)
        }

        collectionView.snp.updateConstraints {
            $0.top.equalTo(attachmentTitle.snp.bottom).offset(UIHelper.Margins.medium8px)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(Constants.collectionViewHeght)
        }
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension OneEmailAttachmentView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard indexPath.item < cellWidths.count else { return CGSize.zero }
        let cellWidth = cellWidths[indexPath.item]
        
        return CGSize(width: cellWidth, height: Constants.collectionViewHeght)
    }
}


// MARK: - UICollectionViewDataSource

extension OneEmailAttachmentView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.items.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let item = viewModel?.items[indexPath.item].base

        if let vm = item as? CloudEmailAttachmentViewModel {
            let cell = collectionView.dequeueReusableCell(for: indexPath) as CloudEmailAttachmentCollectionViewCell
            cell.viewModel = vm
            cell.viewModel?.output = output
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

