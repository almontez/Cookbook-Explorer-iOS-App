//
//  RecipeImageAPIRequest.swift
//  cookbook-explorer
//
//  Created by Angela Li Montez on 2/26/24.
//

import UIKit

struct RecipeImageAPIRequest: APIRequest {
    enum ResponseError: Error {
        case invalidImageData
    }
    
    let url: URL
    
    var urlRequest: URLRequest {
        return URLRequest(url: url)
    }
    
    func decodeResponse(data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw ResponseError.invalidImageData
        }
        return image
    }
}
