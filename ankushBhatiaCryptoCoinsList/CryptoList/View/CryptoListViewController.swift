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
}

// MARK: - View
extension CryptoListViewController {
    
    final class View: UIView {
        
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
            return tableView
        }()
        
        // MARK: - View Initialization
        private func commonInit() {
            backgroundColor = .white
            setupViewHierarchy()
            setupConstraints()
        }
        
        // MARK: - Methods
        private func setupViewHierarchy() {
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
        
        func configure() {
            tableView.reloadData()
        }
    }
}
