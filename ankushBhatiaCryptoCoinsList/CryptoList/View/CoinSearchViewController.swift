//
//  CoinSearchViewController.swift
//  ankushBhatiaCryptoCoinsList
//
//  Created by ANKUSH BHATIA on 1/21/25.
//

import UIKit

final class CoinSearchViewController: UITableViewController {
    
    // MARK: - Properties
    private let viewModel: CryptoSearchViewModel
    
    // MARK: - UI Elements
    private lazy var searchViewController: UISearchController = {
        UISearchController(searchResultsController: nil)
    }()
    
    // MARK: - Initializers
    init(viewModel: CryptoSearchViewModel) {
        self.viewModel = viewModel
        super.init(style: .plain)
        self.bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = LocalizedString("coinsList.search")
        navigationController?.navigationBar.tintColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(textSizeChanged), name: UIContentSizeCategory.didChangeNotification, object: nil)
        configureSearchBar()
        
        tableView.registerClassWithDefaultIdentifier(cellClass: CryptoListItemTableViewCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchViewController.searchResultsUpdater = self
        searchViewController.delegate = self
        navigationItem.searchController = searchViewController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchViewController.isActive = true
    }
 
    // MARK: - Methods
    private func bindViewModel() {
        viewModel.didUpdate = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
        }
    }
    
    private func configureSearchBar() {
        let searchTextField = searchViewController.searchBar.searchTextField
        searchViewController.searchBar.tintColor = .white
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search",
                                                                   attributes: [.font: UIFont.Title.lightSmall,
                                                                    .foregroundColor: UIColor.lightGray])
        searchTextField.backgroundColor = .clear
        searchTextField.borderStyle = .none
        searchTextField.layer.borderColor = UIColor.white.cgColor
        searchTextField.layer.borderWidth = 1.0
        searchTextField.layer.cornerRadius = 8
        searchTextField.textColor = .white
        searchViewController.searchBar.barStyle = .black
        
        let searchImage = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
        searchViewController.searchBar.setLeftImage(searchImage)
        searchViewController.searchBar.setImage(UIImage(named: "Filter"), for: .bookmark, state: .normal)
    }
    
    @objc func textSizeChanged() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension CoinSearchViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filteredCoinItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CryptoListItemTableViewCell = tableView.dequeueReusableCellWithDefaultIdentifier()
        cell.configure(viewModel.filteredCoinItems[indexPath.row])
        return cell
    }
}

// MARK: - UISearchResultsUpdating
extension CoinSearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.updateSearchResults(searchText: searchText)
    }
}

// MARK: - UISearchControllerDelegate
extension CoinSearchViewController: UISearchControllerDelegate {
    
    func didPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async {
            searchController.searchBar.becomeFirstResponder()
        }
    }
}
