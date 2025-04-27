//
//  ErrorStub.swift
//  Pokemon Browser
//
//  Created by Antonio on 27/04/25.
//

import Foundation

struct ErrorStub: LocalizedError {
    let errorMessage: String
    init(_ errorMessage: String) {
        self.errorMessage = errorMessage
    }
    var errorDescription: String? { errorMessage }
}
