//
//  StubBuilder.swift
//  Pokespeare
//
//  Created by Antonio on 24/04/25.
//

import Foundation

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
