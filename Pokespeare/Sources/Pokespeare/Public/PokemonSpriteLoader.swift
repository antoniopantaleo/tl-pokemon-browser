//
//  PokemonSpriteLoader.swift
//  Pokespeare
//
//  Created by Antonio on 23/04/25.
//

import Foundation

public protocol PokemonSpriteLoader: Sendable {
    func getSprite(pokemonName name: String) async throws -> Data
}

public struct RemotePokemonSpriteLoader: PokemonSpriteLoader {
    
    private let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public func getSprite(pokemonName name: String) async throws -> Data {
        let remotePokemonDetail = try await client.pokemonDetail(pokemonName: name)
        guard let spriteURL = remotePokemonDetail.sprites.front_default else {
            return Data()
        }
        let spriteResponse = try await client.perform(request: URLRequest(url: spriteURL))
        guard spriteResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return spriteResponse.data
    }
    
}
