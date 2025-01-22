//
//  MockCryptoListRepository.swift
//  ankushBhatiaCryptoCoinsListTests
//
//  Created by ANKUSH BHATIA on 1/22/25.
//

import Foundation
@testable import ankushBhatiaCryptoCoinsList

final class MockCryptoListRepository: CryptoListRepositoryProtocol {
    
    var cryptoCoins: Result<[CryptoItem], APIError>!
    
    func getCoins(completion: @escaping (Result<[CryptoItem], APIError>) -> Void) {
        completion(cryptoCoins)
    }
    
    func saveCoins(cryptoCoins: [CryptoItem]) {
        self.cryptoCoins = .success(cryptoCoins)
    }
}
