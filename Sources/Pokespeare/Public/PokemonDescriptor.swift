//
//  PokemonDescriptor.swift
//  Pokespeare
//
//  Created by Antonio on 24/04/25.
//

import Foundation

public protocol PokemonDescriptor {
    func getDescription(pokemonName name: String) async throws -> String
}

public struct NoEnglishDescriptionError: Error, Equatable {}

public struct ShakespeareanPokemonDescriptor: PokemonDescriptor {
    
    private let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public func getDescription(pokemonName name: String) async throws -> String {
        lazy var decoder = JSONDecoder()
        let detailRequest = URLRequest(url: PokeAPI.pokemon(name: name).url)
        let detailResponse = try await client.perform(request: detailRequest)
        try validateResponse(detailResponse)
        let remotePokemonDetail = try decoder.decode(RemotePokemonDetail.self, from: detailResponse.data)
        let speciesRequest = URLRequest(url: remotePokemonDetail.species.url)
        let speciesResponse = try await client.perform(request: speciesRequest)
        try validateResponse(speciesResponse)
        let pokemonSpecies = try decoder.decode(
            RemotePokemonSpecies.self,
            from: speciesResponse.data
        )
        guard let description = pokemonSpecies.flavor_text_entries
            .first(where: { $0.language.name == "en" })?
            .flavor_text
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "\u{000C}", with: " ")
        else {
            throw NoEnglishDescriptionError()
        }
        let translationRequest = URLRequest(url: FunTranslationsAPI.shakespeare(
            text: description).url
        )
        let translationResponse = try await client.perform(request: translationRequest)
        try validateResponse(translationResponse)
        let translation = try decoder.decode(
            RemoteTranslationResponse.self,
            from: translationResponse.data
        )
        return translation.contents.translated
    }
    
    private func validateResponse(_ response: Response) throws {
        guard response.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }
}
