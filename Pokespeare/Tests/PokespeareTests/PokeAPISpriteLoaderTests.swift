//
//  PokeAPISpriteLoaderTests.swift
//  Pokespeare
//
//  Created by Antonio on 23/04/25.
//

import Foundation
import Testing
import Pokespeare

@Suite("PokeAPISpriteLoaderTests", .tags(.public))
struct PokeAPISpriteLoaderTests {
    
    struct HappyPath {

        @Test("getSprite calls correct Pokemon detail endpoint")
        func correctEndpoint() async throws {
            // Given
            let client = HTTPClientStub {
                Success {
                    try makePokemonDetailResponseData(
                        id: 1,
                        name: "pikachu",
                        spriteURL: anyURL
                    )
                }
                Success { anyData }
            }
            let sut = PokeAPISpriteLoader(client: client)
            // When
            _ = try await sut.getSprite(pokemonName: "pikachu")
            // Then
            await #expect(
                client.performedRequests.first?.url?.absoluteString == "https://pokeapi.co/api/v2/pokemon/pikachu"
            )
        }
        
        @Test("getSprite performs 2 api calls")
        func twoApiCalls() async throws {
            // Given
            let spriteURL = URL(string: "https://sprite-url.com")!
            let client = HTTPClientStub {
                Success {
                    try makePokemonDetailResponseData(
                        id: 1,
                        name: "pikachu",
                        spriteURL: spriteURL
                    )
                }
                Success { anyData }
            }
            let sut = PokeAPISpriteLoader(client: client)
            // When
            _ = try await sut.getSprite(pokemonName: "pikachu")
            // Then
            await #expect(
                client.performedRequests
                    .compactMap(\.url)
                    .map(\.absoluteString)
                == [
                    "https://pokeapi.co/api/v2/pokemon/pikachu",
                    "https://sprite-url.com"
                ]
            )
        }
    }
    
    struct ErrorPath {
        
        @Test("getSprite throws error if Pokemon detail can't be decoded from succesful response")
        func decodingError() async throws {
            // Given
            let client = HTTPClientStub {
                Success { anyData }
            }
            let sut = PokeAPISpriteLoader(client: client)
            // Then
            await #expect(
                throws: DecodingError.self,
                performing: {
                    // When
                    _ = try await sut.getSprite(pokemonName: "pikachu")
                }
            )
        }
        
        @Test("getSprite throws error if HTTP request fails")
        func failingHTTP() async throws {
            // Given
            let error = NSError(domain: "client", code: -1)
            let client = HTTPClientStub {
                Failure(error: error)
            }
            let sut = PokeAPISpriteLoader(client: client)
            // Then
            await #expect(
                throws: error,
                performing: {
                    // When
                    _ = try await sut.getSprite(pokemonName: "pikachu")
                }
            )
        }
        
        @Test("getSprite throws NoPokemonFound if Pokemon Detail request returns 404 status code")
        func notFound() async throws {
            // Given
            let client = HTTPClientStub {
                Success(statusCode: 404) { anyData }
            }
            let sut = PokeAPISpriteLoader(client: client)
            // Then
            await #expect(throws: PokemonNotFound.self) {
                // When
                _ = try await sut.getSprite(pokemonName: "pikachu")
            }
        }
        
        @Test("getSprite throws error if sprite API request fails")
        func spriteAPIFails() async throws {
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
            let sut = PokeAPISpriteLoader(client: client)
            // Then
            await #expect(
                throws: error,
                performing: {
                    // When
                    _ = try await sut.getSprite(pokemonName: "pikachu")
                }
            )
        }
        
        @Test("retrieveSprite returns empty data if Pokemon does not have image URL")
        func noImageURL() async throws {
            // Given
            let client = HTTPClientStub {
                Success {
                    try makePokemonDetailResponseData(
                        id: 1,
                        name: "pikachu",
                        spriteURL: nil
                    )
                }
            }
            let sut = PokeAPISpriteLoader(client: client)
            // When
            let spriteData = try await sut.getSprite(pokemonName: "pikachu")
            // Then
            #expect(spriteData.isEmpty)
        }
        
        @Test(
            "getSprite throws error if Pokemon detail API returns with non 200 status code",
            arguments: [
                (500, anyData),
                (500, Data()),
                (
                    500,
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
            let sut = PokeAPISpriteLoader(client: client)
            // Then
            await #expect(throws: URLError(.badServerResponse)) {
                // When
                _ = try await sut.getSprite(pokemonName: "pikachu")
            }
        }
        
        @Test(
            "getSprite throws error if sprite API returns with non 200 status code",
            arguments: [
                (500, anyData),
                (500, Data()),
            ]
        )
        func spriteNon200StatusCode(statusCode: Int, data: Data) async throws {
            // Given
            let client = HTTPClientStub {
                Success {
                    try makePokemonDetailResponseData(
                        id: 1,
                        name: "pikachu",
                        spriteURL: anyURL
                    )
                }
                Success(statusCode: statusCode)  { data }
            }
            let sut = PokeAPISpriteLoader(client: client)
            // Then
            await #expect(throws: URLError(.badServerResponse)) {
                // When
                _ = try await sut.getSprite(pokemonName: "pikachu")
            }
        }
    }
}
