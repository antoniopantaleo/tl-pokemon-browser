//
//  FunTranslationsAPITests.swift
//  Pokespeare
//
//  Created by Antonio on 24/04/25.
//

import Testing
@testable import Pokespeare

@Suite("FunTranslationsAPI")
struct FunTranslationsAPITests {
    
    @Test("shakespeare endpoint gets correctly constructed")
    func pokemonEndpoint() {
        // Given
        let sut = FunTranslationsAPI.shakespeare(text: "hello world")
        // When
        let url = sut.url
        // Then
        #expect(url.absoluteString == "https://api.funtranslations.com/translate/shakespeare.json?text=hello%20world")
    }
    
}
