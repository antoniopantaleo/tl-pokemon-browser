//
//  PokespearePokemonBrowser.swift
//  Pokemon Browser
//
//  Created by Antonio on 27/04/25.
//

import Foundation
import Pokespeare

final class PokespearePokemonBrowser: PokemonBrowser {
    
    private let pokemonDescriptor: any PokemonDescriptor
    private let pokemonSpriteLoader: any PokemonSpriteLoader
    
    init(
        pokemonDescriptor: any PokemonDescriptor,
        pokemonSpriteLoader: any PokemonSpriteLoader
    ) {
        self.pokemonDescriptor = pokemonDescriptor
        self.pokemonSpriteLoader = pokemonSpriteLoader
    }
    
    func search(pokemonName: String) async throws -> (
        description: String,
        spriteData: Data
    ) {
        async let description = pokemonDescriptor.getDescription(pokemonName: pokemonName)
        async let spriteData = pokemonSpriteLoader.getSprite(pokemonName: pokemonName)
        return (try await description, try await spriteData)
    }
}
