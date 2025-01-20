//
//  APIRequest.swift
//  ankushBhatiaCryptoCoinsList
//
//  Created by ANKUSH BHATIA on 1/20/25.
//

import Foundation

struct APIRequest {
    
    let method: HTTPMethod
    let path: APIPath
    let queryParams: [String: String]
    
    init(method: HTTPMethod, path: APIPath, queryParams: [String : String] = [:]) {
        self.method = method
        self.path = path
        self.queryParams = queryParams
    }
    
    var queryItems: [URLQueryItem] {
        queryParams.compactMap { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
