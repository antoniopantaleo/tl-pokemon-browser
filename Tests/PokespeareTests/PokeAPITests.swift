import Testing
@testable import Pokespeare

@Suite("PokeAPI")
private struct Tests {
    
    @Test("/pokemon endpoint gets correctly constructed")
    func pokemonEndpoint() throws {
        // Given
        let sut = PokeAPI.pokemon(name: "any-pokemon")
        // When
        let url = try #require(sut.url)
        // Then
        #expect(url.absoluteString == "https://pokeapi.co/api/v2/pokemon/any-pokemon")
    }
    
    @Test("/pokemon endpoint gets correctly URL-encoded")
    func pokemonEndpointURLEncoding() throws {
        // Given
        let sut = PokeAPI.pokemon(name: "any pokemon")
        // When
        let url = try #require(sut.url)
        // Then
        #expect(url.absoluteString == "https://pokeapi.co/api/v2/pokemon/any%20pokemon")
    }
}
