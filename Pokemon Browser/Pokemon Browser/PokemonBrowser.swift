//
//  PokemonBrowser.swift
//  Pokemon Browser
//
//  Created by Antonio on 27/04/25.
//

import Foundation

protocol PokemonBrowser {
    func search(pokemonName: String) async throws -> (description: String, spriteData: Data)
}
