//
//  CryptoSearchViewModel.swift
//  ankushBhatiaCryptoCoinsList
//
//  Created by ANKUSH BHATIA on 1/21/25.
//

import Foundation

final class CryptoSearchViewModel {
    
    // MARK: - Properties
    var didUpdate: EmptyCompletion?
    private let coinItems: [CryptoItem]
    private(set) var filteredCoinItems: [CryptoItem] {
        didSet {
            didUpdate?()
        }
    }
    
    // MARK: - Initializer
    init(coinItems: [CryptoItem]) {
        self.coinItems = coinItems
        self.filteredCoinItems = coinItems
    }
    
    // MARK: - Methods
    func updateSearchResults(searchText: String) {
        if searchText.isEmpty {
            filteredCoinItems = coinItems
            return
        }
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let searchResults = self.coinItems.filter({ item in
                item.name.lowercased().contains(searchText.lowercased())
                || item.symbol.lowercased().contains(searchText.lowercased())
            })
            self.filteredCoinItems = searchResults
        }
    }
}
