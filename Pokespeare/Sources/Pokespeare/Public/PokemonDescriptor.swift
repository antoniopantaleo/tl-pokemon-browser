//
//  PokemonDescriptor.swift
//  Pokespeare
//
//  Created by Antonio on 24/04/25.
//

import Foundation

public protocol PokemonDescriptor: Sendable {
    func getDescription(pokemonName name: String) async throws -> String
}

public struct NoEnglishDescriptionError: Error, Equatable {}

public struct ShakespeareanPokemonDescriptor: PokemonDescriptor {
    
    private let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public func getDescription(pokemonName name: String) async throws -> String {
        let remotePokemonDetail = try await client.pokemonDetail(pokemonName: name)
        let englishDescription = try await getPokemonSpeciesEnglishDescription(
            speciesURL: remotePokemonDetail.species.url
        )
        return try await getShakespeareanTranslation(of: englishDescription)
    }
    
    private func getPokemonSpeciesEnglishDescription(speciesURL: URL) async throws -> String  {
        let speciesRequest = URLRequest(url: speciesURL)
        let speciesResponse = try await client.perform(request: speciesRequest)
        try validateResponse(speciesResponse)
        let pokemonSpecies = try JSONDecoder().decode(
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
        return description
    }
    
    private func getShakespeareanTranslation(of description: String) async throws -> String {
        let translationRequest = URLRequest(url: FunTranslationsAPI.shakespeare(
            text: description).url
        )
        let translationResponse = try await client.perform(request: translationRequest)
        try validateResponse(translationResponse)
        let translation = try JSONDecoder().decode(
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
