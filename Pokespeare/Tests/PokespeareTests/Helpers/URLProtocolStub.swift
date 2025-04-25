//
//  URLProtocolStub.swift
//  Pokespeare
//
//  Created by Antonio on 24/04/25.
//

import Foundation

final class URLProtocolStub: URLProtocol {
    nonisolated(unsafe) private static var stub: Stub?
    nonisolated(unsafe) private(set) static var performedRequests: [URLRequest] = []
    
    struct Stub {
        let data: Data?
        let response: URLResponse?
        let error: Error?
    }
    
    static func stub(data: Data?, response: URLResponse?, error: Error?) {
        stub = Stub(data: data, response: response, error: error)
    }
    
    static func startInterceptingRequests() {
        URLProtocol.registerClass(URLProtocolStub.self)
        Self.performedRequests = []
    }
    
    static func stopInterceptingRequests() {
        URLProtocol.unregisterClass(URLProtocolStub.self)
        stub = nil
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        Self.performedRequests.append(request)
        if let data = URLProtocolStub.stub?.data {
            client?.urlProtocol(self, didLoad: data)
        }
        if let response = URLProtocolStub.stub?.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        if let error = URLProtocolStub.stub?.error {
            client?.urlProtocol(self, didFailWithError: error)
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() { }
    
}
