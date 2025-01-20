//
//  CryptoListReponse.swift
//  ankushBhatiaCryptoCoinsList
//
//  Created by ANKUSH BHATIA on 1/20/25.
//

import Foundation

struct CryptoItem: Decodable {
    
    let name: String
    let symbol: String
    let isNew: Bool
    let isActive: Bool
    let type: String
}
