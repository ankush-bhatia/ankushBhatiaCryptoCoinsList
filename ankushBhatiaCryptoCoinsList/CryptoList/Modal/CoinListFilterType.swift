//
//  CoinListFilterItem.swift
//  ankushBhatiaCryptoCoinsList
//
//  Created by ANKUSH BHATIA on 1/21/25.
//

import Foundation

enum CoinListFilterType: CaseIterable {
    
    case activeCoins
    case inactiveCoins
    case onlyTokens
    case onlyCoins
    case newCoins
    
    var name: String {
        switch self {
        case .activeCoins:
            return "Active Coins"
        case .inactiveCoins:
            return "Inactive Coins"
        case .onlyTokens:
            return "Only Tokens"
        case .onlyCoins:
            return "Only Coins"
        case .newCoins:
            return "New Coins"
        }
    }
}
