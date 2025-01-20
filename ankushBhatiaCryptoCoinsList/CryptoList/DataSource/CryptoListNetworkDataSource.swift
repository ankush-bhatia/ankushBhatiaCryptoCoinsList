//
//  CryptoListNetworkDataSource.swift
//  ankushBhatiaCryptoCoinsList
//
//  Created by ANKUSH BHATIA on 1/20/25.
//

import Foundation

protocol CryptoListNetworkDataSourceProtocol {
    
    func geCryptoCoins(request: APIRequest, completion: @escaping (Result<[CryptoItem], APIError>) -> Void)
}

struct CryptoListNetworkDataSource: CryptoListNetworkDataSourceProtocol {
    
    let apiManager: APIManaging
    
    func geCryptoCoins(request: APIRequest, completion: @escaping (Result<[CryptoItem], APIError>) -> Void) {
        apiManager
            .execute(request) { (result: Result<[CryptoItem], APIError>) in
            completion(result)
        }
    }
}
