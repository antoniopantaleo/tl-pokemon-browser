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

public struct PokemonNotFound: Error {}


public struct RemotePokemonSpriteLoader: PokemonSpriteLoader {
    
    private let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public func getSprite(pokemonName name: String) async throws -> Data {
        let request = URLRequest(url: PokeAPI.pokemon(name: name).url)
        let detailResponse = try await client.perform(request: request)
        try validateResponse(detailResponse)
        let remotePokemonDetail = try JSONDecoder().decode(RemotePokemonDetail.self, from: detailResponse.data)
        guard let spriteURL = remotePokemonDetail.sprites.front_default else {
            return Data()
        }
        let spriteResponse = try await client.perform(request: URLRequest(url: spriteURL))
        try validateResponse(spriteResponse)
        return spriteResponse.data
    }
    
    private func validateResponse(_ response: Response) throws {
        switch response.statusCode {
            case 404: throw PokemonNotFound()
            case 200: return
            default: throw URLError(.badServerResponse)
        }
    }
}
