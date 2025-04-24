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
