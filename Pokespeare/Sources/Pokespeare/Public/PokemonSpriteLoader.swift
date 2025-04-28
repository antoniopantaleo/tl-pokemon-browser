//
//  PokemonSpriteLoader.swift
//  Pokespeare
//
//  Created by Antonio on 23/04/25.
//

import Foundation

/// A protocol that defines a method for dowloading Pokémon sprites data.
public protocol PokemonSpriteLoader: Sendable {
    /// Use this method to retrieve the image data of a Pokemon for a later representation.
    ///
    /// This method returns raw `Data`, so the client has the responsibility to convert it into its desired format (e.g. `UIImage`, `Image`, `NSImage` ecc...).
    /// - Parameter name: The name of the Pokemon to search for.
    /// - Returns: The Pokemon sprite raw image `Data`.
    /// - Throws: ``PokemonNotFound`` error if no Pokemon exists for the given name.
    func getSprite(pokemonName name: String) async throws -> Data
}

/// A ``PokemonSpriteLoader`` implementation that downloads sprite data from PokeAPI
public struct PokeAPISpriteLoader: PokemonSpriteLoader {
    
    private let client: HTTPClient
    
    /// Use this method to create a new instance of ``PokeAPISpriteLoader`` with a given ``HTTPClient``.
    ///
    /// ``HTTPClient`` is required since it is used to perform network requests to download Pokémon data.
    /// - Parameter client: The ``HTTPClient`` instance used for network requests.
    public init(client: HTTPClient) {
        self.client = client
    }
    
    /// Use this method to retrieve the image data of a Pokemon for a later representation.
    ///
    /// - Parameter name: The name of the Pokemon to search for.
    /// - Returns: The Pokemon sprite raw image `Data`.
    /// - Throws: ``PokemonNotFound`` error if no Pokemon exists for the given name.
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
