//
//  CryptoListViewModel.swift
//  ankushBhatiaCryptoCoinsList
//
//  Created by ANKUSH BHATIA on 1/20/25.
//

import Foundation

final class CryptoListViewModel {
    
    // MARK: - Properties
    private let getCryptoListCoinsUseCase: CryptoListGetCoinsUseCase
    var didUpdate: EmptyCompletion?
    private(set) var cryptoList: [CryptoItem] = []
    private(set) var filteredCryptoList: [CryptoItem] = []
    private(set) var filterItems: [CoinListFilterItem]
    
    var state: CryptoListViewState = .loading {
        didSet {
            didUpdate?()
        }
    }
    
    // MARK: - Initialisers
    init(getCryptoListCoinsUseCase: CryptoListGetCoinsUseCase) {
        self.getCryptoListCoinsUseCase = getCryptoListCoinsUseCase
        filterItems = CoinListFilterType
            .allCases
            .compactMap { CoinListFilterItem(type: $0, isSelected: false) }
    }
    
    // MARK: - Methods
    func getCoins() {
        getCryptoListCoinsUseCase
            .execute { [weak self] result in
                guard let self = self else { return }
                switch result {
                    case .success(let items):
                        self.cryptoList = items
                        self.filteredCryptoList = items
                        self.state = .loaded
                    case .failure(let error):
                        self.state = .error(error: error)
                }
            }
    }
    
    func resetFilters() {
        for index in 0 ..< filterItems.count {
            filterItems[index].isSelected = false
        }
    }
    
    func udpateFilteredCoins(indexPath: IndexPath) {
        filterItems[indexPath.row].isSelected.toggle()
        let filterTypes = filterItems.filter { $0.isSelected }
        if filterTypes.isEmpty {
            filteredCryptoList = cryptoList
        } else {
            filteredCryptoList = cryptoList.filter({ coin in
                var isCoinIncluded = false
                for filter in filterTypes {
                    switch filter.type {
                        case .activeCoins:
                            isCoinIncluded = coin.isActive == true
                        case .inactiveCoins:
                            isCoinIncluded = coin.isActive == false
                        case .onlyTokens:
                            isCoinIncluded = coin.type == .token
                        case .newCoins:
                            isCoinIncluded = coin.isNew == true
                        case .onlyCoins:
                            isCoinIncluded = coin.type == .coin
                    }
                    if !isCoinIncluded {
                        break
                    }
                }
                return isCoinIncluded
            })
        }
    }
}
