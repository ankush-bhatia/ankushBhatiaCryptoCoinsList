//
//  APIManaging.swift
//  ankushBhatiaCryptoCoinsList
//
//  Created by ANKUSH BHATIA on 1/20/25.
//

import Foundation

protocol APIManaging {
    
    func execute<Value: Decodable>(_ request: APIRequest, completion: @escaping (Result<Value, APIError>) -> Void)
}
