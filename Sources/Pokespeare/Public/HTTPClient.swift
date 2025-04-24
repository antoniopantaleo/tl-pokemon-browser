//
//  HTTPClient.swift
//  Pokespeare
//
//  Created by Antonio on 23/04/25.
//

import Foundation

public protocol HTTPClient {
    func perform(request: URLRequest) async throws -> Response
}

public struct Response {
    public let statusCode: Int
    public let data: Data
    
    public init(statusCode: Int, data: Data) {
        self.statusCode = statusCode
        self.data = data
    }
}
