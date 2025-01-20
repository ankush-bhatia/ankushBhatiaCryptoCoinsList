//
//  APIPath.swift
//  ankushBhatiaCryptoCoinsList
//
//  Created by ANKUSH BHATIA on 1/20/25.
//

import Foundation

enum APIPath {
    
    case getCoinsList
    
    var name: String {
        switch self {
        case .getCoinsList:
            return "/"
        }
    }
}
