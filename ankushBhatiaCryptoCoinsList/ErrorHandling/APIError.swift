//
//  APIError.swift
//  ankushBhatiaCryptoCoinsList
//
//  Created by ANKUSH BHATIA on 1/20/25.
//

import Foundation

enum APIError: Error {
    
    case networkError
    case parsingError
    case invalidURL
    case noInternetConnection
    case noDataAvailable
    
    
    var title: String {
        switch self {
            case .networkError:
                "Unknown network error"
            case .parsingError:
                "Unable to parse the data"
            case .invalidURL:
                "Invalid URL"
            case .noInternetConnection:
                "No internet connecion. Please check and try again."
            case .noDataAvailable:
                "No data available to show."
        }
    }
}
