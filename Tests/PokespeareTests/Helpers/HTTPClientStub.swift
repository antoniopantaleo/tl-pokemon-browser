//
//  HTTPClientStub.swift
//  Pokespeare
//
//  Created by Antonio on 24/04/25.
//

import Foundation
import Pokespeare


final class HTTPClientStub: HTTPClient {
    
    typealias Stub = Result<Response, Error>
    
    private var stubs: [Stub]
    private(set) var performedRequests: [URLRequest] = []
    
    init(stubs: [Stub]) {
        self.stubs = stubs
    }
    
    func perform(request: URLRequest) async throws -> Response {
        performedRequests.append(request)
        return try stubs.removeFirst().get()
    }
}

extension Response {
    static func success200(data: Data) -> Response {
        Response(statusCode: 200, data: data)
    }
}
