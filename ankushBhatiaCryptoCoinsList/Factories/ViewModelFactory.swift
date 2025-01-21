//
//  ViewModelFactory.swift
//  ankushBhatiaCryptoCoinsList
//
//  Created by ANKUSH BHATIA on 1/21/25.
//

import Foundation

struct ViewModelFactory {
    
    static func makeCryptoListViewModel() -> CryptoListViewModel {
        let apiManager = APIManager.shared
        let remoteDataSource = CryptoListNetworkDataSource(apiManager: apiManager)
        let dbDataSource = CryptoListDBDataSource()
        let repo = CryptoListRepository(remoteDataSource: remoteDataSource,
                                        dbDataSource: dbDataSource)
        let getCryptoListCoinsUseCase = CryptoListGetCoinsUseCase(repository: repo)
        let viewModel = CryptoListViewModel(getCryptoListCoinsUseCase: getCryptoListCoinsUseCase)
        return viewModel
    }
    
    static func makeCryptoSearchViewModel(cryptoItems: [CryptoItem]) -> CryptoSearchViewModel {
        CryptoSearchViewModel(coinItems: cryptoItems)
    }
}
