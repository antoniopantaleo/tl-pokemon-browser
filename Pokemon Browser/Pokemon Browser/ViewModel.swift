//
//  ViewModel.swift
//  Pokemon Browser
//
//  Created by Antonio on 26/04/25.
//

import Foundation
import Pokespeare

@Observable
final class ViewModel {
    
    var searchText: String = ""
    
    private(set) var pokemonDescription: String?
    private(set) var pokemonSprite: Data?
    private(set) var isLoading = false
    
    
    private let pokemonDescriptor: any PokemonDescriptor
    private let pokemonSpriteLoader: any PokemonSpriteLoader
    
    init(
        pokemonDescriptor: any PokemonDescriptor,
        pokemonSpriteLoader: any PokemonSpriteLoader
    ) {
        self.pokemonDescriptor = pokemonDescriptor
        self.pokemonSpriteLoader = pokemonSpriteLoader
    }
    
    func search() {
        isLoading = true
        Task { [weak self] in
            defer { self?.isLoading = false }
            guard let self else { return }
            async let description = pokemonDescriptor.getDescription(pokemonName: searchText)
            async let sprite = pokemonSpriteLoader.getSprite(pokemonName: searchText)
            do {
                pokemonDescription = try await description
                pokemonSprite = try await sprite
                searchText = ""
            } catch {
                // TODO: Handle errors
                pokemonSprite = nil
                pokemonDescription = nil
            }
        }
    }
}
