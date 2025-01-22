//
//  CryptoListViewState.swift
//  ankushBhatiaCryptoCoinsList
//
//  Created by ANKUSH BHATIA on 1/21/25.
//

import Foundation

enum CryptoListViewState: Equatable {
    
    case loading
    case loaded
    case error(error: Error)
    
    static func == (lhs: CryptoListViewState, rhs: CryptoListViewState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.loaded, .loaded):
            return true
        case (.error, .error):
            return true
        default:
            return false
        }
    }
}
