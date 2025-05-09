//
//  EndToEndTests.swift
//  Pokespeare
//
//  Created by Antonio on 24/04/25.
//

import Foundation
import Testing
import Pokespeare

@Suite("EndToEndTests", .tags(.endToEnd))
struct EndToEndTests {
    
    @Test("PokemonSpiteLoader")
    func pokemonSpiteLoader() async throws {
        // Given
        let configuration = URLSessionConfiguration.ephemeral
        let client = URLSessionHTTPClient(
            session: URLSession(
                configuration: configuration
            )
        )
        let sut = PokeAPISpriteLoader(client: client)
        // When
        let spriteData = try await sut.getSprite(pokemonName: "bulbasaur")
        // Then
        #expect(!spriteData.isEmpty)
    }
    
    @Test("ShakespeareanPokemonDescriptor")
    func pokemonDescriptor() async throws {
        // Given
        let configuration = URLSessionConfiguration.ephemeral
        let client = URLSessionHTTPClient(
            session: URLSession(
                configuration: configuration
            )
        )
        let sut = ShakespeareanPokemonDescriptor(client: client)
        // When
        let description = try await sut.getDescription(pokemonName: "pikachu")
        // Then
        #expect(!description.isEmpty)
    }
    
}
