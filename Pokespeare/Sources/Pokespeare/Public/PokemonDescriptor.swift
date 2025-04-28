//
//  PokemonDescriptor.swift
//  Pokespeare
//
//  Created by Antonio on 24/04/25.
//

import Foundation

/// A protocol that defines a method for retrieving Pokémon descriptions.
public protocol PokemonDescriptor: Sendable {
    /// Use this method to retrieve the textual description of a Pokemon.
    /// - Parameter name: The name of the Pokemon to search for.
    /// - Returns: The description of the Pokemon.
    /// - Throws: ``PokemonNotFound`` error if no Pokemon exists for the given name.
    func getDescription(pokemonName name: String) async throws -> String
}

/// An error type representing a situation where a Pokémon description is not available in English.
public struct NoEnglishDescriptionError: Error, Equatable {}

/// A ``PokemonDescriptor`` implementation that retrieves Pokémon descriptions and translates them into Shakespearean English.
public struct ShakespeareanPokemonDescriptor: PokemonDescriptor {
    
    private let client: HTTPClient
    
    /// Use this method to create a new instance of ``ShakespeareanPokemonDescriptor`` with a given ``HTTPClient``.
    ///
    /// ``HTTPClient`` is required since it is used to perform network requests to retrieve Pokémon data and translations.
    /// - Parameter client: The ``HTTPClient`` instance used for network requests.
    public init(client: HTTPClient) {
        self.client = client
    }
    
    /// Use this method to retrieve the textual description of a Pokemon.
    /// - Parameter name: The name of the Pokemon to search for.
    /// - Returns: The description of the Pokemon.
    /// - Throws: ``PokemonNotFound`` error if no Pokemon exists for the given name.
    public func getDescription(pokemonName name: String) async throws -> String {
        let remotePokemonDetail = try await client.pokemonDetail(pokemonName: name)
        let englishDescription = try await getPokemonSpeciesEnglishDescription(
            speciesURL: remotePokemonDetail.species.url
        )
        return try await getShakespeareanTranslation(of: englishDescription)
    }
    
    private func getPokemonSpeciesEnglishDescription(speciesURL: URL) async throws -> String  {
        let speciesRequest = URLRequest(url: speciesURL)
        let speciesResponseData = try await client.dataValidatingResponse(for: speciesRequest)
        let pokemonSpecies = try JSONDecoder().decode(
            RemotePokemonSpecies.self,
            from: speciesResponseData
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
        let translationResponseData = try await client.dataValidatingResponse(for: translationRequest)
        let translation = try JSONDecoder().decode(
            RemoteTranslationResponse.self,
            from: translationResponseData
        )
        return translation.contents.translated
    }

}
