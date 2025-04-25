//
//  StubBuilder+HTTPClientStub.swift
//  Pokespeare
//
//  Created by Antonio on 24/04/25.
//

import Foundation
import Pokespeare

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
    init(@StubBuilder<Stub> _ stubBuilder: () -> [Stub]) {
        self.init(stubs: stubBuilder())
    }
}
