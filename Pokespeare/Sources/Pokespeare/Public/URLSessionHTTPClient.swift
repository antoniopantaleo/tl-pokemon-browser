//
//  URLSessionHTTPClient.swift
//  Pokespeare
//
//  Created by Antonio on 24/04/25.
//

import Foundation

/// A concrete implementation of the ``HTTPClient`` protocol that uses `URLSession` to perform network requests.
public final class URLSessionHTTPClient: HTTPClient {
    
    private let session: URLSession
    
    /// Use this method to create a new instance of ``URLSessionHTTPClient`` with a given `URLSession`.
    /// - Parameter session: The `URLSession` instance used for network requests.
    public init(session: URLSession) {
        self.session = session
    }
    
    /// Use this method to perform an HTTP request and wait for the response.
    /// - Parameter request: The HTTP request to perform.
    /// - Returns: The ``Response`` received from the server.
    /// - Throws: An error if the request fails or if the response is not valid.
    public func perform(request: URLRequest) async throws -> Response {
        let (data, response) = try await session.data(for: request)
        guard let httpURLResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        return Response(statusCode: httpURLResponse.statusCode, data: data)
    }

}
