//
//  URLSessionHTTPClientTests.swift
//  Pokespeare
//
//  Created by Antonio on 24/04/25.
//

import Foundation
import Testing
import Pokespeare

@Suite("URLSessionHTTPClientTests")
final class URLSessionHTTPClientTests {
    
    private let sut: URLSessionHTTPClient
    
    init() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        URLProtocolStub.startInterceptingRequests()
        sut = URLSessionHTTPClient(
            session: URLSession(
                configuration: configuration
            )
        )
    }
    
    deinit {
        URLProtocolStub.stopInterceptingRequests()
    }
    
    @Test("URLSessionHTTPClient does not alter the original request")
    func sameRequest() async throws {
        // Given
        let url = URL(string: "https://example.com")!
        let request = URLRequest(url: url)
        URLProtocolStub.stub {
            anyData
            HTTPURLResponse(statusCode: 200)
        }
        // When
        _ = try await sut.perform(request: request)
        // Then
        #expect(URLProtocolStub.performedRequests == [request])
        
    }
}

