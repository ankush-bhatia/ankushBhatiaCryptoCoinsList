//
//  CryptoListRepository.swift
//  ankushBhatiaCryptoCoinsList
//
//  Created by ANKUSH BHATIA on 1/20/25.
//

import Foundation

protocol CryptoListRepositoryProtocol {
    
    func getCoins(completion: @escaping (Result<[CryptoItem], APIError>) -> Void)
    func saveCoins(cryptoCoins: [CryptoItem])
}

struct CryptoListRepository: CryptoListRepositoryProtocol {
    
    let remoteDataSource: CryptoListNetworkDataSourceProtocol
    let dbDataSource: CryptoListDBDataSourceProtocol
    
    func getCoins(completion: @escaping (Result<[CryptoItem], APIError>) -> Void) {
        guard Reachability.isConnectedToNetwork() else {
            dbDataSource
                .geCryptoCoins { result in
                    switch result {
                        case .success(let cryptoCoins):
                            if cryptoCoins.isEmpty && !Reachability.isConnectedToNetwork() {
                                completion(.failure(.noInternetConnection))
                            } else {
                                completion(.success(cryptoCoins))
                            }
                        case .failure:
                            completion(.failure(.noInternetConnection))
                    }
                }
            return
        }
        let request = APIRequest(method: .get, path: .getCoinsList)
        remoteDataSource
            .geCryptoCoins(request: request) { result in
                switch result {
                    case .success(let cryptoCoins):
                        self.saveCoins(cryptoCoins: cryptoCoins)
                        completion(.success(cryptoCoins))
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
    }
    
    func saveCoins(cryptoCoins: [CryptoItem]) {
        dbDataSource
            .saveCryptoCoins(cryptoCoins: cryptoCoins) { result in
                
            }
    }
}
