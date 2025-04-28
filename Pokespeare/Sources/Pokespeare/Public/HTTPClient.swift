//
//  HTTPClient.swift
//  Pokespeare
//
//  Created by Antonio on 23/04/25.
//

import Foundation

/// A protocol that defines a method for performing HTTP requests.
public protocol HTTPClient: AnyObject, Sendable {
    /// Use this method to perform an HTTP request and wait for the response.
    /// - Parameter request: The HTTP request to perform.
    /// - Returns: The ``Response`` received from the server.
    /// - Throws: An error if the request fails or if the response is not valid.
    func perform(request: URLRequest) async throws -> Response
}

/// A type representing an HTTP response.
public struct Response: Sendable {
    /// The HTTP status code of the response.
    public let statusCode: Int
    /// The data returned in the response.
    public let data: Data
    
    /// Use this method to create a new instance of ``Response`` with a given status code and data.
    /// - Parameters:
    ///   - statusCode: The HTTP status code of the response.
    ///   - data: The data returned in the response.
    public init(statusCode: Int, data: Data) {
        self.statusCode = statusCode
        self.data = data
    }
}
