//
//  HTTPClient+Extensions.swift
//  Pokespeare
//
//  Created by Antonio on 28/04/25.
//

import Foundation

extension HTTPClient {
    typealias StatusCodeValidation =  @Sendable (Int) -> Error?
    
    func dataValidatingResponse(for request: URLRequest, statusCodeValidation: StatusCodeValidation? = nil) async throws -> Data {
        let response = try await perform(request: request)
        if let mappedError = statusCodeValidation?(response.statusCode) {
            throw mappedError
        }
        guard response.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return response.data
        
    }
    
    func pokemonDetail(pokemonName name: String) async throws -> PokeAPIPokemonDetail {
        let detailRequest = URLRequest(url: PokeAPI.pokemon(name: name).url)
        let detailResponseData = try await dataValidatingResponse(
            for: detailRequest,
            statusCodeValidation: { statusCode in
                switch statusCode {
                    case 404: PokemonNotFound()
                    case 200: nil
                    default: URLError(.badServerResponse)
                }
            }
        )
        return try JSONDecoder().decode(PokeAPIPokemonDetail.self, from: detailResponseData)
    }
}
