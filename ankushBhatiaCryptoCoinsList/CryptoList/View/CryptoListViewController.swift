//
//  CryptoListViewController.swift
//  ankushBhatiaCryptoCoinsList
//
//  Created by ANKUSH BHATIA on 1/20/25.
//

import UIKit

final class CryptoListViewController: UIViewController {

    // MARK: - Properties
    private let viewModel: CryptoListViewModel
    private var loadingViewController: LoadingViewController?
    
    // MARK: - Initializers
    init(viewModel: CryptoListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func loadView() {
        view = View(viewModel: viewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Coin"
        updateFromViewModel()
        bindViewModel()
        viewModel.getCoins()
    }
    
    // MARK: - Methods
    private func updateFromViewModel() {
        switch viewModel.state {
            case .loading:
                showLoading()
            case .loaded:
                loadingViewController?.willMove(toParent: nil)
                loadingViewController?.view.removeFromSuperview()
                loadingViewController?.removeFromParent()
                loadingViewController = nil
                (view as? View)?.configure()
            case .error:
                showError()
        }
        (view as? View)?.endRefreshing()
    }
    
    private func bindViewModel() {
        viewModel.didUpdate = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.updateFromViewModel()
            }
        }
    }
    
    private func showError() {
    }
    
    private func showLoading() {
        let loadingViewController = LoadingViewController()
        addChild(loadingViewController)
        loadingViewController.view.frame = view.bounds
        loadingViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(loadingViewController.view)
        loadingViewController.didMove(toParent: self)
        self.loadingViewController = loadingViewController
    }
}

// MARK: - View
extension CryptoListViewController {
    
    final class View: UIView {
        
        // MARK: - Properties
        private let viewModel: CryptoListViewModel
        private var filterCollectionViewHeight: NSLayoutConstraint!
        
        // MARK: - Initializers
        init(viewModel: CryptoListViewModel) {
            self.viewModel = viewModel
            super.init(frame: .zero)
            commonInit()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            updateFilterItemsCollectionViewHeight()
        }
        
        // MARK: - View Elements
        private lazy var tableView: UITableView = {
            let tableView = UITableView()
            tableView.refreshControl = refreshControl
            tableView.registerClassWithDefaultIdentifier(cellClass: CyptoListItemTableViewCell.self)
            return tableView
        }()
        
        private lazy var refreshControl: UIRefreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
            return refreshControl
        }()
        
        private lazy var filterView: UIView = {
            let view = UIView()
            view.backgroundColor = .lightGray
            return view
        }()
        
        private lazy var filterItemsCollectionView: UICollectionView = {
            let layout = LeftAlignedCollectionViewFlowLayout(minimumInteritemSpacing: 8, minimumLineSpacing: 8)
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.backgroundColor = .clear
            collectionView.showsVerticalScrollIndicator = false
            collectionView.allowsSelection = true
            collectionView.allowsMultipleSelection = true
            collectionView.registerClassWithDefaultIdentifier(cellClass: CoinFilterItemCollectionViewCell.self)
            collectionView.isScrollEnabled = false
            return collectionView
        }()
        
        private func updateFilterItemsCollectionViewHeight() {
            guard let layout = filterItemsCollectionView.collectionViewLayout as? LeftAlignedCollectionViewFlowLayout else {
                return
            }
            let height = layout.collectionViewContentSize.height
            if filterCollectionViewHeight.constant != height {
                filterCollectionViewHeight.constant = height
                layoutIfNeeded()
            }
        }
        
        // MARK: - View Initialization
        private func commonInit() {
            backgroundColor = .white
            setupViewHierarchy()
            setupConstraints()
        }
        
        // MARK: - Methods
        private func setupViewHierarchy() {
            
            // Tableview
            tableView.rowHeight = UITableView.automaticDimension
            tableView.dataSource = self
            addSubview(tableView)
            addSubview(filterView)
            filterView.addSubview(filterItemsCollectionView)
            filterItemsCollectionView.dataSource = self
            filterItemsCollectionView.delegate = self
        }
        
        private func setupConstraints() {
            tableView.translatesAutoresizingMaskIntoConstraints = false
            filterView.translatesAutoresizingMaskIntoConstraints = false
            filterItemsCollectionView.translatesAutoresizingMaskIntoConstraints = false
            self.filterCollectionViewHeight = filterItemsCollectionView.heightAnchor.constraint(equalToConstant: 100)
            
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: topAnchor),
                tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: filterView.topAnchor),
                
                filterView.bottomAnchor.constraint(equalTo: bottomAnchor),
                filterView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
                filterView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
                
                filterItemsCollectionView.topAnchor.constraint(equalTo: filterView.topAnchor, constant: 8),
                filterItemsCollectionView.leadingAnchor.constraint(equalTo: filterView.leadingAnchor, constant: 16),
                filterItemsCollectionView.trailingAnchor.constraint(equalTo: filterView.trailingAnchor, constant: -16),
                filterItemsCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),
                filterCollectionViewHeight
            ])
        }
        
        func configure() {
            tableView.reloadData()
            filterItemsCollectionView.reloadData()
            filterItemsCollectionView.isHidden = viewModel.filteredCryptoList.count == 0
        }
        
        func endRefreshing() {
            tableView.refreshControl?.endRefreshing()
        }
        
        @objc
        func refreshData() {
            // Reset all the filters
            viewModel.resetFilters()
            viewModel.getCoins()
        }
    }
}

extension CryptoListViewController.View: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filteredCryptoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CyptoListItemTableViewCell =  tableView.dequeueReusableCell(withIdentifier: CyptoListItemTableViewCell.defaultIdentifier) as! CyptoListItemTableViewCell
        cell.configure(viewModel.filteredCryptoList[indexPath.row])
        return cell
    }
}

extension CryptoListViewController.View: UICollectionViewDataSource,
                                         UICollectionViewDelegate,
                                         UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.filterItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CoinFilterItemCollectionViewCell = collectionView.dequeueReusableCellWithDefaultIdentifier(indexPath: indexPath)
        cell.configure(with: viewModel.filterItems[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let filterItem = viewModel.filterItems[indexPath.row]
        let horizontalPadding: CGFloat = 16
        let verticalPadding: CGFloat = 4
        let textSize = filterItem.type.name.size(withAttributes: [
            NSAttributedString.Key.font: UIFont.Title.lightSmall
        ])
        let isEnabled = filterItem.isSelected
        let width = textSize.width + (isEnabled ? 16 : 0) + horizontalPadding
        let height = textSize.height + verticalPadding
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.udpateFilteredCoins(indexPath: indexPath)
        collectionView.reloadItems(at: [indexPath])
        tableView.reloadData()
    }
}
