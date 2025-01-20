//
//  CryptoListRepository.swift
//  ankushBhatiaCryptoCoinsList
//
//  Created by ANKUSH BHATIA on 1/20/25.
//

import Foundation

protocol CryptoListRepositoryProtocol {
    
    func getCoins(completion: @escaping (Result<[CryptoItem], APIError>) -> Void)
}

struct CryptoListRepository: CryptoListRepositoryProtocol {
    
    let remoteDataSource: CryptoListNetworkDataSourceProtocol
    
    func getCoins(completion: @escaping (Result<[CryptoItem], APIError>) -> Void) {
        let request = APIRequest(method: .get, path: .getCoinsList)
        remoteDataSource
            .geCryptoCoins(request: request) { result in
                completion(result)
            }
    }
}
