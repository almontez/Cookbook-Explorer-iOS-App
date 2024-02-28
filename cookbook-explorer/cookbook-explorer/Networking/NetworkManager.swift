//
//  NetworkManager.swift
//  cookbook-explorer
//
//  Created by Angela Li Montez on 2/26/24.
//

import Foundation

struct NetworkManager {
    
    enum NetworkError: Error {
        case networkError
    }
    
    func fetchData<Request: APIRequest>(for request: Request) async throws -> Request.Response {
        let (data, response) = try await URLSession.shared.data(for: request.urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.networkError
        }
        
        let decodedResponse = try request.decodeResponse(data: data)
        return decodedResponse
    }
}
