//
//  APIManager.swift
//  ankushBhatiaCryptoCoinsList
//
//  Created by ANKUSH BHATIA on 1/20/25.
//

import Foundation

final class APIManager: APIManaging {
    
    static let shared = APIManager()
    
    // MARK: - Properties
    private let urlSession: URLSession
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    // MARK: - Initializer
    private init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    // MARK: - Methods
    func execute<Value: Decodable>(_ request: APIRequest,
                        completion: @escaping (Result<Value, APIError>) -> Void) {
        guard let urlRequest = urlRequest(for: request) else {
            completion(.failure(.invalidURL))
            return
        }
        urlSession
            .dataTask(with: urlRequest) { [unowned self] responseData, urlResponse, error in
                if let data = responseData {
                    let response: Value
                    do {
                        response = try decoder.decode(Value.self, from: data)
                    } catch {
                        completion(.failure(.parsingError))
                        return
                    }
                    completion(.success(response))
                } else {
                    completion(.failure(.networkError))
                }
            }
            .resume()
    }
    
    private func urlRequest(for request: APIRequest) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = APILayerConstants.scheme
        urlComponents.host = APILayerConstants.host
        if let path = request.path.name {
            urlComponents.path = path
        }
        urlComponents.queryItems = request.queryItems
        guard let url = urlComponents.url else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        return urlRequest
    }
}
