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
        view = View()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFromViewModel()
        bindViewModel()
        viewModel.getCoins()
    }
    
    // MARK: - Methods
    private func updateFromViewModel() {
        switch viewModel.state {
            case .loading:
                showLoading()
            case .loaded(let items):
                loadingViewController?.willMove(toParent: nil)
                loadingViewController?.view.removeFromSuperview()
                loadingViewController?.removeFromParent()
                loadingViewController = nil
                (view as? View)?.configure(with: items)
            case .error:
                showError()
        }
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
        var cryptoList: [CryptoItem] = []
        
        // MARK: - Initializers
        init() {
            super.init(frame: .zero)
            commonInit()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - View Elements
        private lazy var tableView: UITableView = {
            let tableView = UITableView()
            tableView.refreshControl = refreshControl
            return tableView
        }()
        
        private lazy var refreshControl: UIRefreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
            return refreshControl
        }()
        
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
        }
        
        private func setupConstraints() {
            tableView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: topAnchor),
                tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
        
        func configure(with cryptoList: [CryptoItem]) {
            self.cryptoList = cryptoList
            tableView.reloadData()
        }
        
        func endRefreshing() {
            tableView.refreshControl?.endRefreshing()
        }
        
        @objc
        func refreshData() {
            (next as? CryptoListViewController)?.viewModel.getCoins()
        }
    }
}

extension CryptoListViewController.View: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cryptoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}
