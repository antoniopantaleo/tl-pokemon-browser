//
//  StubBuilder.swift
//  Pokespeare
//
//  Created by Antonio on 24/04/25.
//

import Foundation
import Pokespeare

@resultBuilder enum StubBuilder<Stub> {
    static func buildBlock(_ components: [Stub]...) -> [Stub] {
        components.flatMap { $0 }
    }
    
    static func buildExpression(_ expression: Stub) -> [Stub] {
        [expression]
    }
    
    static func buildExpression(_ expression: [Stub]) -> [Stub] {
        expression
    }
}

struct Success {
    
    let statusCode: Int
    let data: Data
    
    init(statusCode: Int = 200, data: () throws -> Data) {
        self.statusCode = statusCode
        self.data = try! data()
    }
}

struct Failure {
    
    let error: Error
    
    init(error: Error)  {
        self.error = error
    }
}

extension StubBuilder where Stub == HTTPClientStub.Stub {
    static func buildExpression(_ expression: Success) -> [Stub] {
        [.success(
            Response(
                statusCode: expression.statusCode,
                data: expression.data
            )
        )]
    }
    
    static func buildExpression(_ expression: Failure) -> [Stub] {
        [.failure(expression.error)]
    }
}

extension HTTPClientStub {
    convenience init(@StubBuilder<Stub> _ stubBuilder: () -> [Stub]) {
        self.init(stubs: stubBuilder())
    }
}
