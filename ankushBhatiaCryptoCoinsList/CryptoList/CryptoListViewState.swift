//
//  CryptoListViewState.swift
//  ankushBhatiaCryptoCoinsList
//
//  Created by ANKUSH BHATIA on 1/21/25.
//

import Foundation

enum CryptoListViewState {
 
    case loading
    case loaded
    case error(error: Error)
}
