import Testing
@testable import Pokespeare

@Suite("PokeAPI")
struct PokeAPITests {
    
    @Test("/pokemon endpoint gets correctly constructed")
    func pokemonEndpoint() {
        // Given
        let sut = PokeAPI.pokemon(name: "any-pokemon")
        // When
        let url = sut.url
        // Then
        #expect(url.absoluteString == "https://pokeapi.co/api/v2/pokemon/any-pokemon")
    }
    
    @Test("/pokemon endpoint gets correctly URL-encoded")
    func pokemonEndpointURLEncoding() {
        // Given
        let sut = PokeAPI.pokemon(name: "any pokemon")
        // When
        let url = sut.url
        // Then
        #expect(url.absoluteString == "https://pokeapi.co/api/v2/pokemon/any%20pokemon")
    }
}
