//
//  StubBuilder+URLProtocolStub.swift
//  Pokespeare
//
//  Created by Antonio on 24/04/25.
//

import Foundation

extension URLProtocolStub {
    static func stub(@StubBuilder<Stub> _ builder: () -> [Stub]) {
        let stub = builder().first
        Self.stub(
            data: stub?.data,
            response: stub?.response,
            error: stub?.error
        )
    }
}

extension StubBuilder where Stub == URLProtocolStub.Stub {
    
    static func buildBlock(_ components: [Stub]...) -> [Stub] {
        let data = components.flatMap { $0 }.compactMap(\.data).first
        let response = components.flatMap { $0 }.compactMap(\.response).first
        let error = components.flatMap { $0 }.compactMap(\.error).first
        return [Stub(
            data: data,
            response: response,
            error: error
        )]
    }
    
    static func buildExpression(_ expression: Data) -> [Stub] {
        [.init(data: expression, response: nil, error: nil)]
    }
    
    static func buildExpression(_ expression: URLResponse?) -> [Stub] {
        [.init(
            data: nil,
            response: expression,
            error: nil
        )]
    }
    
    static func buildExpression(_ expression: Error) -> [Stub] {
        [.init(data: nil, response: nil, error: expression)]
    }
}

extension HTTPURLResponse {
    convenience init?(statusCode: Int) {
        self.init(
            url: anyURL,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )
    }
}
