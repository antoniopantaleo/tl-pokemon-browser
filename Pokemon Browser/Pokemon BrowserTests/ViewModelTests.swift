//
//  ViewModelTests.swift
//  Pokemon BrowserTests
//
//  Created by Antonio on 27/04/25.
//

import Testing
import Foundation
@testable import Pokemon_Browser

@Suite("ViewModel")
struct ViewModelTests {

    @Test("search does not alter the search text")
    func doesNotAlterSearchText() async {
        // Given
        let browser = PokemonBrowserStub()
        let sut = ViewModel(browser: browser)
        sut.searchText = "Pikachu"
        // When
        sut.search()
        await resumingContinuation(of: browser) { continuation in
            continuation.resume(returning: ("Description", Data()))
        }
        // Then
        #expect(browser.searchedPokemonName == "Pikachu")
    }
    
    @Test("search resets search text after search")
    func resetSearchTextAfterSearch() async {
        // Given
        let browser = PokemonBrowserStub()
        let sut = ViewModel(browser: browser)
        sut.searchText = "Pikachu"
        // When
        #expect(sut.searchText == "Pikachu")
        sut.search()
        await resumingContinuation(of: browser) { continuation in
            continuation.resume(returning: ("Description", Data()))
        }
        // Then
        #expect(sut.searchText.isEmpty)
    }
    
    @Test("state changes from idle to loading to found")
    func idleToLoadingToFound() async throws {
        // Given
        let browser = PokemonBrowserStub()
        let sut = ViewModel(browser: browser)
        // When
        #expect(sut.state == .idle)
        sut.search()
        #expect(sut.state == .loading)
        await resumingContinuation(of: browser) { continuation in
            continuation.resume(returning: ("Description", Data("sprite data".utf8)))
        }
        // Then
        #expect(sut.state == .found(description: "Description", spriteData: Data("sprite data".utf8)))
    }
    
    
    //MARK: - Helpers
    
    private func resumingContinuation(
        of browser: PokemonBrowserStub,
        closure: (UnsafeContinuation<(String, Data), Error>) -> Void
    ) async {
        while browser.continuation == nil { await Task.yield() }
        closure(browser.continuation!)
        try? await Task.sleep(for: .milliseconds(500))
    }

}
