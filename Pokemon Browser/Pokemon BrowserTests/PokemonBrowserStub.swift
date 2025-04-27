//
//  PokemonBrowserStub.swift
//  Pokemon Browser
//
//  Created by Antonio on 27/04/25.
//

import Foundation
@testable import Pokemon_Browser

final class PokemonBrowserStub: PokemonBrowser {
    
    private(set) var searchedPokemonName: String?
    private(set) var continuation: UnsafeContinuation<(String, Data), Error>?
    
    func search(pokemonName: String) async throws -> (
        description: String,
        spriteData: Data
    ) {
        searchedPokemonName = pokemonName
        return try await withUnsafeThrowingContinuation { [self] continuation in
            self.continuation = continuation
        }
    }
}
