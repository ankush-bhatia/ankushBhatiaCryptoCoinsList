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
    var filterItems: [CoinListFilterItem]
    
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
                        self.state = .loaded(items)
                    case .failure:
                        self.state = .error
                }
            }
    }
}
