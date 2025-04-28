//
//  ViewModel.swift
//  Pokemon Browser
//
//  Created by Antonio on 26/04/25.
//

import Foundation

@Observable
final class ViewModel {
    
    enum State: Equatable {
        case idle
        case loading
        case notFound(searchedQuery: String)
        case searchFailed(errorMessage: String)
        case found(description: String, spriteData: Data)
    }
    
    var searchText: String = ""
    
    private(set) var state: State = .idle
    var isLoading: Bool { state == .loading }
    var errorMessage: String? {
        guard case let .searchFailed(errorMessage) = state else { return nil }
        return errorMessage
    }
    
    private let browser: any PokemonBrowser
    
    init(browser: any PokemonBrowser) {
        self.browser = browser
    }
    
    func search() {
        state = .loading
        Task { [weak self] in
            guard let self else { return }
            async let (description, sprite) = browser.search(pokemonName: searchText)
            let state: State
            do {
                state = .found(
                    description: try await description,
                    spriteData: try await sprite
                )
            } catch let error as PokemonBrowserError {
                switch error {
                    case .pokemonNotFound:
                        state = .notFound(searchedQuery: searchText)
                }
            } catch {
                state = .searchFailed(errorMessage: error.localizedDescription)
            }
            await MainActor.run { [weak self, state] in
                self?.state = state
                self?.searchText = ""
            }
        }
    }
}
