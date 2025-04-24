//
//  URLSessionHTTPClient.swift
//  Pokespeare
//
//  Created by Antonio on 24/04/25.
//

import Foundation

public final class URLSessionHTTPClient: HTTPClient {
    
    private let session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }
    
    public func perform(request: URLRequest) async throws -> Response {
        let (data, response) = try await session.data(for: request)
        guard let httpURLResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        return Response(statusCode: httpURLResponse.statusCode, data: data)
    }

}
