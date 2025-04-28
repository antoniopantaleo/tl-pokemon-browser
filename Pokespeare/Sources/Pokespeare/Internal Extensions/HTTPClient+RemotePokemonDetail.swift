//
//  HTTPClient+RemotePokemonDetail.swift
//  Pokespeare
//
//  Created by Antonio on 28/04/25.
//

import Foundation

public struct PokemonNotFound: Error {}

extension HTTPClient {
    func pokemonDetail(pokemonName name: String) async throws -> RemotePokemonDetail {
        let detailRequest = URLRequest(url: PokeAPI.pokemon(name: name).url)
        let detailResponse = try await perform(request: detailRequest)
        switch detailResponse.statusCode {
            case 404: throw PokemonNotFound()
            case 200: break
            default: throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(RemotePokemonDetail.self, from: detailResponse.data) 
    }
}
