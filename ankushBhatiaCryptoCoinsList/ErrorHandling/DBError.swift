//
//  DBError.swift
//  ankushBhatiaCryptoCoinsList
//
//  Created by ANKUSH BHATIA on 1/22/25.
//

import Foundation

enum DBError: Error {
    
    case unableToSaveData
    case unableToGetData
    
    var title: String {
        switch self {
            case .unableToGetData:
                return "Unable to get data"
            case .unableToSaveData:
                return "Unable to save data"
        }
    }
}
