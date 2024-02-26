//
//  RecipesAPIRequest.swift
//  cookbook-explorer
//
//  Created by Angela Li Montez on 2/26/24.
//

import Foundation
import UIKit

struct RecipesAPIRequest: APIRequest {
    let url: URL
    
    var urlRequest: URLRequest {
        return URLRequest(url: url)
    }
    
    func decodeResponse(data: Data) throws -> RecipesJson {
        let recipes = try JSONDecoder().decode(RecipesJson.self, from: data)
        return recipes
    }
}
