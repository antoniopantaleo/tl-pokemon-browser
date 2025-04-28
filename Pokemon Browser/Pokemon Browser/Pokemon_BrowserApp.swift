//
//  Pokemon_BrowserApp.swift
//  Pokemon Browser
//
//  Created by Antonio on 25/04/25.
//

import SwiftUI
import Pokespeare

@main
struct Pokemon_BrowserApp: App {
    
    init() {
        UISearchBar.appearance().tintColor = .label
    }
    
    var body: some Scene {
        WindowGroup {
            let httpClient = URLSessionHTTPClient(session: .shared)
            let pokemonDescriptor = ShakespeareanPokemonDescriptor(client: httpClient)
            let pokemonSpriteLoader = PokeAPISpriteLoader(client: httpClient)
            
            let browser = PokespearePokemonBrowser(
                pokemonDescriptor: pokemonDescriptor,
                pokemonSpriteLoader: pokemonSpriteLoader
            )
            ContentView(
                viewModel: ViewModel(browser: browser)
            )
        }
    }
}
