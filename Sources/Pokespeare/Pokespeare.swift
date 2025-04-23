import Foundation

protocol PokemonDescriptor {
    func getDescription(pokemonName name: String) async throws -> String
}

protocol PokemonSpriteLoader {
    func getSprite(pokemonName name: String) async throws -> Data
}

struct ShakespeareanPokemonDescriptor: PokemonDescriptor {
    
    /// inject HTTPClient
    /// call shared and internal module that can retrieve Pokemon info
    /// retrieve description from pokemon if any else throw pokemon not found error
    /// call translation api to retrieve shakesperian string
    /// return string
    
    func getDescription(pokemonName name: String) async throws -> String {
        ""
    }
}
