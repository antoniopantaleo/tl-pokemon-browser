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
    
    @Test("getSprite calls correct endpoint")
    func correctEndpoint() async throws {
        // Given
        let client = HTTPClientStub(
            stubs:
                [
                    .success(
                        try makePokemonDetailResponseData(
                            id: 1,
                            name: "pikachu",
                            spriteURL: anyURL
                        )
                    ),
                    .success(anyData)
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
    
    @Test("getSprite throws error if Pokemon detail can't be decoded from succesful response")
    func decodingError() async throws {
        // Given
        let client = HTTPClientStub(
            stubs: [ .success(anyData) ]
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
    
    //MARK: - Helpers

    private var anyURL: URL { URL(string: "https://example.com")! }
    private var anyData: Data { Data("any-data".utf8) }
    
    private func makePokemonDetailResponseData(
        id: Int,
        name: String,
        spriteURL: URL?
    ) throws -> Data {
        var dict: [String: Any] = [
            "id": id,
            "name": name
        ]
        if let spriteURL {
            dict["sprites"] = ["front_default": spriteURL.absoluteString]
        }
        return try JSONSerialization.data(withJSONObject: dict)
    }
    
}


private final class HTTPClientStub: HTTPClient {
    
    private var stubs: [Result<Data, Error>]
    private(set) var performedRequests: [URLRequest] = []
    
    init(stubs: [Result<Data, Error>]) {
        self.stubs = stubs
    }
    
    func perform(request: URLRequest) async throws -> Data {
        performedRequests.append(request)
        return try stubs.removeFirst().get()
    }
}
