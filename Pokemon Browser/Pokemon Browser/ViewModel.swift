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
    
    enum State: Equatable {
        case idle
        case loading
        case notFound(searchedQuery: String)
        case searchFailed(errorMessage: String)
        case found(description: String, spriteData: Data)
    }
    
    var searchText: String = ""
    
    private(set) var state: State = .idle
    var isLoading: Bool { state == .loading }
    
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
        state = .loading
        Task { [weak self] in
            defer { self?.searchText = "" }
            guard let self else { return }
            async let description = pokemonDescriptor.getDescription(pokemonName: searchText)
            async let sprite = pokemonSpriteLoader.getSprite(pokemonName: searchText)
            do {
                state = .found(
                    description: try await description,
                    spriteData: try await sprite
                )
            } catch where error is PokemonNotFound {
                state = .notFound(searchedQuery: searchText)
            } catch {
                state = .searchFailed(errorMessage: error.localizedDescription)
            }
        }
    }
}
