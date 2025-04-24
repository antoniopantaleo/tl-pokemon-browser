//
//  HTTPClient.swift
//  Pokespeare
//
//  Created by Antonio on 23/04/25.
//

import Foundation

public protocol HTTPClient {
    func perform(request: URLRequest) async throws -> Data
}
