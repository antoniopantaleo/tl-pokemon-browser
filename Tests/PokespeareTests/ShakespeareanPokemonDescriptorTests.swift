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
        
        @Test("getDescription performs 3 HTTP requests")
        func threeHTTPRequests() async throws {
            // Given
            let client = HTTPClientStub {
                Success {
                    try makePokemonDetailResponseData(
                        id: 1,
                        name: "pikachu",
                        speciesURL: URL(string: "https://species-url.com")!,
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
            _ = try await sut.getDescription(pokemonName: "pikachu")
            // Then
            #expect(
                client.performedRequests
                    .compactMap(\.url)
                    .map(\.absoluteString)
                == [
                    "https://pokeapi.co/api/v2/pokemon/pikachu",
                    "https://species-url.com",
                    "https://api.funtranslations.com/translate/shakespeare.json?text=A%20description"
                ]
            )
        }
    }
    
    struct ErrorPath {
        @Test("getDescription throws error if Pokemon detail can't be decoded from succesful response")
        func decodingError() async throws {
            // Given
            let client = HTTPClientStub {
                Success { anyData }
            }
            let sut = ShakespeareanPokemonDescriptor(client: client)
            // Then
            await #expect(
                throws: DecodingError.self,
                performing: {
                    // When
                    _ = try await sut.getDescription(pokemonName: "pikachu")
                }
            )
        }
        
        @Test("getDescription throws error if PokemonDetail HTTP request fails")
        func failingDetailHTTP() async throws {
            // Given
            let error = NSError(domain: "client", code: -1)
            let client = HTTPClientStub {
                Failure(error: error)
            }
            let sut = ShakespeareanPokemonDescriptor(client: client)
            // Then
            await #expect(
                throws: error,
                performing: {
                    // When
                    _ = try await sut.getDescription(pokemonName: "pikachu")
                }
            )
        }
    }
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
