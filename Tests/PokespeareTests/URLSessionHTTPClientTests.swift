//
//  URLSessionHTTPClientTests.swift
//  Pokespeare
//
//  Created by Antonio on 24/04/25.
//

import Foundation
import Testing
import Pokespeare

@Suite("URLSessionHTTPClientTests", .serialized)
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
    
    @Test("perform throws error if response is not HTTPURLResponse")
    func notHTTPResponse() async throws {
        // Given
        let request = URLRequest(url: anyURL)
        URLProtocolStub.stub {
            anyData
            URLResponse(
                url: anyURL,
                mimeType: nil,
                expectedContentLength: 200,
                textEncodingName: nil
            )
        }
        // Then
        await #expect(throws: URLError(.badServerResponse)) {
            _ = try await self.sut.perform(request: request)
        }
    }
    
    @Test("URLSessionHTTPClient does not alter received data")
    func sameData() async throws {
        // Given
        let data = Data("hello world".utf8)
        URLProtocolStub.stub {
            data
            HTTPURLResponse(statusCode: 201)
        }
        // When
        let response = try await sut.perform(request: URLRequest(url: anyURL))
        // Then
        #expect(response.data == data)
    }
}

