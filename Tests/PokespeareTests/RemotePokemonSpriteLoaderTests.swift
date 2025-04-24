//
//  RemotePokemonSpriteLoaderTests.swift
//  Pokespeare
//
//  Created by Antonio on 23/04/25.
//

import Foundation
import Testing
import Pokespeare

@Suite("RemotePokemonSpriteLoaderTests")
struct RemotePokemonSpriteLoaderTests {
    
    struct HappyPath {

        @Test("getSprite calls correct Pokemon detail endpoint")
        func correctEndpoint() async throws {
            // Given
            let client = HTTPClientStub(
                stubs:
                    [
                        .success(
                            .success200(
                                data:
                                    try makePokemonDetailResponseData(
                                        id: 1,
                                        name: "pikachu",
                                        spriteURL: anyURL
                                    )
                            )
                        ),
                        .success(.success200(data: anyData))
                    ]
            )
            let sut = RemotePokemonSpriteLoader(client: client)
            // When
            _ = try await sut.getSprite(pokemonName: "pikachu")
            // Then
            #expect(
                client.performedRequests.first?.url?.absoluteString == "https://pokeapi.co/api/v2/pokemon/pikachu"
            )
        }
        
        @Test("getSprite performs 2 api calls")
        func twoApiCalls() async throws {
            // Given
            let spriteURL = URL(string: "https://sprite-url.com")!
            let client = HTTPClientStub(
                stubs:
                    [
                        .success(
                            .success200(
                                data:
                                    try makePokemonDetailResponseData(
                                        id: 1,
                                        name: "pikachu",
                                        spriteURL: spriteURL
                                    )
                            )
                        ),
                        .success(.success200(data: anyData))
                    ]
            )
            let sut = RemotePokemonSpriteLoader(client: client)
            // When
            _ = try await sut.getSprite(pokemonName: "pikachu")
            // Then
            #expect(
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
            let client = HTTPClientStub(
                stubs: [ .success(.success200(data: anyData)) ]
            )
            let sut = RemotePokemonSpriteLoader(client: client)
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
            let client = HTTPClientStub(stubs: [.failure(error)])
            let sut = RemotePokemonSpriteLoader(client: client)
            // Then
            await #expect(
                throws: error,
                performing: {
                    // When
                    _ = try await sut.getSprite(pokemonName: "pikachu")
                }
            )
        }
        
        @Test("getSprite throws error if sprite API request fails")
        func spriteAPIFails() async throws {
            // Given
            let error = NSError(domain: "client", code: -1)
            let client = HTTPClientStub(
                stubs: [
                    .success(
                        .success200(
                            data:
                                try makePokemonDetailResponseData(
                                    id: 1,
                                    name: "pikachu",
                                    spriteURL: anyURL
                                )
                        )
                    ),
                    .failure(error)
                ]
            )
            let sut = RemotePokemonSpriteLoader(client: client)
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
            let client = HTTPClientStub(
                stubs: [
                    .success(
                        .success200(
                            data:
                                try makePokemonDetailResponseData(
                                    id: 1,
                                    name: "pikachu",
                                    spriteURL: nil
                                )
                        )
                    )
                ]
            )
            let sut = RemotePokemonSpriteLoader(client: client)
            // When
            let spriteData = try await sut.getSprite(pokemonName: "pikachu")
            // Then
            #expect(spriteData.isEmpty)
        }
        
        @Test(
            "getSprite throws error if Pokemon detail API returns with non 200 status code",
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
            let client = HTTPClientStub(
                stubs: [
                    .success(Response(statusCode: statusCode, data: data))
                ]
            )
            let sut = RemotePokemonSpriteLoader(client: client)
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
                (404, anyData),
                (500, Data()),
                (404, Data())
            ]
        )
        func spriteNon200StatusCode(statusCode: Int, data: Data) async throws {
            // Given
            let client = HTTPClientStub(
                stubs: [
                    .success(
                        .success200(
                            data: try makePokemonDetailResponseData(
                                id: 1,
                                name: "pikachu",
                                spriteURL: anyURL
                            )
                        )
                    ),
                    .success(Response(statusCode: statusCode, data: data))
                ]
            )
            let sut = RemotePokemonSpriteLoader(client: client)
            // Then
            await #expect(throws: URLError(.badServerResponse)) {
                // When
                _ = try await sut.getSprite(pokemonName: "pikachu")
            }
        }
    }
}
