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
    
    private let browser: any PokemonBrowser
    
    init(browser: any PokemonBrowser) {
        self.browser = browser
    }
    
    func search() {
        state = .loading
        Task { [weak self] in
            defer { self?.searchText = "" }
            guard let self else { return }
            async let (description, sprite) = browser.search(pokemonName: searchText)
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
        }
    }
}
