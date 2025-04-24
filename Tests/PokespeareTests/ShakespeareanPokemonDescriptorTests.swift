//
//  ShakespeareanPokemonDescriptorTests.swift
//  Pokespeare
//
//  Created by Antonio on 24/04/25.
//

import Foundation
import Testing
import Pokespeare

@Suite("ShakespeareanPokemonDescriptorTests")
struct ShakespeareanPokemonDescriptorTests {
    
    struct HappyPath {
        @Test("getDescription returns a Shakespearean description")
        func getDescription() async throws {
            // Given
            let client = HTTPClientStub {
                Success {
                    try makePokemonDetailResponseData(
                        id: 1,
                        name: "pikachu",
                        spriteURL: anyURL
                    )
                }
                
                Success {
                    try makePokemonSpeciesResponseData(
                       description: "A description",
                       language: "en"
                   )
                }
                
                Success {
                    try makeRemoteTranslationResponseData(
                        description: "A shakesperian description"
                    )
                }
            }
            let sut = ShakespeareanPokemonDescriptor(client: client)
            // When
            let description = try await sut.getDescription(pokemonName: "pikachu")
            // Then
            #expect(description == "A shakesperian description")
        }
    }
    
    struct ErrorPath {}
}

private func makePokemonSpeciesResponseData(
    description: String = "any description",
    language: String = "en"
) throws -> Data {
    let dict: [String: Any] = [
        "flavor_text_entries": [
            ["flavor_text": description, "language": ["name": language]]
        ]
    ]
    return try JSONSerialization.data(withJSONObject: dict)
}

private func makeRemoteTranslationResponseData(description: String) throws -> Data {
    let dict: [String: Any] = [
        "contents": [
            "translated": description
        ]
    ]
    return try JSONSerialization.data(withJSONObject: dict)
}
