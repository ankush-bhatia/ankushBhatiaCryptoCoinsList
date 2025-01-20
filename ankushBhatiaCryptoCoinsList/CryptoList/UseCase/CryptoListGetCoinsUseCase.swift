//
//  CryptoListGetCoinsUseCase.swift
//  ankushBhatiaCryptoCoinsList
//
//  Created by ANKUSH BHATIA on 1/20/25.
//

import Foundation

struct CryptoListGetCoinsUseCase {
    
    // MARK: - Properties
    let repository: CryptoListRepositoryProtocol
    
    // MARK: - Methods
    func execute(completion: @escaping (Result<[CryptoItem], APIError>) -> Void) {
        repository.getCoins { result in
            completion(result)
        }
    }
}
