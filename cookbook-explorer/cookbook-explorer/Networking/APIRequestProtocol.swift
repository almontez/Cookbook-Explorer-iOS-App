//
//  APIRequestProtocol.swift
//  cookbook-explorer
//
//  Created by Angela Li Montez on 2/26/24.
//

import Foundation

protocol APIRequest {
    associatedtype Response
    
    var urlRequest: URLRequest { get }
    func decodeResponse(data: Data) throws -> Response
}
