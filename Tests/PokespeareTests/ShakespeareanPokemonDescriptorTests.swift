//
//  ShakespeareanPokemonDescriptorTests.swift
//  Pokespeare
//
//  Created by Antonio on 24/04/25.
//

import Foundation
import Testing
@testable import Pokespeare

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
        
        @Test("getDescription throws error if Pokemon Species HTTP request fails")
        func failingSpeciesHTTP() async throws {
            // Given
            let error = NSError(domain: "client", code: -1)
            let client = HTTPClientStub {
                Success {
                    try makePokemonDetailResponseData(
                        id: 1,
                        name: "pikachu",
                        spriteURL: anyURL
                    )
                }
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
        
        @Test("getDescription throws error if FunTranslation HTTP request fails")
        func failingTranslationHTTP() async throws {
            // Given
            let error = NSError(domain: "client", code: -1)
            let client = HTTPClientStub {
                Success {
                    try makePokemonDetailResponseData(
                        id: 1,
                        name: "pikachu",
                        speciesURL: anyURL,
                        spriteURL: anyURL
                    )
                }
                Success {
                    try makePokemonSpeciesResponseData()
                }
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
        
        @Test("getDescription throws error if FunTranslation does not have english description")
        func noEnglishDescription() async throws {
            // Given
            let client = HTTPClientStub {
                Success {
                    try makePokemonDetailResponseData(
                        id: 1,
                        name: "pikachu",
                        speciesURL: anyURL,
                        spriteURL: anyURL
                    )
                }
                Success {
                    try makePokemonSpeciesResponseData(
                        description: "a description",
                        language: "it"
                    )
                }
            }
            let sut = ShakespeareanPokemonDescriptor(client: client)
            // Then
            await #expect(
                throws: NoEnglishDescriptionError(),
                performing: {
                    // When
                    _ = try await sut.getDescription(pokemonName: "pikachu")
                }
            )
        }
        
        @Test(
            "getDescription throws error if Pokemon detail API returns with non 200 status code",
            arguments: [
                (500, anyData),
                (404, anyData),
                (500, Data()),
                (404, Data()),
                (
                    500,
                    try makePokemonDetailResponseData(
                        id: 1,
                        name: "pikachu",
                        spriteURL: anyURL
                    )
                ),
                (
                    404,
                    try makePokemonDetailResponseData(
                        id: 1,
                        name: "pikachu",
                        spriteURL: anyURL
                    )
                )
            ]
        )
        func pokemonDetailNon200StatusCode(statusCode: Int, data: Data) async throws {
            // Given
            let client = HTTPClientStub {
                Success(statusCode: statusCode) { data }
            }
            let sut = ShakespeareanPokemonDescriptor(client: client)
            // Then
            await #expect(throws: URLError(.badServerResponse)) {
                // When
                _ = try await sut.getDescription(pokemonName: "pikachu")
            }
        }
        
        @Test(
            "getDescription throws error if Pokemon species API returns with non 200 status code",
            arguments: [
                (500, anyData),
                (404, anyData),
                (500, Data()),
                (404, Data()),
                (
                    500,
                    try makePokemonSpeciesResponseData()
                ),
                (
                    404,
                    try makePokemonSpeciesResponseData()
                )
            ]
        )
        func pokemonSpeciesNon200StatusCode(statusCode: Int, data: Data) async throws {
            // Given
            let client = HTTPClientStub {
                Success {
                    try makePokemonDetailResponseData(
                        id: 1,
                        name: "pikachu",
                        spriteURL: anyURL
                    )
                }
                Success(statusCode: statusCode) { data }
            }
            let sut = ShakespeareanPokemonDescriptor(client: client)
            // Then
            await #expect(throws: URLError(.badServerResponse)) {
                // When
                _ = try await sut.getDescription(pokemonName: "pikachu")
            }
        }
        
        @Test(
            "getDescription throws error if FunTranslations API returns with non 200 status code",
            arguments: [
                (500, anyData),
                (404, anyData),
                (500, Data()),
                (404, Data()),
                (
                    500,
                    try makeRemoteTranslationResponseData(description: "a description")
                ),
                (
                    404,
                    try makeRemoteTranslationResponseData(description: "a description")
                )
            ]
        )
        func funTranslationsNon200StatusCode(statusCode: Int, data: Data) async throws {
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
                    try makePokemonSpeciesResponseData()
                }
                Success(statusCode: statusCode) { data }
            }
            let sut = ShakespeareanPokemonDescriptor(client: client)
            // Then
            await #expect(throws: URLError(.badServerResponse)) {
                // When
                _ = try await sut.getDescription(pokemonName: "pikachu")
            }
        }
        
        @Test("Newline character gets removed from description")
        func newLineCharacter() async throws {
            // Given
            let string = "It can go for days\nwithout eating a\nsingle morsel. In the bulb on\nits back, it\nstores energy."
            let client = HTTPClientStub {
                Success {
                    try makePokemonDetailResponseData(
                        id: 1,
                        name: "pikachu",
                        spriteURL: anyURL
                    )
                }
                
                Success {
                    try makePokemonSpeciesResponseData(description: string)
                }
                
                Success {
                    try makeRemoteTranslationResponseData(description: "a description")
                }
            }
            let sut = ShakespeareanPokemonDescriptor(client: client)
            // When
            _ = try await sut.getDescription(pokemonName: "pikachu")
            // Then
            let translationRequestURL = try #require(
                client.performedRequests.last?.url
            )
            let components = URLComponents(
                url: translationRequestURL,
                resolvingAgainstBaseURL: false
            )
            let textQueryItemValue = components?.queryItems?
                .first(where: { $0.name == "text"})?.value
            #expect(
                textQueryItemValue == "It can go for days without eating a single morsel. In the bulb on its back, it stores energy."
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
